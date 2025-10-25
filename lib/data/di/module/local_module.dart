import 'dart:async';
import 'package:finger_print_flutter/data/datasources/attendance_datasource.dart';
import 'package:finger_print_flutter/data/datasources/bill_expense_datasource.dart';
import 'package:finger_print_flutter/data/datasources/financial_datasouce.dart';
import 'package:finger_print_flutter/data/datasources/member_datasource.dart';
import 'package:finger_print_flutter/data/service/auth/auth_service.dart';
import 'package:finger_print_flutter/data/service/auth/auth_service_impl.dart';
import 'package:finger_print_flutter/data/service/biometric/biometric_service.dart';
import 'package:finger_print_flutter/data/service/biometric/biometric_service_impl.dart';
import 'package:finger_print_flutter/data/service/report/export/export_data_service_impl.dart';
import 'package:finger_print_flutter/data/sharedpref/shared_preference_helper.dart';
import 'package:finger_print_flutter/domain/repository/attendance/attendance_repository.dart';
import 'package:finger_print_flutter/domain/repository/expense/expense_repository.dart';
import 'package:finger_print_flutter/domain/repository/financial/financial_repository.dart';
import 'package:finger_print_flutter/domain/repository/member/member_repository.dart';
import 'package:finger_print_flutter/domain/usecases/auth/auth_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/export/import_export_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/data/drift/drift_client.dart';

final injector = GetIt.instance;

mixin LocalModule {
  static Future<void> configureLocalModuleInjection() async {
    // preference manager:------------------------------------------------------
    injector.registerSingletonAsync<SharedPreferences>(
        SharedPreferences.getInstance);
    injector.registerSingleton<SharedPreferenceHelper>(
      SharedPreferenceHelper(await injector.getAsync<SharedPreferences>()),
    );
    // database:----------------------------------------------------------------
    injector.registerSingletonAsync<DriftClient>(
            () async => DriftClient()
    );

    // Standalone Services (Auth, Biometric, Data Utility)
    injector.registerLazySingleton<AuthService>(() => AuthServiceImpl());

    injector.registerLazySingleton<DataUtilityService>(() => DataUtilityServiceImpl(injector<MemberRepository>(),injector<FinancialRepository>(),injector<ExpenseRepository>(),injector<AttendanceRepository>()));
    //injector.registerLazySingleton<BiometricService>(() => BiometricServiceImpl());

    injector.registerFactory(() => LoginUseCase(injector<AuthService>()));
    injector.registerFactory(() => LogoutUseCase(injector<AuthService>()));
    injector.registerFactory(() => ChangePasswordUseCase(injector<AuthService>()));

    // --- Biometric Use Cases ---
   // injector.registerFactory(() => EnrollFingerprintUseCase(injector<BiometricService>()));
    //injector.registerFactory(() => VerifyFingerprintUseCase(injector<BiometricService>()));

    // --- Data Utility Use Cases ---
    injector.registerFactory(() => ExportDataUseCase(injector<DataUtilityService>()));
    injector.registerFactory(() => ImportDataUseCase(injector<DataUtilityService>()));

    // data sources:------------------------------------------------------------
    injector.registerSingleton(
        MemberDatasource(await injector.getAsync<DriftClient>()));

    injector.registerSingleton(
        FinancialTransactionDatasource(await injector.getAsync<DriftClient>()));

    injector.registerSingleton(
        BillExpenseDatasource(await injector.getAsync<DriftClient>()));

    injector.registerSingleton(
        AttendanceRecordDatasource(await injector.getAsync<DriftClient>()));
  }
}
