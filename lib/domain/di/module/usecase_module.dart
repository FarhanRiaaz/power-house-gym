import 'package:finger_print_flutter/domain/entities/auth/auth_service.dart';
import 'package:finger_print_flutter/domain/entities/auth/auth_service_impl.dart';
import 'package:finger_print_flutter/domain/entities/report/export/export_data_service_impl.dart';
import 'package:finger_print_flutter/domain/repository/attendance/attendance_repository.dart';
import 'package:finger_print_flutter/domain/repository/expense/expense_repository.dart';
import 'package:finger_print_flutter/domain/repository/financial/financial_repository.dart';
import 'package:finger_print_flutter/domain/repository/member/member_repository.dart';
import 'package:finger_print_flutter/domain/usecases/attendance/log_attendance_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/auth/auth_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/bill/bill_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/financial/financial_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/member/member_usecase.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

mixin UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {
    // Standalone Services (Auth, Biometric, Data Utility)
    getIt.registerLazySingleton<AuthService>(() => AuthServiceImpl());

    getIt.registerLazySingleton<DataUtilityService>(() => DataUtilityServiceImpl());

    getIt.registerLazySingleton<BiometricService>(() => BiometricServiceImpl());


    getIt.registerFactory(() => LoginUseCase(getIt<AuthService>()));
    getIt.registerFactory(() => LogoutUseCase(getIt<AuthService>()));
    getIt.registerFactory(() => ChangePasswordUseCase(getIt<AuthService>()));

    // --- Biometric Use Cases ---
    getIt.registerFactory(() => EnrollFingerprintUseCase(getIt<BiometricService>()));

    // --- Data Utility Use Cases ---
    getIt.registerFactory(() => ExportDataUseCase(getIt<DataUtilityService>()));
    getIt.registerFactory(() => ImportMembersUseCase(getIt<DataUtilityService>()));



    // Member Use Cases (depend on MemberRepository)
    getIt.registerFactory(() => GetAllMembersUseCase(getIt<MemberRepository>()));
    getIt.registerFactory(() => InsertMemberUseCase(getIt<MemberRepository>()));
    getIt.registerFactory(() => UpdateMemberUseCase(getIt<MemberRepository>()));
    getIt.registerFactory(() => DeleteMemberUseCase(getIt<MemberRepository>()));
    getIt.registerFactory(() => FindMemberByIdUseCase(getIt<MemberRepository>()));
    getIt.registerFactory(() => FindMemberByFingerprintUseCase(getIt<MemberRepository>()));

    // Attendance Use Cases (depend on AttendanceRepository)
    getIt.registerFactory(() => LogAttendanceUseCase(getIt<AttendanceRepository>()));
    getIt.registerFactory(() => WatchTodayAttendanceUseCase(getIt<AttendanceRepository>()));
    getIt.registerFactory(() => GetDailyAttendanceReportUseCase(getIt<AttendanceRepository>()));
   // getIt.registerFactory(() => DeleteAttendanceRecordUseCase(getIt<AttendanceRepository>()));

    // Financial Use Cases (depend on FinancialRepository)
    getIt.registerFactory(() => RecordFinancialTransactionUseCase(getIt<FinancialRepository>()));
    getIt.registerFactory(() => GetTransactionsByDateRangeUseCase(getIt<FinancialRepository>()));
    getIt.registerFactory(() => WatchAllTransactionsUseCase(getIt<FinancialRepository>()));
    getIt.registerFactory(() => DeleteTransactionUseCase(getIt<FinancialRepository>()));

    // Expense Use Cases (depend on ExpenseRepository)
    getIt.registerFactory(() => InsertBillExpenseUseCase(getIt<ExpenseRepository>()));
    getIt.registerFactory(() => GetBillsByDateRangeUseCase(getIt<ExpenseRepository>()));
    getIt.registerFactory(() => WatchAllExpensesUseCase(getIt<ExpenseRepository>()));
    getIt.registerFactory(() => DeleteBillExpenseUseCase(getIt<ExpenseRepository>()));
  }
}