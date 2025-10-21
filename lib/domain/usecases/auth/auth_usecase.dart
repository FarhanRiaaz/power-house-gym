import 'package:finger_print_flutter/core/base_usecase.dart';
import 'package:finger_print_flutter/domain/entities/auth/auth_service.dart';
import 'package:finger_print_flutter/domain/entities/models/admin_user.dart';

class LoginParams {
  final String username;
  final String password;

  LoginParams({required this.username, required this.password});
}

/// Attempts to log in a user and returns the AdminUser entity or null.
class LoginUseCase extends UseCase<AdminUser?, LoginParams> {
  final AuthService _authService;

  LoginUseCase(this._authService);

  @override
  Future<AdminUser?> call({required LoginParams params}) {
    return _authService.login(params.username, params.password);
  }
}

/// Handles logging out the current user by delegating the action to the AuthService.
///
/// Type: void
/// Params: void
class LogoutUseCase extends UseCase<void, void> {
  final AuthService _authService;

  LogoutUseCase(this._authService);

  @override
  Future<void> call({void params}) async {
    // This call resets the in-memory current user status in AuthServiceImpl.
    _authService.logout();
  }
}

/// Parameters for changing a user's password.
/// This bundles the required data into a single, clean object for the Use Case.
class ChangePasswordParams {
  final String targetUsername;
  final String newPassword;

  ChangePasswordParams({required this.targetUsername, required this.newPassword});
}

/// Allows the Super Admin to change another user's password.
/// The service layer contains the logic to ensure only a Super Admin can perform
/// this action and handles updating the hardcoded credentials list.
///
/// Type: bool (Success/Failure)
/// Params: ChangePasswordParams
class ChangePasswordUseCase extends UseCase<bool, ChangePasswordParams> {
  final AuthService _authService;

  ChangePasswordUseCase(this._authService);

  @override
  Future<bool> call({required ChangePasswordParams params}) async {
    // Delegate the business logic to the core AuthService implementation.
    return _authService.changePassword(
        params.targetUsername, params.newPassword);
  }
}

/// Use case to enroll a new fingerprint template.
///
/// Type: String? (The generated template string)
/// Params: int (The Member ID to associate the template with)
class EnrollFingerprintUseCase extends UseCase<String?, int> {
  final BiometricService _biometricService;

  EnrollFingerprintUseCase(this._biometricService);

  @override
  Future<String?> call({required int params}) {
    // Logic: Enroll fingerprint and return the template string
    return _biometricService.enroll(params);
  }
}
