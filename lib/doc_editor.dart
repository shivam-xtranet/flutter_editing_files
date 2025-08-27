import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:docx_template/docx_template.dart';
import 'dart:html' as html; // For web download

class DocTemplateEditor extends StatefulWidget {
  const DocTemplateEditor({Key? key}) : super(key: key);

  @override
  State<DocTemplateEditor> createState() => _DocTemplateEditorState();
}

class _DocTemplateEditorState extends State<DocTemplateEditor> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDocTemplate();
  }

  Future<void> _loadDocTemplate() async {
    // Load .docx template from assets
    ByteData data = await rootBundle.load("asda.docx");
    final bytes = data.buffer.asUint8List();

    // Load the docx template
    final docx = await DocxTemplate.fromBytes(bytes);

    // Example: Extract a simple placeholder text
    // You normally use placeholders in template like ${name}
    _controller.text = "Edit this text..."; // Starting text

    setState(() {
      _loading = false;
    });
  }

  Future<void> _exportDoc() async {
    // Load the template again
    ByteData data = await rootBundle.load("asda.docx");
    final bytes = data.buffer.asUint8List();
    final docx = await DocxTemplate.fromBytes(bytes);

    // Replace placeholder with edited text
    Content c = Content();
    c.add(TextContent("name", _controller.text)); // assumes ${name} exists in template

    final d = await docx.generate(c);
    if (d == null) return;

    // Save/export for Web
    final blob = html.Blob([d]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "edited_template.docx")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doc Template Editor"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _exportDoc,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Edit Template Text",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Edit content here...",
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
