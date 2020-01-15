package wallet;


import android.content.Context;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterView;

public class WalletMethodChannel implements MethodChannel.MethodCallHandler {

    private static final String WALLET_CHANNEL = "com.twose.wallet";

    private MethodChannel httpChannel;

    private Context context;

    private WalletMethodChannel(Context context, FlutterView flutterView) {
        this.context = context;
        httpChannel = new MethodChannel(flutterView, WALLET_CHANNEL);
        httpChannel.setMethodCallHandler(this);

    }

    /**
     * 暴露到外面的静态create类
     */
    public static WalletMethodChannel create(Context context, FlutterView flutterView) {
        return new WalletMethodChannel(context, flutterView);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

    }

}
