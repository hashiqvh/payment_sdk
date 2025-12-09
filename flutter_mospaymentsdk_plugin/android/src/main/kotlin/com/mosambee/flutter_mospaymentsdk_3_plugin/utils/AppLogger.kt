package com.mosambee.flutter_mospaymentsdk_3_plugin.utils

import android.util.Log

object AppLogger {
    private const val DEFAULT_TAG = "FlutterPlugin"

    private val isDebug = true // false when releasing

    fun d(message: String?, tag: String = DEFAULT_TAG) {
        if (isDebug && !message.isNullOrEmpty()) {
            Log.d(tag, message)
        }
    }

    fun e(message: String?, tag: String = DEFAULT_TAG) {
        if (isDebug && !message.isNullOrEmpty()) {
            Log.e(tag, message)
        }
    }

    fun i(message: String?, tag: String = DEFAULT_TAG) {
        if (isDebug && !message.isNullOrEmpty()) {
            Log.i(tag, message)
        }
    }

    fun w(message: String?, tag: String = DEFAULT_TAG) {
        if (isDebug && !message.isNullOrEmpty()) {
            Log.w(tag, message)
        }
    }
}