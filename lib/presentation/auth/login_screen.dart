import 'package:finger_print_flutter/presentation/auth/route_manager.dart';
import 'package:finger_print_flutter/presentation/auth/store/auth_store.dart';
import 'package:finger_print_flutter/presentation/components/app_button.dart';
import 'package:finger_print_flutter/presentation/components/app_dialog.dart';
import 'package:finger_print_flutter/presentation/components/app_text_field.dart';
import 'package:finger_print_flutter/presentation/components/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../di/service_locator.dart';

class LoginScreen extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final store = getIt<AuthStore>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundWrapper(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 200,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Text(
                    'Power House',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineLarge?.copyWith(fontSize: 42),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'The Ultimate Fitness Center',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 30),
                  AppTextField(
                    label: 'Username',
                    controller: usernameController,
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    label: 'Password',
                    controller: passwordController,
                    prefixIcon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 36),
                  Observer(
                    builder: (_) => AppButton(
                      label: store.isLoading ? 'Logging in...' : 'Login',
                      onPressed: () {
                        _handleLogin(context, store);
                      },
                      icon: Icons.login,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context, AuthStore store) async {
    final success = await store.login(
      usernameController.text.trim(),
      passwordController.text.trim(),
    );

    if (success) {
      Navigator.pushReplacementNamed(context, RouteManager.dashboard);
    } else {
      showDialog(
        context: context,
        builder: (_) => AppDialog(
          title: 'Login Failed',
          message: store.loginError,
          type: AppDialogType.error,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
