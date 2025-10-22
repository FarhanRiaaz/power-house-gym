import 'dart:convert';

import 'package:finger_print_flutter/domain/entities/models/csv.dart';

/// Data class representing an attendance record.
class AttendanceRecord  implements CsvConvertible{
  final int? id;
  final int? memberId;
  final DateTime? checkInTime;

  AttendanceRecord({
     this.id,
     this.memberId,
     this.checkInTime,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'memberId': memberId,
        'checkInTime': checkInTime?.toIso8601String(),
      };

  /// Create from JSON
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'],
      memberId: json['memberId'],
      checkInTime: DateTime.parse(json['checkInTime']),
    );
  }

  /// Create from JSON list
  static List<AttendanceRecord> fromJsonList(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);
    return data.map((e) => AttendanceRecord.fromJson(e)).toList();
  }

  /// Convert list to JSON string
  static String toJsonList(List<AttendanceRecord> list) {
    final data = list.map((e) => e.toJson()).toList();
    return json.encode(data);
  }

  /// Create a copy with optional overrides
  AttendanceRecord copyWith({
    int? id,
    int? memberId,
    DateTime? checkInTime,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      checkInTime: checkInTime ?? this.checkInTime,
    );
  }

  /// Equality override
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceRecord &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          memberId == other.memberId &&
          checkInTime == other.checkInTime;

  @override
  int get hashCode =>
      id.hashCode ^ memberId.hashCode ^ checkInTime.hashCode;

  /// String representation
  @override
  String toString() {
    return 'AttendanceRecord(id: $id, memberId: $memberId, checkIn: $checkInTime)';
  }

  ///Import Export to CSV

  @override
  List<String> toCsvHeader() {
    // Defines the friendly column names in the exact order the fields appear
    return [
      'id',
      'memberId',
      'checkInTime',
    ];
  }
  @override
  List<String> toCsvRow() {
    // We use the ISO 8601 format for a precise and unambiguous timestamp.
    return [
      id.toString(),
      memberId.toString(),
      checkInTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
    ];
  }
  /// Assumes the input List<String> contains elements in the order:
  /// [id, memberId, checkInTime (ISO 8601 string)]
  factory AttendanceRecord.fromCsvRow(List<String> row) {
  if (row.length != 3) {
    throw FormatException('CSV row must contain exactly 3 fields. Received: ${row.length} → $row');
  }

  final id = int.tryParse(row[0]);
  final memberId = int.tryParse(row[1]);
  final checkInTime = DateTime.tryParse(row[2]);

  if (id == null || memberId == null || checkInTime == null) {
    throw FormatException('Invalid data format in row: $row');
  }

  return AttendanceRecord(
    id: id,
    memberId: memberId,
    checkInTime: checkInTime,
  );
}


  /// Filter by member
  static List<AttendanceRecord> forMember(
      List<AttendanceRecord> list, int memberId) {
    return list.where((r) => r.memberId == memberId).toList();
  }

  /// Sort by check-in time (latest first)
  static List<AttendanceRecord> sortByDate(List<AttendanceRecord> list) {
    list.sort((a, b) => b.checkInTime!.compareTo(a.checkInTime!));
    return list;
  }

  /// Count total check-ins for a member
  static int countForMember(List<AttendanceRecord> list, String memberId) {
    return list.where((r) => r.memberId == memberId).length;
  }

  /// Group by member
  static Map<int, List<AttendanceRecord>> groupByMember(
      List<AttendanceRecord> list) {
    final Map<int, List<AttendanceRecord>> grouped = {};
    for (var r in list) {
      grouped.putIfAbsent(r.memberId!, () => []).add(r);
    }
    return grouped;
  }
}
