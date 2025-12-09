import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'event/command_event.dart';
import 'event/failed_event.dart';
import 'event/success_event.dart';
import 'flutter_mospaymentsdk_3_plugin_method_channel.dart';

abstract class FlutterMospaymentsdk3PluginPlatform extends PlatformInterface {
  /// Constructs a FlutterMospaymentsdk3PluginPlatform.
  FlutterMospaymentsdk3PluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMospaymentsdk3PluginPlatform _instance =
      MethodChannelFlutterMospaymentsdk3Plugin();

  /// The default instance of [FlutterMospaymentsdk3PluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterMospaymentsdk3Plugin].
  static FlutterMospaymentsdk3PluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMospaymentsdk3PluginPlatform] when
  /// they register themselves.
  static set instance(FlutterMospaymentsdk3PluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> processAction(String action, Map<String, dynamic> params) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /////////////////Implementing Streams/////////////////////
  Stream<SuccessEvent> get onSuccess {
    throw UnimplementedError("");
  }

  Stream<FailedEvent> get onFailed {
    throw UnimplementedError("");
  }

  Stream<CommandEvent> get onCommand {
    throw UnimplementedError("");
  }
}
