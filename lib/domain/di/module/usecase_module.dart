
import 'package:finger_print_flutter/domain/repository/attendance/attendance_repository.dart';
import 'package:finger_print_flutter/domain/repository/expense/expense_repository.dart';
import 'package:finger_print_flutter/domain/repository/financial/financial_repository.dart';
import 'package:finger_print_flutter/domain/repository/member/member_repository.dart';
import 'package:finger_print_flutter/domain/usecases/attendance/log_attendance_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/bill/bill_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/financial/financial_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/member/member_usecase.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

mixin UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {

    // Member Use Cases (depend on MemberRepository)
    getIt.registerFactory(() => GetAllMembersUseCase(getIt<MemberRepository>()));
    getIt.registerFactory(() => InsertMemberUseCase(getIt<MemberRepository>()));
    getIt.registerFactory(() => UpdateMemberUseCase(getIt<MemberRepository>()));
    getIt.registerFactory(() => DeleteMemberUseCase(getIt<MemberRepository>()));
    getIt.registerFactory(() => FindMemberByIdUseCase(getIt<MemberRepository>()));
    getIt.registerFactory(() => FindMemberByFingerprintUseCase(getIt<MemberRepository>()));

    // Attendance Use Cases (depend on AttendanceRepository)
    getIt.registerFactory(() => LogAttendanceUseCase(getIt<AttendanceRepository>()));
    getIt.registerFactory(() => GetAttendanceRecordUseCase(getIt<AttendanceRepository>()));
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