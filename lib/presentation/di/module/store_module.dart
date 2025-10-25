import 'dart:async';
import 'package:finger_print_flutter/data/service/biometric/biometric_service.dart';
import 'package:finger_print_flutter/domain/usecases/attendance/log_attendance_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/auth/auth_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/bill/bill_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/export/import_export_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/financial/financial_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/member/member_usecase.dart';
import 'package:finger_print_flutter/presentation/attendance/store/attendance_store.dart';
import 'package:finger_print_flutter/presentation/auth/store/auth_store.dart';
import 'package:finger_print_flutter/presentation/dashboard/store/dashboard_store.dart';
import 'package:finger_print_flutter/presentation/expense/store/expense_store.dart';
import 'package:finger_print_flutter/presentation/financial/store/financial_store.dart';
import 'package:finger_print_flutter/presentation/member/store/member_store.dart';
import 'package:get_it/get_it.dart';

// this contain most of injection part for stores
final getIt = GetIt.instance;
mixin StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    // Stores are registered as Singletons (Lazy/Eager) as they manage application state.
    // Member Store
    getIt.registerLazySingleton<MemberStore>(
      () => MemberStore(
        getIt<GetAllMembersUseCase>(),
        getIt<UpdateMemberUseCase>(),
        getIt<InsertMemberUseCase>(),
        getIt<DeleteMemberUseCase>(),
        getIt<FindMemberByIdUseCase>(),
        getIt<GetAllStoredFMDS>(),
        getIt<ImportDataUseCase>(),
        // getIt<EnrollFingerprintUseCase>(), // New Biometric dependency
      ),
    );

    getIt.registerLazySingleton<DashboardStore>(
      () => DashboardStore(
        getIt<GetBillsByDateRangeUseCase>(),

        getIt<GetAttendanceRecordUseCase>(),

        getIt<GetTransactionsByDateRangeUseCase>(),

        getIt<GetAllMembersUseCase>(),
        //getIt<BiometricService>(),
      ),
    );

    // Attendance Store
    getIt.registerLazySingleton<AttendanceStore>(
      () => AttendanceStore(
        getIt<GetAttendanceByMemberIdRecordUseCase>(),
        getIt<GetAttendanceRecordUseCase>(),
        getIt<LogAttendanceUseCase>(),
        getIt<WatchTodayAttendanceUseCase>(),
        getIt<GetDailyAttendanceReportUseCase>(),
        getIt<ImportDataUseCase>(),
      ),
    );

    // Financial Store
    getIt.registerLazySingleton<FinancialStore>(
      () => FinancialStore(
        getIt<RecordFinancialTransactionUseCase>(),
        getIt<WatchAllTransactionsUseCase>(),
        getIt<ImportDataUseCase>(),
        getIt<GetTransactionsByDateRangeUseCase>(),
        getIt<DeleteTransactionUseCase>(),
      ),
    );

    // Expense Store
    getIt.registerLazySingleton<ExpenseStore>(
      () => ExpenseStore(
        getIt<InsertBillExpenseUseCase>(),
        getIt<WatchAllExpensesUseCase>(),
        getIt<GetBillsByDateRangeUseCase>(),
        getIt<DeleteBillExpenseUseCase>(),
        getIt<UpdateExpenseUseCase>(),
      ),
    );

    // --- Auth Store ---
    getIt.registerLazySingleton<AuthStore>(
      () => AuthStore(
        getIt<LoginUseCase>(),
        getIt<LogoutUseCase>(),
        getIt<ChangePasswordUseCase>(),
      ),
    );
  }
}
