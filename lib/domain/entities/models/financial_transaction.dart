import 'dart:convert';

/// Data class representing a financial transaction (e.g., fee payment, expense).
class FinancialTransaction {
  final int? id;
  final String? type; // e.g., "Fee Payment", "Expense", "Bill"
  final double? amount;
  final DateTime? transactionDate;
  final String? description;
  final int? relatedMemberId; // Null for general expenses/bills

  FinancialTransaction({
     this.id,
     this.type,
     this.amount,
     this.transactionDate,
     this.description,
    this.relatedMemberId,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'amount': amount,
        'transactionDate': transactionDate?.toIso8601String(),
        'description': description,
        'relatedMemberId': relatedMemberId,
      };

  /// Create from JSON
  factory FinancialTransaction.fromJson(Map<String, dynamic> json) {
    return FinancialTransaction(
      id: json['id'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      transactionDate: DateTime.parse(json['transactionDate']),
      description: json['description'],
      relatedMemberId: json['relatedMemberId'],
    );
  }

  /// Create a copy with optional overrides
  FinancialTransaction copyWith({
    int? id,
    String? type,
    double? amount,
    DateTime? transactionDate,
    String? description,
    int? relatedMemberId,
  }) {
    return FinancialTransaction(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      transactionDate: transactionDate ?? this.transactionDate,
      description: description ?? this.description,
      relatedMemberId: relatedMemberId ?? this.relatedMemberId,
    );
  }

  /// Equality override
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinancialTransaction &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          amount == other.amount &&
          transactionDate == other.transactionDate &&
          description == other.description &&
          relatedMemberId == other.relatedMemberId;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      amount.hashCode ^
      transactionDate.hashCode ^
      description.hashCode ^
      relatedMemberId.hashCode;

  /// String representation
  @override
  String toString() {
    return 'Transaction(id: $id, type: $type, amount: $amount, date: $transactionDate, member: $relatedMemberId)';
  }

  /// Filter by member
  static List<FinancialTransaction> forMember(
      List<FinancialTransaction> list, String memberId) {
    return list.where((tx) => tx.relatedMemberId == memberId).toList();
  }

  /// Sort by date (latest first)
  static List<FinancialTransaction> sortByDate(List<FinancialTransaction> list) {
    list.sort((a, b) => b.transactionDate!.compareTo(a.transactionDate!));
    return list;
  }

  /// Total amount by type
  static double totalByType(List<FinancialTransaction> list, String type) {
    return list
        .where((tx) => tx.type == type)
        .fold(0.0, (sum, tx) => sum + tx.amount!);
  }
}
