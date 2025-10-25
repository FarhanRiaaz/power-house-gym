import 'package:finger_print_flutter/presentation/auth/login_screen.dart';
import 'package:finger_print_flutter/presentation/dashboard/dashboard_screen.dart';
import 'package:finger_print_flutter/presentation/dashboard/home.dart';
import 'package:finger_print_flutter/presentation/member/member_screen.dart';
import 'package:flutter/material.dart';
// Add other screens here

class RouteManager {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String members = '/members';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case members:
        return MaterialPageRoute(builder: (_) => ManageMemberScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
