import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PdfJsViewerPage extends StatefulWidget {
  final String pdfUrl;
  const PdfJsViewerPage({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  State<PdfJsViewerPage> createState() => _PdfJsViewerPageState();
}

class _PdfJsViewerPageState extends State<PdfJsViewerPage> {
  bool _isLoading = true;
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF.js Viewer')),
      body: Stack(
        children: [
          InAppWebView(
            initialFile: 'assets/pdf_viewer.html',
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStop: (controller, url) async {
              // HTML finished loading; now load the PDF
              await controller.evaluateJavascript(
                source: 'window.loadPdf("${widget.pdfUrl}");',
              );

              // hide spinner after short delay to allow first page render
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              });
            },
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
