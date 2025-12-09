package com.mosambee.flutter_mospaymentsdk_3_plugin

import android.app.Activity
import android.content.Context
import com.mosambee.sdk.MosambeeBridge

object SDKInitialise {

    private lateinit var mosambeeBridge: MosambeeBridge

    fun initialize(activity: Activity) {
        if (!::mosambeeBridge.isInitialized) {
            mosambeeBridge = MosambeeBridge(activity)
        }
    }

    fun getMosambeeBridge(): MosambeeBridge {
        if (!::mosambeeBridge.isInitialized) {
            throw IllegalStateException("MosCallbackSingleton is not initialized yet.")
        }
        return mosambeeBridge
    }
}