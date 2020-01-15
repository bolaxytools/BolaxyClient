package com.twose.wallet

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterView
import sdk.Sdk;

class WalletMethodChannel private constructor(private val context: Context, flutterView: FlutterView) : MethodChannel.MethodCallHandler {

    private val httpChannel: MethodChannel

    init {
        httpChannel = MethodChannel(flutterView, WALLET_CHANNEL)
        httpChannel.setMethodCallHandler(this)

    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {

    }

    companion object {

        private val WALLET_CHANNEL = "com.twose.wallet"

        /**
         * 暴露到外面的静态create类
         */
        fun create(context: Context, flutterView: FlutterView): WalletMethodChannel {
            return WalletMethodChannel(context, flutterView)
        }
    }

}
