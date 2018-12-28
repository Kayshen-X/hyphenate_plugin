package cn.kayshen.hyphenateplugin;

import android.content.Context;
import android.util.Log;

import com.hyphenate.EMCallBack;
import com.hyphenate.EMMessageListener;
import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMMessage;
import com.hyphenate.chat.EMOptions;
import com.hyphenate.chat.EMTextMessageBody;
import com.hyphenate.exceptions.HyphenateException;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * @author kayshen
 * @emil kayshen_xu@163.com
 * create on 2018/12/25
 */
public class HyphenateClient {
    private final String TAG = "HyphenateClient";


    public void initHyphenate(Context context, Result result, String appKey) {
        try {
            EMOptions options = new EMOptions();
            options.setAppKey(appKey);
            options.setAcceptInvitationAlways(false);
            EMClient.getInstance().init(context, options);
            EMClient.getInstance().setDebugMode(true);
            result.success("init success");
        } catch (Exception e) {
            Log.e(TAG, "init fail", e);
            result.error("init fail", null, e);
        }
    }

    public void createAccount(final String username, final String password, final Result result) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    EMClient.getInstance().createAccount(username, password);
                    result.success("create success");
                } catch (HyphenateException e) {
                    Log.e(TAG, "create fail", e);
                    result.error("create fail", "errorCode=" + e.getErrorCode(), e);
                }
            }
        }).start();
    }

    public void login(String username, String password, final Result result) {
        EMClient.getInstance().login(username, password, new EMCallBack() {//回调
            @Override
            public void onSuccess() {
                EMClient.getInstance().groupManager().loadAllGroups();
                EMClient.getInstance().chatManager().loadAllConversations();
                result.success("login success");
                Log.i("main", "login success!");
            }

            @Override
            public void onProgress(int progress, String status) {

            }

            @Override
            public void onError(int code, String message) {
                result.error("login fail", message + "\ncode:" + code, null);
                Log.i("main", "login fail:" + message + "code" + code);
            }
        });
    }

    public void logout(final Result result) {
        EMClient.getInstance().logout(true, new EMCallBack() {

            @Override
            public void onSuccess() {
                result.success("logout success");
                Log.i("main", "logout success!");
            }

            @Override
            public void onProgress(int progress, String status) {

            }

            @Override
            public void onError(int code, String message) {
                result.error("logout fail", message + "\ncode:" + code, null);
                Log.i("main", "logout fail:" + message + "code" + code);
            }
        });
    }

    public void sendTxtMsg(String toChatUsername, String content, boolean isGroupChat, Result result) {
        try {
            EMMessage message = EMMessage.createTxtSendMessage(content, toChatUsername);
            if (isGroupChat) {
                message.setChatType(EMMessage.ChatType.GroupChat);
            }
            EMClient.getInstance().chatManager().sendMessage(message);
            result.success("sendTxtMsg success");
        } catch (Exception e) {
            Log.e(TAG, "sendTxtMsg fail", e);
            result.error("sendTxtMsg fail", null, e);
        }
    }

    public void addEMMessageListener(final EventSink eventSink) {

        EMMessageListener msgListener = new EMMessageListener() {

            @Override
            public void onMessageReceived(List<EMMessage> messages) {
                for (EMMessage message : messages) {
                    if (message.getType().equals(EMMessage.Type.TXT)) {
                        EMTextMessageBody body = (EMTextMessageBody) message.getBody();
                        Map<String, String> event = new HashMap<>();
                        event.put("eventType", "onMessageReceived");
                        event.put("message", body.getMessage());
                        event.put("type","txt");
                        eventSink.success(event);
                    }
                }

            }

            @Override
            public void onCmdMessageReceived(List<EMMessage> messages) {

            }

            @Override
            public void onMessageRead(List<EMMessage> messages) {

            }

            @Override
            public void onMessageDelivered(List<EMMessage> messages) {

            }

            @Override
            public void onMessageChanged(EMMessage message, Object change) {

            }
        };
        EMClient.getInstance().chatManager().addMessageListener(msgListener);
    }


}
