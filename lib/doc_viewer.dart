import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DocViewerPage extends StatelessWidget {
  final String base64Doc;
  const DocViewerPage({required this.base64Doc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DOC Viewer")),
      body: InAppWebView(
        initialFile: "assets/doc_preview.html", // put your HTML in assets
        initialSettings: InAppWebViewSettings(
         javaScriptEnabled: true,
        ),
        onLoadStop: (controller, url) async {
          // call the JS function we added
          await controller.evaluateJavascript(
            source: "window.loadDocFromFlutter('${base64Doc}');",
          );
        },
      ),
    );
  }
}
