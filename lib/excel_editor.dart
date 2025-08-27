import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pluto_grid/pluto_grid.dart';
import 'dart:html' as html; // 👈 for download in web

class ExcelEditor extends StatefulWidget {
  const ExcelEditor({Key? key}) : super(key: key);

  @override
  State<ExcelEditor> createState() => _ExcelEditorState();
}

class _ExcelEditorState extends State<ExcelEditor> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  late Excel excel;

  @override
  void initState() {
    super.initState();
    // loadExcelFromAssets();
    loadExcelFromUrl("https://res.cloudinary.com/dlmt4hsgw/raw/upload/v1756282773/testappis_ixxfc9.xlsx");
  }

  Future<void> loadExcelFromUrl(String url) async {

    print("loadExcelFromUrl");
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var bytes = response.bodyBytes;
      excel = Excel.decodeBytes(bytes);

      var sheet = excel.tables[excel.tables.keys.first]!;
      List<List<Data?>> sheetData = sheet.rows;

      List<PlutoColumn> cols = [];
      for (int i = 0; i < sheetData.first.length; i++) {
        final cellValue = sheetData.first[i]?.value ?? '';
        cols.add(
          PlutoColumn(
            title: cellValue.toString(),
            field: 'col$i',
            type: PlutoColumnType.text(),
          ),
        );
      }

      List<PlutoRow> plutoRows = [];
      for (int r = 1; r < sheetData.length; r++) {
        plutoRows.add(
          PlutoRow(
            cells: {
              for (int c = 0; c < sheetData[r].length; c++)
                'col$c': PlutoCell(value: sheetData[r][c]?.value?.toString() ?? ''),
            },
          ),
        );
      }

      setState(() {
        columns = cols;
        rows = plutoRows;
      });
    } else {
      print("Failed to load Excel file: ${response.statusCode}");
    }
  } catch (e) {
    print("Error loading Excel: $e");
  }
}

  Future<void> loadExcelFromAssets() async {
    ByteData data = await rootBundle.load('assets/sample.xlsx');
    var bytes = data.buffer.asUint8List();
    excel = Excel.decodeBytes(bytes);

    var sheet = excel.tables[excel.tables.keys.first]!;
    List<List<Data?>> sheetData = sheet.rows;

    List<PlutoColumn> cols = [];
    for (int i = 0; i < sheetData.first.length; i++) {
      final cellValue = sheetData.first[i]?.value ?? '';
      cols.add(
        PlutoColumn(
          title: cellValue.toString(),
          field: 'col$i',
          type: PlutoColumnType.text(),
        ),
      );
    }

    List<PlutoRow> plutoRows = [];
    for (int r = 1; r < sheetData.length; r++) {
      plutoRows.add(
        PlutoRow(
          cells: {
            for (int c = 0; c < sheetData[r].length; c++)
              'col$c': PlutoCell(value: sheetData[r][c]?.value?.toString() ?? ''),
          },
        ),
      );
    }

    setState(() {
      columns = cols;
      rows = plutoRows;
    });
  }

void saveExcelWeb(List<PlutoRow> rows, List<PlutoColumn> columns, String sheetName) {
    // Create a fresh Excel object every time
  final excel = Excel.createExcel();
  final sheet = excel[sheetName];

  // Add headers
  List<String> headers = columns.map((c) => c.title).toList();
    print("Headers: $headers"); // 👈 Print headers to console

  sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());

  // Add rows
  for (PlutoRow row in rows) {
    final rowValues = row.cells.values.map((cell) => cell.value.toString()).toList();
    print("Row: $rowValues"); // 👈 Print each row to console
    sheet.appendRow(
      rowValues.map((v) => TextCellValue(v)).toList(),
    );
  }

  // Convert to bytes
  final bytes = excel.encode()!;

  // Trigger browser download
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "edited.xlsx")
    ..click();
  html.Url.revokeObjectUrl(url);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Excel Editor (Web)"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: ()=>saveExcelWeb(rows, columns, "Sheet1"),
          )
        ],
      ),
      body: columns.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PlutoGrid(
              columns: columns,
              rows: rows,
              onChanged: (PlutoGridOnChangedEvent event) {
                print("Changed: ${event.value}");
              },
            ),
    );
  }
}
