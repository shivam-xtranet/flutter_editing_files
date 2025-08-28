import 'package:flutter/material.dart';
import 'dart:js' as js;

import 'package:url_launcher/url_launcher.dart';

class FileViewerPage extends StatefulWidget {
  @override
  _FileViewerPageState createState() => _FileViewerPageState();
}

class _FileViewerPageState extends State<FileViewerPage> {
  final TextEditingController _urlController = TextEditingController();

  void openWithGoogleViewer(String fileUrl) {
    if (!fileUrl.startsWith('http')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a valid URL')));
      return;
    }

    //  G Drive viewer
    final viewerUrl =
        'https://docs.google.com/gview?embedded=true&url=$fileUrl';

    //can use below  url also for doc,ppt,xlss
    // //   Microsoft Office viewer
    // final viewerUrl =
    //     'https://view.officeapps.live.com/op/embed.aspx?src=$fileUrl';

    // Open in new tab using JavaScript
    // js.context.callMethod('open', ["$viewerUrl"]);

    // Open in new tab using url launcher
    openUrl(viewerUrl);
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, webOnlyWindowName: '_blank')) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Enter the URL of a PDF or DOC file:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'https://example.com/file.pdf',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  openWithGoogleViewer(_urlController.text.trim());
                },
                child: Text('Open with Google Viewer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
