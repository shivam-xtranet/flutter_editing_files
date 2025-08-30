import 'package:flutter/material.dart';
import 'package:flutter_editing_files/doc_editor.dart';
import 'package:flutter_editing_files/doc_editor_html.dart';
import 'package:flutter_editing_files/doc_viewer.dart';
import 'package:flutter_editing_files/excel_editor.dart';
import 'package:flutter_editing_files/file_viewer.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //sample doc url - https://res.cloudinary.com/dlmt4hsgw/raw/upload/v1756289930/edited_4_yh4wfa.docx
  //sample xlss url - https://res.cloudinary.com/dlmt4hsgw/raw/upload/v1756282773/testappis_ixxfc9.xlsx

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late InAppWebViewController webViewController;

  var _urlController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            ElevatedButton(
              onPressed: () {
                _showUrlDialog(context);
              },
              child: Text('Excel editing'),
            ),

            SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder:
                        (context) => HtmlRenderScreem(
                          indexFile: "assets/my_canvas_html.html",
                          isCanvas: true,
                        ),
                  ),
                );
              },
              child: Text('Javascript Canvas'),
            ),

            SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => FileViewerPage(),
                  ),
                );
              },
              child: Text('File Viewer'),
            ),

            SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder:
                        (context) => HtmlRenderScreem(
                          indexFile: "assets/doc_editor.html",
                        ),
                  ),
                );
              },
              child: Text('Doc Editor'),
            ),

            SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder:
                        (context) => HtmlRenderScreem(
                          indexFile: "assets/pdf_editor.html",
                        ),
                  ),
                );
              },
              child: Text('PDF Editor'),
            ),

            SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder:
                        (context) => HtmlRenderScreem(
                          indexFile: "assets/pdf_editor_two.html",
                        ),
                  ),
                );
              },
              child: Text('PDF Editor Two'),
            ),

            SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder:
                        (context) => HtmlRenderScreem(
                          indexFile: "assets/custom_form.html",
                        ),
                  ),
                );
              },
              child: Text('Form.IO'),
            ),

            
            SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder:
                        (context) => DocViewerPage(
                          base64Doc: "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"
                        ),
                  ),
                );
              },
              child: Text('DOC Preview'),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _showUrlDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Open File via URL'),
          content: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // ensures compact sizing
                  children: [
                    Text(
                      'Enter the URL of a xlss file:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'https://example.com/file.xlss',
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_urlController.text.trim().isEmpty ||
                            !_urlController.text.trim().startsWith("http")) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter a valid URL')),
                          );
                        } else {
                          Navigator.of(dialogContext).pop(); // close the dialog

                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder:
                                  (context) => ExcelEditor(
                                    url: _urlController.text.trim(),
                                  ),
                            ),
                          );
                        }

                        // openWithGoogleViewer(_urlController.text.trim());
                      },
                      child: Text('Load'),
                    ),

                    
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel'),
            ),
          ],
          scrollable: true, // helps if content overflows
        );
      },
    );
  }
}
