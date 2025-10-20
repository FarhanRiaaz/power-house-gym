import 'dart:convert';
import 'dart:typed_data';

import 'package:finger_print_flutter/core/enum.dart';

/// Data class representing a fitness club member.
class Member {
  final String? memberId; // Unique ID, possibly generated on registration
  final String? name;
  final String? phoneNumber;
  final String? fatherName;
  final Gender? gender;
  final String? membershipType; // e.g., "Fitness Club", "Weightlifting"
  final DateTime? registrationDate;
  final DateTime? lastFeePaymentDate;
  final Uint8List? fingerprintTemplate; // Biometric data
  final String? notes;

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
        'membershipType': membershipType,
        'registrationDate': registrationDate?.toIso8601String(),
        'lastFeePaymentDate': lastFeePaymentDate?.toIso8601String(),
        'fingerprintTemplate': fingerprintTemplate != null
            ? base64Encode(fingerprintTemplate!)
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
      gender: Gender.values.firstWhere(
          (g) => g.name.toLowerCase() == json['gender'].toLowerCase()),
      membershipType: json['membershipType'],
      registrationDate: DateTime.parse(json['registrationDate']),
      lastFeePaymentDate: DateTime.parse(json['lastFeePaymentDate']),
      fingerprintTemplate: json['fingerprintTemplate'] != null
          ? base64Decode(json['fingerprintTemplate'])
          : null,
      notes: json['notes'],
    );
  }

  /// Create a copy with optional overrides
  Member copyWith({
    String? memberId,
    String? name,
    String? phoneNumber,
    String? fatherName,
    Gender? gender,
    String? membershipType,
    DateTime? registrationDate,
    DateTime? lastFeePaymentDate,
    Uint8List? fingerprintTemplate,
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

  bool _fingerprintEqual(Uint8List? a, Uint8List? b) {
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
    return 'Member($memberId, $name, $membershipType, feePaid: $lastFeePaymentDate)';
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
        .where((m) => m.membershipType?.toLowerCase() == type.toLowerCase())
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
