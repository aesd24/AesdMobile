import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  CustomWebView({super.key, required this.url, this.title});

  String? title;
  String url;
  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {

  final _controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted);

  @override
  Widget build(BuildContext context) {
    _controller.loadRequest(Uri.parse(widget.url));
    
    return Scaffold(
      appBar: AppBar(title: widget.title != null ? Text(widget.title!) : null),
      body: WebViewWidget(controller: _controller)
    );
  }
}