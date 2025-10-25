import 'dart:async';
import 'package:finger_print_flutter/presentation/dashboard/home.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'di/service_locator.dart';

Future<void> main() async {
  return runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    WakelockPlus.enable();
    await ServiceLocator.configureDependencies();
    runApp(HomeScreen());
  }, (error, stackTrace) {});
}