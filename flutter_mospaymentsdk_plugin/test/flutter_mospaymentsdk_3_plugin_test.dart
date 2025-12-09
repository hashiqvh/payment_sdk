import 'package:flutter_mospaymentsdk_3_plugin/event/command_event.dart';
import 'package:flutter_mospaymentsdk_3_plugin/event/failed_event.dart';
import 'package:flutter_mospaymentsdk_3_plugin/event/success_event.dart';
import 'package:flutter_mospaymentsdk_3_plugin/flutter_mospaymentsdk_3_plugin_method_channel.dart';
import 'package:flutter_mospaymentsdk_3_plugin/flutter_mospaymentsdk_3_plugin_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterMospaymentsdk3PluginPlatform
    with MockPlatformInterfaceMixin
    implements FlutterMospaymentsdk3PluginPlatform {
  @override
  // TODO: implement onCommand
  Stream<CommandEvent> get onCommand => throw UnimplementedError();

  @override
  // TODO: implement onFailed
  Stream<FailedEvent> get onFailed => throw UnimplementedError();

  @override
  // TODO: implement onSuccess
  Stream<SuccessEvent> get onSuccess => throw UnimplementedError();

  @override
  Future<void> processAction(String action, Map<String, dynamic> params) {
    // TODO: implement processAction
    throw UnimplementedError();
  }
}

void main() {
  final FlutterMospaymentsdk3PluginPlatform initialPlatform =
      FlutterMospaymentsdk3PluginPlatform.instance;

  test('$MethodChannelFlutterMospaymentsdk3Plugin is the default instance', () {
    expect(initialPlatform,
        isInstanceOf<MethodChannelFlutterMospaymentsdk3Plugin>());
  });
}
