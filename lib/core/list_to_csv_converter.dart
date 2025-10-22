import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
  import 'package:file_picker/file_picker.dart';

/// A simplified class to demonstrate the core logic of converting a
/// List of Lists (table data) into a single CSV formatted string.
///
/// The critical logic involves checking each field for the delimiter (e.g., comma)
/// or quote character (") and escaping them correctly.
class SimpleCsvConverter {
  final String fieldDelimiter;
  final String textDelimiter; // Usually a double quote (")

  /// Initializes the converter with custom delimiters.
  /// The defaults mimic standard CSV format.
  const SimpleCsvConverter({
    this.fieldDelimiter = ',',
    this.textDelimiter = '"',
  });

  /// Converts a List<List<dynamic>> (representing rows and columns)
  /// into a single CSV string.
  String convert(List<List<dynamic>> data) {
    if (data.isEmpty) {
      return '';
    }

    final StringBuffer buffer = StringBuffer();

    // Iterate through each row in the input data
    for (int i = 0; i < data.length; i++) {
      final List<dynamic> row = data[i];
      final List<String> csvRow = [];

      // Iterate through each field (column) in the current row
      for (final field in row) {
        // 1. Convert the field to a string
        final String fieldString = field.toString();

        // 2. Determine if the field needs quoting
        bool needsQuotes = fieldString.contains(fieldDelimiter) ||
            fieldString.contains(textDelimiter) ||
            fieldString.contains('\n') || // Newlines must always be quoted
            fieldString.isEmpty;

        String processedField = fieldString;

        // 3. If quoting is needed, apply escaping logic
        if (needsQuotes) {
          // Escape any existing quote characters by doubling them up (" -> "")
          processedField = fieldString.replaceAll(
              textDelimiter, '$textDelimiter$textDelimiter');

          // Wrap the entire field in the text delimiters
          processedField = '$textDelimiter$processedField$textDelimiter';
        }

        csvRow.add(processedField);
      }

      // Join the fields with the delimiter for the current row
      buffer.write(csvRow.join(fieldDelimiter));

      // Add a newline character, unless this is the last row
      if (i < data.length - 1) {
        buffer.writeln(); // Adds the system-specific newline character
      }
    }

    return buffer.toString();
  }

  Future<List<List<String>>> readCsvFile(String filePath) async {
  final raw = await File(filePath).readAsString(); // UTF-8 by default
  final rows = const CsvToListConverter(eol: '\n').convert(raw);

  return rows.map((r) => r.map((e) => e.toString()).toList()).toList();
}

Future<String> pickExcelFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv', 'csv'],
  );

  if (result != null && result.files.single.path != null) {
    final filePath = result.files.single.path!;
    return filePath; // Pass the path to your handlerfNo valid members found to insert.
  } else {
return '';  }
}

}