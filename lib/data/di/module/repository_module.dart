import 'dart:async';
import 'package:finger_print_flutter/data/datasources/attendance_datasource.dart';
import 'package:finger_print_flutter/data/datasources/bill_expense_datasource.dart';
import 'package:finger_print_flutter/data/datasources/financial_datasouce.dart';
import 'package:finger_print_flutter/data/repository/attendance/attendance_repository_impl.dart';
import 'package:finger_print_flutter/data/repository/expense/expense_repository_impl.dart';
import 'package:finger_print_flutter/data/repository/financial/financial_repository_impl.dart';
import 'package:finger_print_flutter/data/repository/member/member_repository_impl.dart';
import 'package:finger_print_flutter/domain/repository/attendance/attendance_repository.dart';
import 'package:finger_print_flutter/domain/repository/expense/expense_repository.dart';
import 'package:finger_print_flutter/domain/repository/financial/financial_repository.dart';
import 'package:finger_print_flutter/domain/repository/member/member_repository.dart';
import 'package:get_it/get_it.dart';

import '../../../presentation/di/module/store_module.dart';
import '../../datasources/member_datasource.dart';


final injector = GetIt.instance;

mixin RepositoryModule {
  static Future<void> configureRepositoryModuleInjection() async {
    // --- Repositories (Implementation) ---

    // Depend on their respective Data Sources
    injector.registerLazySingleton<MemberRepository>(
          () => MemberRepositoryImpl(getIt<MemberDatasource>()),
    );
    injector.registerLazySingleton<AttendanceRepository>(
          () => AttendanceRepositoryImpl(getIt<AttendanceRecordDatasource>()),
    );
    injector.registerLazySingleton<FinancialRepository>(
          () => FinancialRepositoryImpl(getIt<FinancialTransactionDatasource>()),
    );
    injector.registerLazySingleton<ExpenseRepository>(
          () => ExpenseRepositoryImpl(getIt<BillExpenseDatasource>()),
    );

  }
}
