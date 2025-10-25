import 'dart:convert';
import 'dart:typed_data';

import 'package:finger_print_flutter/core/enum.dart';
import 'package:finger_print_flutter/domain/entities/models/csv.dart';

/// Data class representing a fitness club member.
class Member implements CsvConvertible {
   int? memberId; // Unique ID, possibly generated on registration
   String? name;
   String? phoneNumber;
   String? fatherName;
   Gender? gender;
   MemberShipType? membershipType; // e.g., "Fitness Club", "Weightlifting"
   DateTime? registrationDate;
   DateTime? lastFeePaymentDate;
   String? fingerprintTemplate; // Biometric data
   String? notes;

  Member({
     this.memberId,
     this.name,
     this.phoneNumber,
     this.fatherName,
     this.gender,
     this.membershipType,
     this.registrationDate,
     this.lastFeePaymentDate,
    this.fingerprintTemplate,
    this.notes,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'name': name,
        'phoneNumber': phoneNumber,
        'fatherName': fatherName,
        'gender': gender?.name,
        'membershipType': membershipType?.name,
        'registrationDate': registrationDate?.toIso8601String(),
        'lastFeePaymentDate': lastFeePaymentDate?.toIso8601String(),
        'fingerprintTemplate': fingerprintTemplate != null
            ? (fingerprintTemplate!)
            : null,
        'notes': notes,
      };

  /// Create from JSON
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberId: json['memberId'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      fatherName: json['fatherName'],
      gender:
      Gender.values.firstWhere((g) => g.name.toLowerCase() == json['gender'].toLowerCase()),
      membershipType: MemberShipType.values.firstWhere((g) => g.name.toLowerCase() == json['membershipType'].toLowerCase()),
      registrationDate: DateTime.parse(json['registrationDate']),
      lastFeePaymentDate: DateTime.parse(json['lastFeePaymentDate']),
      fingerprintTemplate: json['fingerprintTemplate'] != null
          ? (json['fingerprintTemplate'])
          : null,
      notes: json['notes'],
    );
  }

  /// Create a copy with optional overrides
  Member copyWith({
    int? memberId,
    String? name,
    String? phoneNumber,
    String? fatherName,
    Gender? gender,
    MemberShipType? membershipType,
    DateTime? registrationDate,
    DateTime? lastFeePaymentDate,
    String? fingerprintTemplate,
    String? notes,
  }) {
    return Member(
      memberId: memberId ?? this.memberId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fatherName: fatherName ?? this.fatherName,
      gender: gender ?? this.gender,
      membershipType: membershipType ?? this.membershipType,
      registrationDate: registrationDate ?? this.registrationDate,
      lastFeePaymentDate: lastFeePaymentDate ?? this.lastFeePaymentDate,
      fingerprintTemplate: fingerprintTemplate ?? this.fingerprintTemplate,
      notes: notes ?? this.notes,
    );
  }

  /// Equality override
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Member &&
          runtimeType == other.runtimeType &&
          memberId == other.memberId &&
          name == other.name &&
          phoneNumber == other.phoneNumber &&
          fatherName == other.fatherName &&
          gender == other.gender &&
          membershipType == other.membershipType &&
          registrationDate == other.registrationDate &&
          lastFeePaymentDate == other.lastFeePaymentDate &&
          notes == other.notes &&
          _fingerprintEqual(fingerprintTemplate, other.fingerprintTemplate);

  @override
  int get hashCode =>
      memberId.hashCode ^
      name.hashCode ^
      phoneNumber.hashCode ^
      fatherName.hashCode ^
      gender.hashCode ^
      membershipType.hashCode ^
      registrationDate.hashCode ^
      lastFeePaymentDate.hashCode ^
      notes.hashCode ^
      fingerprintTemplate.hashCode;

