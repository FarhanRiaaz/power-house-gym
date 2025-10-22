import 'dart:convert';

import 'package:finger_print_flutter/domain/entities/models/csv.dart';

/// Data class for tracking general expenses/bills.
class BillExpense implements CsvConvertible {
   int? id;
   String? category; // e.g., "Rent", "Utility", "Salary"
   double? amount;
   DateTime? date;
   String? description;

  BillExpense({
     this.id,
     this.category,
     this.amount,
     this.date,
     this.description,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'amount': amount,
        'date': date?.toIso8601String(),
        'description': description,
      };

  /// Create from JSON
  factory BillExpense.fromJson(Map<String, dynamic> json) {
    return BillExpense(
      id: json['id'],
      category: json['category'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }

  /// Create from JSON list
  static List<BillExpense> fromJsonList(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);
    return data.map((e) => BillExpense.fromJson(e)).toList();
  }

  /// Convert list to JSON string
  static String toJsonList(List<BillExpense> list) {
    final data = list.map((e) => e.toJson()).toList();
    return json.encode(data);
  }

  /// Create a copy with optional overrides
  BillExpense copyWith({
    int? id,
    String? category,
    double? amount,
    DateTime? date,
    String? description,
  }) {
    return BillExpense(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  /// Equality override
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillExpense &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          category == other.category &&
          amount == other.amount &&
          date == other.date &&
          description == other.description;

  @override
  int get hashCode =>
      id.hashCode ^
      category.hashCode ^
      amount.hashCode ^
      date.hashCode ^
      description.hashCode;

  /// String representation
  @override
  String toString() {
    return 'BillExpense(id: $id, category: $category, amount: $amount, date: $date)';
  }

  /// Filter by category
  static List<BillExpense> filterByCategory(List<BillExpense> list, String category) {
    return list.where((e) => e.category?.toLowerCase() == category.toLowerCase()).toList();
  }

  /// Sort by date (latest first)
  static List<BillExpense> sortByDate(List<BillExpense> list) {
    list.sort((a, b) => b.date!.compareTo(a.date!));
    return list;
  }

  /// Total amount by category
  static double totalByCategory(List<BillExpense> list, String category) {
    return list
        .where((e) => e.category?.toLowerCase() == category.toLowerCase())
        .fold(0.0, (sum, e) => sum + e.amount!);
  }

  /// Total amount overall
  static double totalAmount(List<BillExpense> list) {
    return list.fold(0.0, (sum, e) => sum + e.amount!);
  }

  /// Group by category
  static Map<String, List<BillExpense>> groupByCategory(List<BillExpense> list) {
    final Map<String, List<BillExpense>> grouped = {};
    for (var e in list) {
      grouped.putIfAbsent(e.category!, () => []).add(e);
    }
    return grouped;
  }


  ///Import Export to CSV

  @override
  List<String> toCsvHeader() {
    // Defines the friendly column names in the exact order the fields appear
    return [
      'ID',
      'Category',
      'Amount',
      'Date',
    ];
  }
  @override
  List<String> toCsvRow() {
    // We use the ISO 8601 format for a precise and unambiguous timestamp.
    return [
      id.toString(),
      category??"",
      amount.toString(),
      date?.toIso8601String() ?? DateTime.now().toIso8601String(),
      description??""
    ];
  }
  /// Assumes the input List<String> contains elements in the order:
  /// [id, memberId, checkInTime (ISO 8601 string)]
  factory BillExpense.fromCsvRow(List<String> row) {
    if (row.length != 5) {
      throw FormatException('CSV row must contain exactly 5 fields.');
    }

    // We assume the ID and Member ID are simple strings and the time is ISO 8601.
    return BillExpense(
      id: int.tryParse(row[0])??0,
      category: row[1]??"",
      amount: double.tryParse(row[2]),
      date: DateTime.parse(row[3]),
      description: row[4] ??"",
    );
  }
}
