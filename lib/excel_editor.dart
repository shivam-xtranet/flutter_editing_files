import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pluto_grid/pluto_grid.dart';
import 'dart:html' as html; // for web download

class ExcelEditor extends StatefulWidget {
  const ExcelEditor({Key? key}) : super(key: key);

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
    loadExcelFromUrl(
        "https://res.cloudinary.com/dlmt4hsgw/raw/upload/v1756282773/testappis_ixxfc9.xlsx");
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
                      value: sheetData[r][c]?.value?.toString() ?? ''),
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

  void saveExcelWeb(
      List<PlutoRow> rows, List<PlutoColumn> columns, String sheetName) {
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
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "edited.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  // 👉 Add new empty row
  void addRow() {
  if (stateManager == null || columns.isEmpty) return;

  // Create row cells
  final Map<String, PlutoCell> cells = {
    for (final col in stateManager!.columns) col.field: PlutoCell(value: "")
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
      body: columns.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PlutoGrid(
              columns: columns,
              rows: rows,
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
