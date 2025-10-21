import 'package:finger_print_flutter/core/enum.dart' show UserRole;
import 'package:finger_print_flutter/domain/entities/models/admin_user.dart';

/// A simple authentication service using hardcoded credentials.
///
/// In a real-world Flutter Desktop application, credentials might be stored
/// in an encrypted local file or managed via a secure system utility.
abstract class AuthService {
  /// Attempts to log in the user with provided credentials.
  ///
  /// Returns the authenticated AdminUser or null if credentials fail.
  Future<AdminUser?> login(String username, String password);

  /// Logs out the current user.
  void logout();

  // --- 3. PASSWORD CHANGE LOGIC (SUPER ADMIN FEATURE) ---
  /// Allows Super Admin to change the password for other admin accounts.
  ///
  /// Note: In this hardcoded model, this change is only temporary in memory
  /// until the app restarts or a persistent storage solution is implemented.
  bool changePassword(String targetUsername, String newPassword);
}
