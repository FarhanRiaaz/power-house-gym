import 'dart:convert';

import 'package:finger_print_flutter/core/enum.dart';

/// Represents the simplified admin user model for login purposes.
class AdminUser {
  final String id; // Firebase Auth UID or local ID
  final String username;
  final UserRole role;

  AdminUser({
    required this.id,
    required this.username,
    required this.role,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'role': role.name,
      };

  /// Create from JSON
  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'],
      username: json['username'],
      role: UserRole.values.firstWhere(
        (r) => r.name.toLowerCase() == json['role'].toLowerCase(),
        orElse: () => UserRole.maleAdmin,
      ),
    );
  }

  /// Create from JSON list
  static List<AdminUser> fromJsonList(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);
    return data.map((e) => AdminUser.fromJson(e)).toList();
  }

  /// Convert list to JSON string
  static String toJsonList(List<AdminUser> list) {
    final data = list.map((e) => e.toJson()).toList();
    return json.encode(data);
  }

  /// Create a copy with optional overrides
  AdminUser copyWith({
    String? id,
    String? username,
    UserRole? role,
  }) {
    return AdminUser(
      id: id ?? this.id,
      username: username ?? this.username,
      role: role ?? this.role,
    );
  }

  /// Equality override
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          role == other.role;

  @override
  int get hashCode => id.hashCode ^ username.hashCode ^ role.hashCode;

  /// String representation
  @override
  String toString() {
    return 'AdminUser(id: $id, username: $username, role: ${role.name})';
  }

  /// Role checks
  bool get isSuperAdmin => role == UserRole.superAdmin;
  bool get isFemaleAdmin => role == UserRole.femaleAdmin;
  bool get isMaleAdmin => role == UserRole.maleAdmin;

  /// Filter by role
  static List<AdminUser> filterByRole(List<AdminUser> list, UserRole role) {
    return list.where((u) => u.role == role).toList();
  }

  /// Find by ID
  static AdminUser? findById(List<AdminUser> list, String id) {
    return list.firstWhere((u) => u.id == id, orElse: () =>AdminUser(id: "0", username: "username", role: UserRole.maleAdmin),);
  }

  /// Find by username
  static AdminUser? findByUsername(List<AdminUser> list, String username) {
    return list.firstWhere(
      (u) => u.username.toLowerCase() == username.toLowerCase(),
      orElse: () => AdminUser(id: "0", username: "username", role: UserRole.maleAdmin),
    );
  }
}
