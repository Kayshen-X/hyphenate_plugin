package cn.kayshen.hyphenateplugin;

import android.content.Context;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.*;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * HyphenatePlugin
 */
public class HyphenatePlugin implements MethodCallHandler,StreamHandler {
    private HyphenateClient hyphenateClient = new HyphenateClient();
    private static Context flutterContext;
    private static Context activeFlutterContext;


    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel methodChannel = new MethodChannel(registrar.messenger(), "hyphenate_plugin/methods");
        methodChannel.setMethodCallHandler(new HyphenatePlugin());
        final EventChannel eventChannel=new EventChannel(registrar.messenger(),"hyphenate_plugin/events");
        eventChannel.setStreamHandler(new HyphenatePlugin());
        flutterContext = registrar.context();
        activeFlutterContext = registrar.activeContext();
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        String username = call.argument("username");
        String password = call.argument("password");
        String toChatUsername=call.argument("toChatUsername");
        Boolean isGroupChat= call.argument("isGroupChat")==null?false:(Boolean)call.argument("isGroupChat");
        switch (call.method) {
            case "initHyphenate":
                String appKey=call.argument("appKey");
                hyphenateClient.initHyphenate(flutterContext, result,appKey);
                break;
            case "createAccount":
                hyphenateClient.createAccount(username, password, result);
                break;
            case "login":
                hyphenateClient.login(username,password,result);
                break;
            case "logout":
                hyphenateClient.logout(result);
                break;
            case "sendTxtMsg":
                String content=call.argument("content");
                hyphenateClient.sendTxtMsg(toChatUsername,content,isGroupChat,result);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onListen(Object o, EventSink eventSink) {
        hyphenateClient.addEMMessageListener(eventSink);
    }

    @Override
    public void onCancel(Object o) {

    }

}
