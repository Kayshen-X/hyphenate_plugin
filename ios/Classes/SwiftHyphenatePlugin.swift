import Flutter
import UIKit

public class SwiftHyphenatePlugin: NSObject, FlutterPlugin,FlutterStreamHandler,EMChatManagerDelegate{
    
    
    private var flutterResult : FlutterResult?
    private var flutterEventSink : FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "hyphenate_plugin/methods", binaryMessenger: registrar.messenger())
        let eventChannel=FlutterEventChannel(name: "hyphenate_plugin/events", binaryMessenger: registrar.messenger())
        let instance = SwiftHyphenatePlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
    }
    

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        flutterResult=result;
        let method=call.method;
        let arguments=call.arguments as? NSDictionary
        let username=arguments?["username"] as? String;
        let password=arguments?["password"] as? String;
        let toChatUsername=arguments?["toChatUsername"] as? String;
        let isGroupChat=arguments?["isGroupChat"] as? Bool;
        switch method {
        case "initHyphenate":
            let appKey=arguments?["appKey"] as? String;
            initSDK(result: result,appKey:appKey ?? "");
            break;
        case "createAccount":
            createAccount(result: result, username: username ?? "", password: password ?? "");
            break;
        case "login":
            login(result: result, username: username ?? "", password: password ?? "");
            break;
        case "logout":
            logout(result: result);
            break;
        case "sendTxtMsg":
            let content=arguments?["content"] as! String;
            sendTxtMsg(result: result, toChatUsername: toChatUsername!, content: content, isGroupChat: isGroupChat!);
            break;
        default:
            result("notImplemented");
        }
    }
    
    
    private func initSDK(result: @escaping FlutterResult,appKey:String){
        let options=EMOptions.init(appkey:appKey);
        let error=EMClient.shared()?.initializeSDK(with: options);
        if error==nil{
            result("init success");
        }else{
            result("init fail"+(error?.errorDescription ?? ""));
        }
    }
    
    private func login(result: @escaping FlutterResult,username:String,password:String){
        let error=EMClient.shared()?.login(withUsername: username, password: password);
        if error==nil{
            result("login success");
        }else{
            result("login fail"+(error?.errorDescription ?? ""));
        }
    }
    
    private func createAccount(result: @escaping FlutterResult,username:String,password:String){
        let error=EMClient.shared()?.register(withUsername: username, password: password)
        if error==nil{
            result("create success");
        }else{
            result("create fail"+(error?.errorDescription ?? ""));
        }
    }
    
    private func logout(result: @escaping FlutterResult){
        let error=EMClient.shared()?.logout(true);
        if error==nil{
            result("logout success");
        }else{
            result("logout fail"+(error?.errorDescription ?? ""));
        }
    }
    
    private func sendTxtMsg(result: @escaping FlutterResult,toChatUsername:String,content:String,isGroupChat:Bool){
        let msgBody=EMTextMessageBody.init(text: content);
        let from=EMClient.shared()?.currentUsername;
        let conversationID = "\(arc4random() % 10000)";
        let msg=EMMessage.init(conversationID:conversationID , from: from, to: toChatUsername, body: msgBody, ext: nil);
        msg?.chatType=isGroupChat ?EMChatTypeGroupChat:EMChatTypeChat;
        sendMsg(msg: msg!, isGroupChat: isGroupChat);
    }
    
    private func sendMsg(msg:EMMessage,isGroupChat:Bool){
        let type=isGroupChat ?EMConversationTypeChat:EMConversationTypeGroupChat;
        let conversation = EMClient.shared()?.chatManager.getConversation(msg.conversationId,type: type, createIfNotExist: true)
            conversation?.insert(msg, error:nil)
        EMClient.shared()?.chatManager.send(msg, progress: nil, completion:onCompletion)
    }
    
    private func onCompletion(msg:EMMessage?,err:EMError?){
        if(err==nil){
            flutterResult!("sendTxtMsg success");
        }else{
            flutterResult!("sendTxtMsg fail"+(err?.errorDescription ?? ""));
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        flutterEventSink=events;
        EMClient.shared()?.chatManager.add(self, delegateQueue:nil);
        return nil;
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        EMClient.shared()?.chatManager.remove(self)
        return nil;
    }
    
 
    public func messagesDidReceive(_ aMessages: [Any]!) {
        for message in aMessages {
            let msg=message as! EMMessage;
            let msgBody=msg.body;
            switch(msgBody?.type){
            case EMMessageBodyTypeText:
                let textBody=msgBody as! EMTextMessageBody
                let txt=textBody.text;
                let dic=["eventType":"onMessageReceived","message":txt,"type":"txt"];
                flutterEventSink!(dic);
                break
            default:
                break
            }
        }
    }
    
}
