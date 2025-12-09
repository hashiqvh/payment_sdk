import 'event/command_event.dart';
import 'event/failed_event.dart';
import 'event/success_event.dart';
import 'flutter_mospaymentsdk_3_plugin_platform_interface.dart';

export 'utils/action_enum.dart';
export 'utils/user_request.dart';

class FlutterMospaymentsdk3Plugin {
  Future<void> processAction(String action, Map<String, dynamic> params) =>
      FlutterMospaymentsdk3PluginPlatform.instance
          .processAction(action, params);

  Stream<SuccessEvent> get onSuccess {
    return FlutterMospaymentsdk3PluginPlatform.instance.onSuccess;
  }

  Stream<FailedEvent> get onFailed {
    return FlutterMospaymentsdk3PluginPlatform.instance.onFailed;
  }

  Stream<CommandEvent> get onCommand {
    return FlutterMospaymentsdk3PluginPlatform.instance.onCommand;
  }
}
