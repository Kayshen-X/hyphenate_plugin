import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hyphenate_plugin/hyphenate_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
     HyphenatePlugin.initSDK("1112181225181694#demo");
    HyphenatePlugin.instance.setOnMessageReceived(_onMessageReceived);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: FlatButton(
                  onPressed: () =>
                      HyphenatePlugin.login("kayshen", "1234556"),
                  child: Text("login")),
            ),
            Center(
              child: FlatButton(onPressed: ()=>HyphenatePlugin.logout(), child: Text("logout")),
            ),
            Center(
              child: FlatButton(onPressed: ()=>HyphenatePlugin.sendTxtMsg("kayshen", "test", false), child: Text("sendMsg")),

            )
          ],
        )),
      ),
    );
  }

  void _onMessageReceived(msg,type){
    print(msg);
    print(type);
  }
}


