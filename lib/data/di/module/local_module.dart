import 'dart:async';
import 'package:finger_print_flutter/data/datasources/attendance_datasource.dart';
import 'package:finger_print_flutter/data/datasources/bill_expense_datasource.dart';
import 'package:finger_print_flutter/data/datasources/financial_datasouce.dart';
import 'package:finger_print_flutter/data/datasources/member_datasource.dart';
import 'package:finger_print_flutter/data/sharedpref/shared_preference_helper.dart';
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
