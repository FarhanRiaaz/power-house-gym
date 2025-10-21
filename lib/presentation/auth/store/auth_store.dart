import 'package:finger_print_flutter/core/enum.dart';
import 'package:finger_print_flutter/domain/entities/models/admin_user.dart';
import 'package:finger_print_flutter/domain/usecases/auth/auth_usecase.dart';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  // --- Dependencies (Use Cases) ---
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;

  _AuthStore(this._loginUseCase, this._logoutUseCase, this._changePasswordUseCase);

  // --- Store State Variables ---

  @observable
  AdminUser? currentUser;

  @observable
  bool isLoading = false;

  @observable
  String loginError = '';

  // --- Computed Values ---

  @computed
  bool get isAuthenticated => currentUser != null;

  // Assuming UserRole enum is accessible here
  @computed
  bool get isSuperAdmin => currentUser?.role == UserRole.superAdmin;

  // --- Actions ---

  /// Attempts to log in and sets the current user on success.
  @action
  Future<bool> login(String username, String password) async {
    isLoading = true;
    loginError = '';
    try {
      final user = await _loginUseCase.call(
          params: LoginParams(username: username, password: password));

      runInAction(() {
        currentUser = user;
        if (user == null) {
          loginError = 'Invalid username or password.';
        }
      });
      return user != null;
    } catch (e) {
      runInAction(() {
        loginError = 'An unexpected error occurred during login.';
      });
      return false;
    } finally {
      isLoading = false;
    }
  }

  /// Logs out the user.
  @action
  Future<void> logout() async {
    await _logoutUseCase.call(params: null);
    currentUser = null;
  }

  /// Changes a target admin's password (Super Admin only).
  @action
  Future<bool> changePassword(String targetUsername, String newPassword) async {
    // Role check is performed in the Use Case/Service, but we use isLoading here
    if (!isAuthenticated || !isSuperAdmin) return false;

    isLoading = true;
    try {
      final success = await _changePasswordUseCase.call(
          params: ChangePasswordParams(
              targetUsername: targetUsername, newPassword: newPassword));
      return success;
    } catch (e) {
      print("Error changing password: $e");
      return false;
    } finally {
      isLoading = false;
    }
  }
}
