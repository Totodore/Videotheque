import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'globals.dart';

class WebApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WebAppState();
  }
}

class WebAppState extends State<WebApp> {

  bool _displayLoading = true;
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {

    final WebAppRoute args = ModalRoute.of(context).settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return Future<bool>.value(false);
        } else
          return Future<bool>.value(true);
      },
      child: Scaffold(
        extendBody: false, 
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: GlobalsColor.lightBlue,
          ),
        ),
        body: Stack(
          fit: StackFit.passthrough,
          overflow: Overflow.clip,
          children: <Widget>[
              WebView(
                initialUrl: "https://app-videotheque.scriptis.fr?user="+args.user+"&pass="+args.pass,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  print("webView created");
                  _controller = webViewController;
                },
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith("https://app-videotheque.scriptis.fr/"))
                    return NavigationDecision.navigate;
                  else if (request.url == "about:blank") {
                    Navigator.popAndPushNamed(context, "/");
                    return NavigationDecision.prevent;
                  } else {
                    launch(request.url);
                    return NavigationDecision.prevent;
                  }
                },
                
                onPageFinished: (String url) {
                  setState(() {
                    _displayLoading = false;
                  });
                },
              ),
            Visibility(
              visible: _displayLoading,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: GlobalsColor.lightGreen,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                      child: SizedBox(
                        height: 2,
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(GlobalsColor.darkGreen)
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Chargement...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Aladin",
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: GlobalsColor.darkGreen
                        ), 
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebAppRoute {
  static const RouteName = "/webapp";
  
  final String user;
  final String pass;

  WebAppRoute(this.user, this.pass);
}