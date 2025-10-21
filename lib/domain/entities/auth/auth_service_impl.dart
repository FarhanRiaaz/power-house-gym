import 'package:finger_print_flutter/core/enum.dart' show UserRole;
import 'package:finger_print_flutter/domain/entities/auth/auth_service.dart';
import 'package:finger_print_flutter/domain/entities/models/admin_user.dart';

/// A simple authentication service using hardcoded credentials.
///
/// In a real-world Flutter Desktop application, credentials might be stored
/// in an encrypted local file or managed via a secure system utility.
class AuthServiceImpl implements AuthService {
  // --- 1. HARDCODED ADMIN CREDENTIALS ---

  // Note: Passwords should be hashed/salted in a production environment.
  // We use clear text here for simplification.
  static final List<Map<String, dynamic>> _hardcodedAdmins = [
    {
      'username': 'superadmin',
      'password': 'admin123',
      'role': UserRole.superAdmin,
    },
    {
      'username': 'maleadmin',
      'password': 'male123',
      'role': UserRole.maleAdmin,
    },
    {
      'username': 'femaleadmin',
      'password': 'female123',
      'role': UserRole.femaleAdmin,
    },
  ];

  // In a hardcoded system, we need a way to track the current user.
  AdminUser? _currentUser;

  /// Returns the currently logged-in user.
  AdminUser? get currentUser => _currentUser;

  // --- 2. AUTHENTICATION LOGIC ---

  /// Attempts to log in the user with provided credentials.
  ///
  /// Returns the authenticated AdminUser or null if credentials fail.
  @override
  Future<AdminUser?> login(String username, String password) async {
    final userMap = _hardcodedAdmins.firstWhere(
      (admin) => admin['username'] == username && admin['password'] == password,
      orElse: () => {},
    );

    if (userMap.isNotEmpty) {
      // For hardcoded users, we can use the username as a simple ID.
      _currentUser = AdminUser(
        id: userMap['username'] as String,
        username: userMap['username'] as String,
        role: userMap['role'] as UserRole,
      );
      return _currentUser;
    }
    return null;
  }

  /// Logs out the current user.
  @override
  void logout() {
    _currentUser = null;
  }

  // --- 3. PASSWORD CHANGE LOGIC (SUPER ADMIN FEATURE) ---

  /// Allows Super Admin to change the password for other admin accounts.
  ///
  /// Note: In this hardcoded model, this change is only temporary in memory
  /// until the app restarts or a persistent storage solution is implemented.
  @override
  bool changePassword(String targetUsername, String newPassword) {
    if (_currentUser?.role != UserRole.superAdmin) {
      // Only Super Admin can perform this action
      return false;
    }

    final index = _hardcodedAdmins.indexWhere(
      (admin) => admin['username'] == targetUsername,
    );

    if (index != -1) {
      _hardcodedAdmins[index]['password'] = newPassword;
      print(
        'Password for $targetUsername successfully changed (in-memory only).',
      );
      return true;
    }
    return false;
  }
}
