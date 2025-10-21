import 'package:finger_print_flutter/data/di/module/local_module.dart';
import 'package:finger_print_flutter/data/di/module/repository_module.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

mixin DataLayerInjection {
  static Future<void> configureDataLayerInjection() async {
    await LocalModule.configureLocalModuleInjection();
    await RepositoryModule.configureRepositoryModuleInjection();
  }
}
