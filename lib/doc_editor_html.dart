import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DocxEditorScreen extends StatefulWidget {
  const DocxEditorScreen({super.key});

  @override
  State<DocxEditorScreen> createState() => _DocxEditorScreenState();
}

class _DocxEditorScreenState extends State<DocxEditorScreen> {
  InAppWebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DOCX Editor")),
      body: InAppWebView(
        initialFile: "assets/doc_editor.html", // load local file
        onWebViewCreated: (controller) {
          _controller = controller;
        },
      ),
    );
  }
}
