package com.mosambee.flutter_mospaymentsdk_3_plugin

import android.annotation.SuppressLint
import android.app.Activity
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import com.mosambee.flutter_mospaymentsdk_3_plugin.interfaces.TransactionResultHandler
import com.mosambee.flutter_mospaymentsdk_3_plugin.utils.AppLogger
import com.mosambee.sdk.Action
import com.mosambee.sdk.MosambeeBridge
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

/** FlutterMospaymentsdk3Plugin */
class FlutterMospaymentsdk3Plugin: FlutterPlugin, MethodCallHandler, ActivityAware, EventChannel.StreamHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  var mActivity: Activity? = null
  var mosambeeBridge : MosambeeBridge? = null
  var mTransactionResultHandler: TransactionResultHandler? = null

  private lateinit var channel : MethodChannel
  private lateinit var successEventChannel : EventChannel
  private lateinit var failedEventChannel : EventChannel
  private lateinit var commandEventChannel: EventChannel

  private var successEventSink: EventSink? = null
  private var failedEventSink: EventSink? = null
  private var commandEventSink: EventSink? = null

  val mainHandler = Handler(Looper.getMainLooper())

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_mospaymentsdk_3_plugin")
    channel.setMethodCallHandler(this)

    successEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_mospaymentsdk_3_plugin/on_transaction_success")
    successEventChannel.setStreamHandler(this)

    failedEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_mospaymentsdk_3_plugin/on_transaction_fail")
    failedEventChannel.setStreamHandler(this)

    commandEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_mospaymentsdk_3_plugin/on_transaction_command")
    commandEventChannel.setStreamHandler(this)

    initTransactionResultHandler()
  }

  private fun initTransactionResultHandler() {
    mTransactionResultHandler = object : TransactionResultHandler {

      override
      fun onCommand(p0: Action?, p1: String?) {
        AppLogger.d("Command received: $p1")
        mainHandler.post {
          commandEventSink?.success(mapOf(
            "action" to p0?.name,
            "command" to p1
          ))
        }
      }

      override fun onSuccess(p0: Action?, p1: JSONObject?, p2: Boolean) {
        AppLogger.d("onSuccess received: $p0  $p1")
        mainHandler.post {
          successEventSink?.success(mapOf(
            "action" to p0?.name,
            "result" to p1.toString(),
            "isAckRequired" to p2
          ))
        }
      }

      override fun onFailure(p0: Action?, p1: String?, p2: String?, p3: JSONObject?) {
        AppLogger.d("onFailure received:  $p0  $p1")
        mainHandler.post {
          failedEventSink?.success(mapOf(
            "action" to p0?.name,
            "reason" to p1,
            "reasonCode" to p2,
            "result" to p3.toString()
          ))
        }
      }

    }

  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    SDKInitialise.initialize(mActivity!!)
    mosambeeBridge = SDKInitialise.getMosambeeBridge()
    mosambeeBridge!!.setProcessResult(mTransactionResultHandler)

    when (call.method) {
      "processAction" -> {
        val action = call.argument<String>("action") ?: ""
        val paramMap = call.argument<Map<String, Any>>("params") ?: emptyMap()
        AppLogger.d("Received startTransaction with action = $action and params = $paramMap")
        val bundle = mapToBundle(paramMap)
        startTransaction(action, bundle)
        result.success("Transaction started")
      }
      else -> {
        AppLogger.d("Method not implemented: ${call.method}")
        result.notImplemented()
      }
    }
  }

//  private fun mapToBundle(map: Map<String, String>): Bundle {
//    return Bundle().apply {
//      map.forEach { (key, value) ->
//        putString(key, value)
//
//      }
//    }
//  }

  private fun mapToBundle(map: Map<String, Any?>): Bundle {
    val bundle = Bundle()
    map.forEach { (key, value) ->
      when (value) {
        null -> bundle.putString(key, null)
        is String -> bundle.putString(key, value)
        is Int -> bundle.putInt(key, value)
        is Boolean -> bundle.putBoolean(key, value)
        is Float -> bundle.putFloat(key, value)
        is Double -> bundle.putDouble(key, value)
        is Long -> bundle.putLong(key, value)
        is Short -> bundle.putShort(key, value)
        is Byte -> bundle.putByte(key, value)
        is Char -> bundle.putChar(key, value)
        is Bundle -> bundle.putBundle(key, value)
        else -> throw IllegalArgumentException("Unsupported value type: ${value::class.java} for key: $key")
      }
    }
    return bundle
  }


  private fun startTransaction(action: String, bundle: Bundle) {
    mosambeeBridge!!.processActionable(Action.valueOf(action), bundle)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    successEventChannel.setStreamHandler(null)
    failedEventChannel.setStreamHandler(null)
    commandEventChannel.setStreamHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    setActivity(binding.activity)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    setActivity(null)
  }


  @SuppressLint("SuspiciousIndentation")
  fun setActivity(activity: Activity?) {
    mActivity = activity
  }

  //Event stream handler methods
  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    AppLogger.d("event argument : $arguments")
    when(arguments) {
      "on_transaction_success" -> successEventSink = events
      "on_transaction_fail" -> failedEventSink = events
      "on_transaction_command" -> commandEventSink = events
    }
  }

  override fun onCancel(arguments: Any?) {
    when(arguments) {
      "on_transaction_success" -> successEventSink = null
      "on_transaction_fail" -> failedEventSink = null
      "on_transaction_command" -> commandEventSink = null
    }
  }


}
