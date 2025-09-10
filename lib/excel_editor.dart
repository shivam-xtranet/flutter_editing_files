import 'dart:convert';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pluto_grid/pluto_grid.dart';
import 'dart:html' as html; // for web download

class ExcelEditor extends StatefulWidget {
  bool? isEditing;
  ExcelEditor({Key? key, this.isEditing = false}) : super(key: key);

  @override
  State<ExcelEditor> createState() => _ExcelEditorState();
}

class _ExcelEditorState extends State<ExcelEditor> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;

  @override
  void initState() {
    super.initState();
    // loadExcelFromBase64(
    //   "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",
    // );

    loadExcelFromUint8List(
      base64Decode(
        "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",
      ),
    );
  }

  Future<void> loadExcelFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var bytes = response.bodyBytes;
        final excel = Excel.decodeBytes(bytes);

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
                  'col$c': PlutoCell(
                    value: sheetData[r][c]?.value?.toString() ?? '',
                  ),
              },
            ),
          );
        }

        setState(() {
          columns = cols;
          rows = plutoRows;
        });
      }
    } catch (e) {
      print("Error loading Excel: $e");
    }
  }

  Future<void> loadExcelFromUint8List(Uint8List bytes) async {
    try {
      final excel = Excel.decodeBytes(bytes);

      if (excel.tables.isEmpty) {
        print("No tables found in Excel file");
        return;
      }

      var sheet = excel.tables[excel.tables.keys.first]!;
      List<List<Data?>> sheetData = sheet.rows;

      if (sheetData.isEmpty) {
        print("Excel sheet is empty");
        return;
      }

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
        // Skip empty rows
        if (sheetData[r].isEmpty ||
            sheetData[r].every((cell) => cell?.value == null)) {
          continue;
        }

        plutoRows.add(
          PlutoRow(
            cells: {
              for (int c = 0; c < sheetData[r].length; c++)
                'col$c': PlutoCell(
                  value: sheetData[r][c]?.value?.toString() ?? '',
                ),
            },
          ),
        );
      }

      setState(() {
        columns = cols;
        rows = plutoRows;
      });
    } catch (e) {
      print("Error loading Excel from Uint8List: $e");
    }
  }

  Future<void> loadExcelFromBase64(String base64String) async {
    try {
      // Decode base64 string to bytes
      final bytes = base64Decode(base64String);

      // Decode Excel bytes
      final excel = Excel.decodeBytes(bytes);

      // Get the first sheet
      final sheet = excel.tables[excel.tables.keys.first]!;
      final List<List<Data?>> sheetData = sheet.rows;

      // Create columns from the first row
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

      // Create rows from the remaining data
      List<PlutoRow> plutoRows = [];
      for (int r = 1; r < sheetData.length; r++) {
        plutoRows.add(
          PlutoRow(
            cells: {
              for (int c = 0; c < sheetData[r].length; c++)
                'col$c': PlutoCell(
                  value: sheetData[r][c]?.value?.toString() ?? '',
                ),
            },
          ),
        );
      }

      // Update state with new data
      setState(() {
        columns = cols;
        rows = plutoRows;
      });
    } catch (e) {
      print("Error loading Excel from base64: $e");
    }
  }

  void saveExcelWeb(
    List<PlutoRow> rows,
    List<PlutoColumn> columns,
    String sheetName,
  ) {
    final excel = Excel.createExcel();
    final sheet = excel[sheetName];

    // Headers
    List<String> headers = columns.map((c) => c.title).toList();
    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());

    // Rows
    for (PlutoRow row in rows) {
      final rowValues =
          row.cells.values.map((cell) => cell.value.toString()).toList();
      sheet.appendRow(rowValues.map((v) => TextCellValue(v)).toList());
    }

    final bytes = excel.encode()!;
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor =
        html.AnchorElement(href: url)
          ..setAttribute("download", "edited.xlsx")
          ..click();
    html.Url.revokeObjectUrl(url);
  }

  // 👉 Add new empty row
  void addRow() {
    if (stateManager == null || columns.isEmpty) return;

    // Create row cells
    final Map<String, PlutoCell> cells = {
      for (final col in stateManager!.columns) col.field: PlutoCell(value: ""),
    };

    final newRow = PlutoRow(cells: cells);

    // Add via stateManager
    stateManager!.appendRows([newRow]);
  }

  void addColumn() {
    if (stateManager == null) return;

    final colIndex = stateManager!.columns.length;
    final newColumn = PlutoColumn(
      title: 'Column $colIndex',
      field: 'col$colIndex',
      type: PlutoColumnType.text(),
    );

    // Insert column via stateManager
    stateManager!.insertColumns(colIndex, [newColumn]);

    // Set initial value for each row using stateManager.changeCellValue
    for (var row in stateManager!.rows) {
      stateManager!.changeCellValue(
        row.cells[newColumn.field]!, // the new cell
        '', // initial value
        callOnChangedEvent: false, // optional
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Excel Editor (Web)"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => saveExcelWeb(rows, columns, "Sheet1"),
          ),
        ],
      ),
      body:
          columns.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : PlutoGrid(
                columns: columns,
                rows: rows,
                mode:
                    widget.isEditing!
                        ? PlutoGridMode.normal
                        : PlutoGridMode.readOnly, // Disables all editing
                onLoaded: (event) {
                  stateManager = event.stateManager;
                },
                onChanged: (PlutoGridOnChangedEvent event) {
                  print("Changed: ${event.value}");
                },
              ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: "addRow",
            onPressed: addRow,
            label: const Text("Add Row"),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "addCol",
            onPressed: addColumn,
            label: const Text("Add Column"),
            icon: const Icon(Icons.view_column),
          ),
        ],
      ),
    );
  }
}
