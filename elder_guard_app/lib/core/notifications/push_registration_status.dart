import 'package:elder_guard_app/core/notifications/models/push_registration_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PushRegistrationPhase {
  waitingForLogin,
  waitingForSubscription,
  registered,
  failed,
}

class PushRegistrationStatus {
  const PushRegistrationStatus({
    required this.phase,
    this.userId,
    this.subscriptionId,
    this.backendStatus,
    this.message,
  });

  const PushRegistrationStatus.waitingForLogin({this.subscriptionId})
    : phase = PushRegistrationPhase.waitingForLogin,
      userId = null,
      backendStatus = null,
      message = null;

  final PushRegistrationPhase phase;
  final String? userId;
  final String? subscriptionId;
  final String? backendStatus;
  final String? message;
}

final pushRegistrationStatusProvider =
    NotifierProvider<PushRegistrationStatusController, PushRegistrationStatus>(
      PushRegistrationStatusController.new,
    );

class PushRegistrationStatusController
    extends Notifier<PushRegistrationStatus> {
  @override
  PushRegistrationStatus build() {
    return const PushRegistrationStatus.waitingForLogin();
  }

  void setWaitingForLogin({String? subscriptionId}) {
    state = PushRegistrationStatus.waitingForLogin(
      subscriptionId: _normalize(subscriptionId),
    );
  }

  void setWaitingForSubscription({
    required String? userId,
    required String? subscriptionId,
  }) {
    state = PushRegistrationStatus(
      phase: PushRegistrationPhase.waitingForSubscription,
      userId: _normalize(userId),
      subscriptionId: _normalize(subscriptionId),
    );
  }

  void setRegistered(PushRegistrationResult result) {
    state = PushRegistrationStatus(
      phase: PushRegistrationPhase.registered,
      userId: result.userId,
      subscriptionId: result.playerId,
      backendStatus: result.status,
    );
  }

  void setFailure({
    required String? userId,
    required String? subscriptionId,
    required String message,
  }) {
    state = PushRegistrationStatus(
      phase: PushRegistrationPhase.failed,
      userId: _normalize(userId),
      subscriptionId: _normalize(subscriptionId),
      message: message,
    );
  }

  String? _normalize(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
