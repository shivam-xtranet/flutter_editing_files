import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:js' as js;

class HtmlRenderScreem extends StatefulWidget {
  String indexFile;
  bool isCanvas = false;

  HtmlRenderScreem({super.key, required this.indexFile, this.isCanvas = false});

  @override
  State<HtmlRenderScreem> createState() => _HtmlRenderScreemState();
}

class _HtmlRenderScreemState extends State<HtmlRenderScreem> {
  InAppWebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editor")),
      body: Column(
        children: [
          // WebView (always shown)
          Expanded(
            child: InAppWebView(
              initialFile: widget.indexFile,
              onWebViewCreated: (controller) {
                _controller = controller;
              },
            ),
          ),

          // Control buttons (only if canvas mode)
          if (widget.isCanvas)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => callJsFunction("pauseAnimation();"),
                      child: const Text("Pause"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => callJsFunction("resumeAnimation();"),
                      child: const Text("Resume"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => callJsFunction("setSpeed(0.5);"),
                      child: const Text("Speed 0.5x"),
                    ),
                    const SizedBox(width: 8),
                    // ElevatedButton(
                    //   onPressed: () => callJsFunction("setSpeed(1);"),
                    //   child: const Text("Speed 1x"),
                    // ),
                    // const SizedBox(width: 8),
                    // ElevatedButton(
                    //   onPressed: () => callJsFunction("setSpeed(2);"),
                    //   child: const Text("Speed 2x"),
                    // ),
                    // const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed:
                          () => callJsFunction(
                            "showCustomAlert('This is a custom alert from Flutter!');",
                          ),
                      child: const Text("Show Alert"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _pause() => js.context.callMethod('pauseAnimation');
  void _resume() => js.context.callMethod('resumeAnimation');
  void _setSpeed(double speed) => js.context.callMethod('setSpeed', [speed]);
  void _showAlert(String message) =>
      js.context.callMethod('showCustomAlert', [message]);

  void callJsFunction(String jsCode) {
    if (_controller != null) {
      print("controller not null");

      _controller?.evaluateJavascript(source: jsCode);
    } else {
      print("controller null");
    }
  }
}
