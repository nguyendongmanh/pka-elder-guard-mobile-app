import 'package:elder_guard_app/features/notifications/data/events_api_service.dart';
import 'package:elder_guard_app/features/notifications/data/models/event_read.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  return RemoteEventsRepository(ref.watch(eventsApiServiceProvider));
});

abstract class EventsRepository {
  Future<List<EventRead>> listEvents();

  Future<EventRead> getEvent(int eventId);
}

class RemoteEventsRepository implements EventsRepository {
  const RemoteEventsRepository(this._apiService);

  final EventsApiService _apiService;

  @override
  Future<EventRead> getEvent(int eventId) {
    return _apiService.getEvent(eventId);
  }

  @override
  Future<List<EventRead>> listEvents() {
    return _apiService.listEvents();
  }
}
