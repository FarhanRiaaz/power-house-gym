
import 'package:finger_print_flutter/data/datasources/attendance_datasource.dart';
import 'package:finger_print_flutter/domain/repository/attendance/attendance_repository.dart';
import 'package:finger_print_flutter/domain/repository/expense/expense_repository.dart';
import 'package:finger_print_flutter/domain/repository/financial/financial_repository.dart';
import 'package:finger_print_flutter/domain/repository/member/member_repository.dart';

import '../../../../domain/entities/models/bill_payment.dart' show BillExpense;
import '../../../../domain/entities/models/financial_transaction.dart' show FinancialTransaction;
import '../../../../domain/entities/models/member.dart' show Member;

/// Concrete implementation for handling file I/O and data formatting.
/// (The actual file I/O logic would use packages like `csv` or `excel`
/// and platform-specific file pickers.)
class DataUtilityServiceImpl implements DataUtilityService {
  final MemberRepository memberRepository;
  final FinancialRepository financialRepository;
  final ExpenseRepository expenseRepository;
  final AttendanceRepository attendanceRepository;


  DataUtilityServiceImpl(this.memberRepository,this.financialRepository,this.expenseRepository,this.attendanceRepository);

  @override
  Future<bool> exportData({List<Member>? members, List<FinancialTransaction>? transactions, List<BillExpense>? expenses, String? baseDirectoryPath
  }) async {


    print('--- Use Case: Starting Data Export Orchestration ---');

    // 1. Fetch all necessary data from the Repositories
    // (This is the business logic determining what data needs to go out)
    final members = await memberRepository.getMembersToExport();
    final transactions = await financialRepository.getTransactionsForPeriod();
    final expenses = await expenseRepository.getUpcomingExpenses();
    final attendance = await attendanceRepository.getUpcomingExpenses();

    // 2. Perform any required business validation or formatting checks here
    final List<_ExportTask> tasks = [
      _ExportTask(
        data: members,
        tableName: 'Members',
        filePath: '$baseDirectoryPath/members_export.csv',
      ),
      _ExportTask(
        data: transactions,
        tableName: 'Transactions',
        filePath: '$baseDirectoryPath/transactions_export.csv',
      ),
      _ExportTask(
        data: expenses,
        tableName: 'Expenses',
        filePath: '$baseDirectoryPath/expenses_export.csv',
      ),

      _ExportTask(
        data: attendance,
        tableName: 'Attendance',
        filePath: '$baseDirectoryPath/expenses_export.csv',
      ),
    ];

    // 3. Execute all tasks sequentially and track results
    final List<bool> results = [];

    for (final task in tasks) {
      if (task.data.isNotEmpty) {
        final success = await fileService.exportSingleTable(
          data: task.data,
          filePath: task.filePath,
          tableName: task.tableName,
        );
        results.add(success);
      } else {
        // If the table is empty, we consider this export task successful.
        print('Skipping export for empty table: ${task.tableName}');
        results.add(true);
      }
    }

    // 4. Determine overall success
    final overallSuccess = results.every((r) => r == true);

    print('--- Use Case: Batch Export completed (Overall Success: $overallSuccess) ---');
    return overallSuccess;
  }

  @override
  Future<int> importNewMembers(String filePath) async {
    // [Mock Logic] In a real app, this would read the file, validate data,
    // and process it via the InsertMemberUseCase.
    print('Importing members from $filePath...');

    // Simulate reading 15 new members
    await Future.delayed(const Duration(seconds: 1));
    return 15;
  }

}

abstract class DataUtilityService {
  Future<bool> exportData({List<Member> members, List<FinancialTransaction> transactions, List<BillExpense> expenses, String baseDirectoryPath});
  Future<int> importNewMembers(String filePath);
}

class _ExportTask {
  final List data;
  final String tableName;
  final String filePath;
  _ExportTask({required this.data, required this.tableName, required this.filePath});
}

