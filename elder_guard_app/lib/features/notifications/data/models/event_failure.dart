enum EventFailureCode { network, notFound, server }

class EventFailure implements Exception {
  const EventFailure(this.code, {this.message});

  final EventFailureCode code;
  final String? message;
}
