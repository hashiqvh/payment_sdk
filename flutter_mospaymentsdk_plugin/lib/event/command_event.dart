class CommandEvent {
  final String? action;
  final String? command;

  CommandEvent({this.action, this.command});

  factory CommandEvent.fromMap(Map<dynamic, dynamic> map) {
    return CommandEvent(
      action: map['action'] as String,
      command: map['command'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'command': command,
    };
  }
}