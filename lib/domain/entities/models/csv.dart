abstract class CsvConvertible {
  /// Returns the ordered list of field names for the CSV header.
  List<String> toCsvHeader();

  /// Returns the ordered list of field values as Strings for a data row.
  List<String> toCsvRow();
}