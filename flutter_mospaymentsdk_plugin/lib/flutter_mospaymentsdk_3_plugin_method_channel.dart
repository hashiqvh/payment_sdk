import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'event/command_event.dart';
import 'event/failed_event.dart';
import 'event/success_event.dart';
import 'flutter_mospaymentsdk_3_plugin_platform_interface.dart';

/// An implementation of [FlutterMospaymentsdk3PluginPlatform] that uses method channels.
class MethodChannelFlutterMospaymentsdk3Plugin
    extends FlutterMospaymentsdk3PluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_mospaymentsdk_3_plugin');
  final transactionSuccessEventChannel = const EventChannel(
      'flutter_mospaymentsdk_3_plugin/on_transaction_success');
  final transactionFailedEventChannel =
      const EventChannel('flutter_mospaymentsdk_3_plugin/on_transaction_fail');
  final commandEventChannel = const EventChannel(
      'flutter_mospaymentsdk_3_plugin/on_transaction_command');

  Stream<CommandEvent>? _onCommand;
  Stream<SuccessEvent>? _onSuccess;
  Stream<FailedEvent>? _onFailed;

  @override
  Future<void> processAction(String action, Map<String, dynamic> params) async {
    await methodChannel.invokeMethod<void>(
        'processAction', {'action': action, 'params': params});
  }

  //Implementing stream fun for callback event
  @override
  Stream<SuccessEvent> get onSuccess {
    print(
        "receiveBroadcastStream ${transactionSuccessEventChannel.receiveBroadcastStream("on_transaction_success")}");
    return _onSuccess ??= transactionSuccessEventChannel
        .receiveBroadcastStream("on_transaction_success")
        .map<SuccessEvent>((event) {
      event as Map<Object?, Object?>;
      return SuccessEvent.fromMap(
        Map<String, dynamic>.of(event.cast<String, Object?>()),
      );
    });
  }

  @override
  Stream<FailedEvent> get onFailed {
    print(
        "receiveBroadcastStream ${transactionFailedEventChannel.receiveBroadcastStream("on_transaction_fail")}");
    return _onFailed ??= transactionFailedEventChannel
        .receiveBroadcastStream("on_transaction_fail")
        .map<FailedEvent>((event) {
      event as Map<Object?, Object?>;
      return FailedEvent.fromMap(
        Map<String, dynamic>.of(event.cast<String, Object?>()),
      );
    });
  }

  @override
  Stream<CommandEvent> get onCommand {
    print(
        "receiveBroadcastStream ${commandEventChannel.receiveBroadcastStream("on_transaction_command")}");
    return _onCommand ??= commandEventChannel
        .receiveBroadcastStream("on_transaction_command")
        .map<CommandEvent>((event) {
      event as Map<Object?, Object?>;
      return CommandEvent.fromMap(
        Map<String, dynamic>.of(event.cast<String, Object?>()),
      );
    });
  }
}
