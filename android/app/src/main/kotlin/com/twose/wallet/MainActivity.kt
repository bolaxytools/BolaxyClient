package com.twose.wallet

import android.os.Bundle
import android.util.Log
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONObject
import sdk.Sdk
import sdk.Transaction

class MainActivity : FlutterActivity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

//        WalletMethodChannel.create(this,flutterView).onMethodCall(object : MethodChannel.MethodCallHandler{
//
//            override fun onMethodCall(p0: MethodCall, p1: MethodChannel.Result) {
//                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
//            }
//        })


        //发送
        EventChannel(flutterView, "").setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p0: Any?, events: EventChannel.EventSink?) {
//                events?.success(getName())
            }

            override fun onCancel(p0: Any?) {

            }
        })

        //接受
        MethodChannel(flutterView, "com.twose.wallet").setMethodCallHandler { methodCall, result ->
            run {
                if (methodCall.method.equals("getString")) {
                    result.success("111")
                } else if (methodCall.method.equals("generatePrivateKey")) {
                    val str = Sdk.generatePrivateKey(methodCall.arguments as String?)
                    result.success(str)
                } else if (methodCall.method.equals("getMnemonicWords")) {
                    val jsonObj = JSONObject(methodCall.arguments.toString())
                    val mnemonic = Sdk.exportToMnemonicBip39(jsonObj.getString("serialized"), jsonObj.getString("password"))
                    result.success(mnemonic)
                } else if (methodCall.method.equals("generateTransaction")) {
                    val jsonObj = JSONObject(methodCall.arguments.toString())
                    val transaction = Transaction()
                    transaction.from = jsonObj.getString("from")
                    transaction.gasPrice = jsonObj.getString("gasPrice")
                    transaction.to = jsonObj.getString("to")
                    transaction.value = jsonObj.getString("value")
                    transaction.nonce = jsonObj.getLong("nonce")
                    transaction.gas = jsonObj.getLong("gas")

                    val mnemonic = Sdk.signTx(jsonObj.getString("json"), jsonObj.getString("password"), transaction)
                    result.success(mnemonic)
                } else if (methodCall.method.equals("signERC20Tx")) {
                    val jsonObj = JSONObject(methodCall.arguments.toString())
                    val transaction = Transaction()
                    transaction.from = jsonObj.getString("from")
                    transaction.gasPrice = jsonObj.getString("gasPrice")
                    transaction.to = jsonObj.getString("to")
                    transaction.value = jsonObj.getString("value")
                    transaction.nonce = jsonObj.getLong("nonce")
                    transaction.gas = jsonObj.getLong("gas")

                    val mnemonic = Sdk.signERC20Tx(jsonObj.getString("json"), jsonObj.getString("password"),
                            transaction, jsonObj.getString("to"), jsonObj.getString("unit"))
                    result.success(mnemonic)
                } else if (methodCall.method.equals("checkMnemonic")) {
                    val isValid = Sdk.isMnemonicValid(methodCall.arguments as String?)
                    result.success(isValid)
                } else if (methodCall.method.equals("importFromMnemonic")) {
                    val jsonObj = JSONObject(methodCall.arguments.toString())
                    val str = Sdk.importFromMnemonicBip39(jsonObj.getString("mnemonic"), jsonObj.getString("password"))
                    result.success(str)
                } else if (methodCall.method.equals("importKeystore")) {
                    val jsonObj = JSONObject(methodCall.arguments.toString())
                    val str = Sdk.importKeystore(jsonObj.getString("keystore"), jsonObj.getString("password"))
                    result.success(str)
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    fun getName(): String? = "flutter_library"

    fun refresh() {
//        showShort("refresh")
    }

}
