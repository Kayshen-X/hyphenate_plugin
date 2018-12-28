import 'dart:async';

import 'package:flutter/services.dart';

class HyphenatePlugin {
  static HyphenatePlugin get instance => _getInstance();
  static HyphenatePlugin _instance;

  HyphenatePlugin._internal() {
    _eventSubscription =
        _eventChannel.receiveBroadcastStream().listen(_listener);
  }

  static HyphenatePlugin _getInstance() {
    if (_instance == null) {
      _instance = new HyphenatePlugin._internal();
    }
    return _instance;
  }

  static const MethodChannel _methodChannel =
      const MethodChannel('hyphenate_plugin/methods');
  static const EventChannel _eventChannel =
      const EventChannel('hyphenate_plugin/events');
  Function _onMessageReceived;

  StreamSubscription<dynamic> _eventSubscription;


  /* appKey:环信appKey */
  static Future<String> initSDK(appKey) async {
    String res;
    try {
      res = await _methodChannel.invokeMethod("initHyphenate",{"appKey":appKey});
    } catch (e) {
      print("init fail:$e");
      res = "inti fail";
    }
    print(res);
    return res;
  }

  /* username:用户名
   * password:密码 */
  static Future<String> createAccount(username, password) async {
    String res;
    try {
      res = await _methodChannel.invokeMethod(
          "createAccount", {"username": username, "password": password});
    } catch (e) {
      print("create fail:$e");
      res = "create fail";
    }
    print(res);
    return res;
  }

  /* username:用户名
   * password:密码 */
  static Future<String> login(username, password) async {
    String res;
    try {
      res = await _methodChannel
          .invokeMethod("login", {"username": username, "password": password});
    } catch (e) {
      print("login fail:$e");
      res = "login fail";
    }
    print(res);
    return res;
  }

  static Future<String> logout() async {
    String res;
    try {
      res = await _methodChannel.invokeMethod("logout");
    } catch (e) {
      print("logout fail:$e");
      res = "logout fail";
    }
    print(res);
    return res;
  }

  /* toChatUsername:消息接受方用户名
   * content:消息内容
   * isGroupChat:是否群聊 */
  static Future<String> sendTxtMsg(toChatUsername, content,isGroupChat) async {
    String res;
    try {
      res = await _methodChannel.invokeMethod("sendTxtMsg", {
        "toChatUsername": toChatUsername,
        "content": content,
        "isGroupChat": isGroupChat
      });
    } catch (e) {
      print("sendTxtMsg fail:$e");
      res = "sendTxtMsg fail";
    }
    print(res);
    return res;
  }

  void setOnMessageReceived(onMessageReceived) {
    this._onMessageReceived = onMessageReceived;
  }

  void _listener(dynamic event) {
    final Map<dynamic, dynamic> map = event;
    var eventType=map['eventType'];
    switch(eventType){
      case 'onMessageReceived':
         var msg=map['message'];
         var type=map['type'];
         this._onMessageReceived(msg,type);
        break;
    }
  }
}
