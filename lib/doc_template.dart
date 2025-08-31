
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:docx_template/docx_template.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';


class DocxTemplateExample extends StatefulWidget {
  const DocxTemplateExample({super.key});

  @override
  _DocxTemplateExampleState createState() => _DocxTemplateExampleState();
}

class _DocxTemplateExampleState extends State<DocxTemplateExample> {
  String _status = 'No template loaded or file created yet';
  Uint8List? _templateBytes;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  // Function to load template and image from assets
  Future<void> _loadAssets() async {
    try {
      // Load template
      final templateData = await DefaultAssetBundle.of(context).load('assets/template.docx');
      final templateBytes = templateData.buffer.asUint8List();
      if (templateBytes.isEmpty) {
        throw Exception('Template file is empty or invalid');
      }
      debugPrint('Template loaded: ${templateBytes.length} bytes');

      // Load test image
      final imageData = await DefaultAssetBundle.of(context).load('assets/test.jpg');
      final imageBytes = imageData.buffer.asUint8List();
      if (imageBytes.isEmpty) {
        throw Exception('Image file is empty or invalid');
      }
      debugPrint('Image loaded: ${imageBytes.length} bytes');

      setState(() {
        _templateBytes = templateBytes;
        _imageBytes = imageBytes;
        _status = 'Assets loaded successfully';
      });
    } catch (e) {
      setState(() {
        _status = 'Error loading assets: $e';
        debugPrint('Error details: $e');
      });
      await _loadTemplateFromFilePicker();
    }
  }

  // Fallback function to load template using file_picker
  Future<void> _loadTemplateFromFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx'],
      );

      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        if (bytes.isEmpty) {
          throw Exception('Selected template file is empty or invalid');
        }
        debugPrint('Template loaded from file picker: ${bytes.length} bytes');
        setState(() {
          _templateBytes = bytes;
          _status = 'Template loaded from file picker successfully';
        });
      } else {
        setState(() {
          _status = 'No template selected via file picker';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error loading template from file picker: $e';
        debugPrint('Error details: $e');
      });
    }
  }

// Function to create and save a DOCX file from the template
  Future<void> _createDocxFromTemplate() async {
    if (_templateBytes == null || _imageBytes == null) {
      setState(() {
        _status = 'Assets not loaded. Please check configuration or upload a template.';
      });
      return;
    }

    try {
      // Validate template bytes
      if (_templateBytes!.length < 100) {
        throw Exception('Template file is too small or corrupted');
      }

      // Load the template
      final doc = await DocxTemplate.fromBytes(_templateBytes!);

      // Ensure lists are mutable
      final listNormal = <String>['Foo', 'Bar', 'Baz'];
      final listBold = <String>['ooF', 'raB', 'zaB'];
      final contentList = <Content>[];

      // Build content list dynamically
      final b = listBold.iterator;
      for (var n in listNormal) {
        b.moveNext();
        final c = PlainContent("value")
          ..add(TextContent("normal", n))
          ..add(TextContent("bold", b.current));
        contentList.add(c);
      }

      final content = Content()
  ..add(TextContent("docname", "Simple docname"));

  
final docBytes = await doc.generate(content);
      if (docBytes!.isEmpty) {
        throw Exception('Generated DOCX file is empty');
      }

        final Uint8List uint8Bytes = Uint8List.fromList(docBytes);


      // Save the file using file_saver (web-compatible)
      const String fileName = 'generated.docx';
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: uint8Bytes,
        fileExtension: 'docx',
        mimeType: MimeType.microsoftWord,
      );

      setState(() {
        _status = 'DOCX file created and saved as $fileName at ${DateTime.now()}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error creating file: $e';
      });
      debugPrint('Error details: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DOCX Template from Assets'),
        elevation: 4,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _status,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadTemplateFromFilePicker,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Template (Fallback)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _createDocxFromTemplate,
              icon: const Icon(Icons.save),
              label: const Text('Create and Save DOCX'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}