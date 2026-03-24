import 'dart:async';

import 'package:elder_guard_app/core/localization/locale_controller.dart';
import 'package:elder_guard_app/core/notifications/device_notification_service.dart';
import 'package:elder_guard_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:elder_guard_app/features/notifications/data/events_repository.dart';
import 'package:elder_guard_app/features/notifications/data/models/event_read.dart';
import 'package:elder_guard_app/features/notifications/presentation/utils/event_notification_content.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventNotificationsControllerProvider = AutoDisposeAsyncNotifierProvider<
  EventNotificationsController,
  List<EventRead>
>(EventNotificationsController.new);

final eventDetailProvider = FutureProvider.autoDispose.family<EventRead, int>((
  ref,
  eventId,
) {
  return ref.watch(eventsRepositoryProvider).getEvent(eventId);
});

class EventNotificationsController
    extends AutoDisposeAsyncNotifier<List<EventRead>> {
  static const Duration _pollInterval = Duration(seconds: 20);

  Timer? _pollTimer;
  final Set<int> _knownEventIds = <int>{};
  bool _hasCompletedInitialLoad = false;
  bool _isDisposed = false;

  @override
  Future<List<EventRead>> build() async {
    ref.keepAlive();
    ref.onDispose(_dispose);

    final isAuthenticated = ref.watch(
      authControllerProvider.select((state) => state.isAuthenticated),
    );

    if (!isAuthenticated) {
      _stopPolling();
      _knownEventIds.clear();
      _hasCompletedInitialLoad = false;
      return const <EventRead>[];
    }

    _startPolling();
    return _loadEvents(notifyOnNew: false);
  }

  Future<void> refresh() async {
    try {
      final events = await _loadEvents(notifyOnNew: _hasCompletedInitialLoad);
      if (_isDisposed) {
        return;
      }

      state = AsyncData(events);
    } on Object catch (error, stackTrace) {
      if (_isDisposed) {
        return;
      }

      if (state.valueOrNull == null) {
        state = AsyncError(error, stackTrace);
      }
    }
  }

  Future<List<EventRead>> _loadEvents({required bool notifyOnNew}) async {
    final repository = ref.read(eventsRepositoryProvider);
    final events = await repository.listEvents();

    final previousIds = Set<int>.from(_knownEventIds);
    _knownEventIds
      ..clear()
      ..addAll(events.map((event) => event.id));

    if (notifyOnNew) {
      final newEvents = events
          .where((event) => !previousIds.contains(event.id))
          .toList(growable: false)
          .reversed
          .toList(growable: false);
      await _showNotificationsFor(newEvents);
    }

    _hasCompletedInitialLoad = true;
    return events;
  }

  Future<void> _showNotificationsFor(List<EventRead> events) async {
    if (events.isEmpty) {
      return;
    }

    final locale = ref.read(localeControllerProvider);
    final l10n = lookupAppLocalizations(locale);
    final deviceNotificationService = ref.read(
      deviceNotificationServiceProvider,
    );

    for (final event in events) {
      await deviceNotificationService.showEventNotification(
        eventId: event.id,
        title: EventNotificationContent.title(l10n, event),
        body: EventNotificationContent.body(l10n, event),
      );
    }
  }

  void _startPolling() {
    _pollTimer ??= Timer.periodic(_pollInterval, (_) {
      unawaited(_pollForUpdates());
    });
  }

  Future<void> _pollForUpdates() async {
    try {
      final events = await _loadEvents(notifyOnNew: true);
      if (_isDisposed) {
        return;
      }

      state = AsyncData(events);
    } on Object catch (error, stackTrace) {
      if (_isDisposed || state.valueOrNull != null) {
        return;
      }

      state = AsyncError(error, stackTrace);
    }
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  void _dispose() {
    _isDisposed = true;
    _stopPolling();
  }
}
