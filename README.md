# hyphenate_plugin
Flutter 环信 SDK (Flutter Easemob  SDK) 

## 已实现功能(Implemented function)
1. 初始化(init)
2. 注册(createAccount)
3. 登录(login)
4. 注销(logout)
5. 发送文字消息(sendTextMessage)
6. 接口文字信息(receiveTextMssage)

## 接口(API)
1. 初始化(init) </br>
`static Future<String> initSDK(appKey) async`
2. 注册(createAccount) </br>`static Future<String> createAccount(username, password) async`
3. 登录(login)</br> `static Future<String> login(username, password) async`
4. 注销(logout) </br>`static Future<String> logout() async`
5. 发送文字消息(sendTextMessage)</br> `Future<String> sendTxtMsg(toChatUsername, content, isGroupChat)`
6. 接口文字信息(receiveTextMssage) </br> ```void _onMessageReceived(msg,type)
HyphenatePlugin.instance.setOnMessageReceived(_onMessageReceived)```




