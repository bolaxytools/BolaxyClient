import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Browser extends StatelessWidget {
  String url;
  String title;

  Browser(this.url, this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title != null ? title : ""),
      ),
      body: WebView(
        initialUrl: url,
//        initialUrl: "https://www.baidu.com",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
