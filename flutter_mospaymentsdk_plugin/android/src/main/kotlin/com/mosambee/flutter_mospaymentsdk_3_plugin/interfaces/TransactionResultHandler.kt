package com.mosambee.flutter_mospaymentsdk_3_plugin.interfaces


import com.mosambee.sdk.Action
import com.mosambee.sdk.ProcessResult
import org.json.JSONObject

interface TransactionResultHandler : ProcessResult {
    override fun onCommand(p0: Action?, p1: String?) {

    }

    override fun onSuccess(p0: Action?, p1: JSONObject?, p2: Boolean) {

    }

    override fun onFailure(p0: Action?, p1: String?, p2: String?, p3: JSONObject?) {

    }

}