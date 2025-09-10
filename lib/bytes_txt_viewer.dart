import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';

class ByteTextViewer extends StatefulWidget {
  final bool editable;
  final dynamic bytes;
  const ByteTextViewer({super.key, required this.bytes, this.editable = false});

  @override
  State<ByteTextViewer> createState() => _ByteTextViewerState();
}

class _ByteTextViewerState extends State<ByteTextViewer> {
  String? text;

  @override
  void initState() {
    super.initState();

    text = decodeBytes(widget.bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width * 0.7,

      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child:
          widget.editable
              ? TextField(
                controller: TextEditingController(text: text),
                maxLines: null, // multiline
                decoration: const InputDecoration(border: InputBorder.none),
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              )
              : SingleChildScrollView(
                child: Text(
                  text ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  softWrap: true,
                ),
              ),
    );
  }

  String decodeBytes(dynamic data) {
    Uint8List bytes;

    if (data is String) {
      // Clean base64
      var s = data.trim().replaceAll(RegExp(r'\s+'), '');
      // Fix padding if missing
      final mod = s.length % 4;
      if (mod > 0) {
        s += '=' * (4 - mod);
      }
      bytes = base64Decode(s);
    } else if (data is Uint8List) {
      bytes = data;
    } else {
      throw ArgumentError('Expected Uint8List or base64 String');
    }

    // Decode bytes → text
    try {
      return utf8.decode(bytes, allowMalformed: true);
    } catch (_) {
      try {
        return latin1.decode(bytes);
      } catch (_) {
        return String.fromCharCodes(bytes);
      }
    }
  }
}
