class SuccessEvent {
  final String? action;
  final dynamic result;
  final bool? isAckRequired;

  SuccessEvent({this.action, this.result, this.isAckRequired});

  factory SuccessEvent.fromMap(Map<dynamic, dynamic> map) {
    return SuccessEvent(
      action: map['action'] as String,
      isAckRequired: map['isAckRequired'] as bool,
      result: map['result'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'isAckRequired': isAckRequired,
      'result': result,
    };
  }
}