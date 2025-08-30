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
                          base64Doc: "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",
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
