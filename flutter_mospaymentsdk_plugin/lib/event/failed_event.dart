class FailedEvent {
  final String? action;
  final String? reasonCode;
  final String? reason;
  final dynamic result;

  FailedEvent({this.action, this.reasonCode, this.reason, this.result});

  factory FailedEvent.fromMap(Map<dynamic, dynamic> map) {
    return FailedEvent(
      action: map['action'] as String,
      reasonCode: map['reasonCode'] as String?,
      reason: map['reason'] as String?,
      result: map['result'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'reasonCode': reasonCode,
      'reason': reason,
      'result': result,
    };
  }
}