  bool _fingerprintEqual(String? a, String? b) {
    if (a == null || b == null) return a == b;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// String representation
  @override
  String toString() {
       return 'Member('
        '\n  memberId: $memberId, '
        '\n  name: $name, '
        '\n  phoneNumber: $phoneNumber, '
        '\n  fatherName: $fatherName, '
        '\n  gender: ${gender?.name}, ' // Accessing the name property of the enum
        '\n  membershipType: ${membershipType?.name}'
        '\n  registrationDate: ${registrationDate?.toIso8601String()}, '
        '\n  lastFeePaymentDate: ${lastFeePaymentDate?.toIso8601String()}, '
        '\n  fingerprintTemplate: ${fingerprintTemplate != null ? "[Template Present (${fingerprintTemplate!.length} chars)]" : null}, '
        '\n  notes: $notes'
        '\n)';
  }
  ///  for excel export things
  @override
  List<String> toCsvHeader() {
    // Defines the friendly column names in the exact order the fields appear
    return [
      'Member ID',
      'Name',
      'Phone Number',
      "Father's Name",
      'Gender',
      'Membership Type',
      'Registration Date',
      'Last Fee Payment',
      'Fingerprint Template',
      'Notes',
    ];
  }

  @override
  List<String> toCsvRow() {
    // Converts all fields to strings in the exact same order as the header.
    // Use the null-safe operators (?. and ?? '') to handle optional fields gracefully.
    return [
      memberId.toString(),
      name??"",
      phoneNumber??"",
      fatherName??"",
      gender?.name ?? '', // Use enum name, default to empty string if null
      membershipType?.name??"",
      registrationDate?.toIso8601String() ?? '',
      lastFeePaymentDate?.toIso8601String() ?? '',
      fingerprintTemplate ?? '',
      notes ?? '',
    ];
  }
  /// for excel import thing

  // --- CSV IMPORT (FACTORY CONSTRUCTOR) ---

  /// Creates a Member object from an ordered List of String values (a CSV row).
  /// This is the function that makes import possible!
  factory Member.fromCsvRow(List<String> row) {
    if (row.length < 10) {
      throw const FormatException("CSV row must contain at least 10 fields.");
    }

    // Helper function to safely parse a DateTime from an ISO 8601 string.
    DateTime? parseDateTime(String? value) {
      if (value == null || value.isEmpty) return null;
      try {
        return DateTime.tryParse(value);
      } catch (_) {
        return null;
      }
    }

    Gender? parseGender(String? value) {
      if (value == null || value.isEmpty) return null;
      final String normalizedValue = value.toLowerCase();
      return Gender.values.firstWhere(
              (g) => g.name == normalizedValue,
          orElse: () => throw FormatException("Invalid gender value: $value")
      );
    }
    MemberShipType? parseMembership(String? value) {
      if (value == null || value.isEmpty) return null;
      final String normalizedValue = value.toLowerCase();
      return MemberShipType.values.firstWhere(
              (g) => g.name == normalizedValue,
          orElse: () => throw FormatException("Invalid MemberShipType value: $value")
      );
    }

    // Convert ID, expecting it to be the first element (Index 0)
    final parsedId = int.tryParse(row[0]);

    // NOTE: We only allow the import of new data, so we ignore the parsedId here
    // and let the database assign a new one, unless you explicitly manage IDs.

    return Member(
      memberId: parsedId, // Keep it if it was provided, but often ignored for new inserts
      name: row[1],
      phoneNumber: row[2],
      fatherName: row[3],
      gender: parseGender(row[4]),
      membershipType: parseMembership(row[5]),
      registrationDate: parseDateTime(row[6]),
      lastFeePaymentDate: parseDateTime(row[7]),
      fingerprintTemplate: row[8].isEmpty ? null : row[8],
      notes: row[9].isEmpty ? null : row[9],
    );
  }

  /// Check if fee is overdue (e.g., monthly)
  bool get isFeeOverdue {
    final now = DateTime.now();
    final dueDate = lastFeePaymentDate!.add(Duration(days: 30));
    return now.isAfter(dueDate);
  }

  /// Filter by membership type
  static List<Member> filterByType(List<Member> list, String type) {
    return list
        .where((m) => m.membershipType?.name.toLowerCase() == type.toLowerCase())
        .toList();
  }

  /// Sort by registration date
  static List<Member> sortByRegistrationDate(List<Member> list) {
    list.sort((a, b) => b.registrationDate!.compareTo(a.registrationDate!));
    return list;
  }

  /// Find by ID
  static Member? findById(List<Member> list, String id) {
    return list.firstWhere((m) => m.memberId == id, orElse: () => Member());
  }
}
class Table {
  final String tableName;
  Table(this.tableName);
}
