import 'dart:io';
import 'package:finger_print_flutter/core/list_to_csv_converter.dart';
import 'package:finger_print_flutter/domain/repository/attendance/attendance_repository.dart';
import 'package:finger_print_flutter/domain/repository/expense/expense_repository.dart';
import 'package:finger_print_flutter/domain/repository/financial/financial_repository.dart';
import 'package:finger_print_flutter/domain/repository/member/member_repository.dart';
import 'package:finger_print_flutter/domain/usecases/export/import_export_usecase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

enum CsvImportType { member, attendance, expense, financial }
/// Concrete implementation for handling file I/O and data formatting.
/// (The actual file I/O logic would use packages like `csv` or `excel`
/// and platform-specific file pickers.)
class DataUtilityServiceImpl implements DataUtilityService {
  final MemberRepository memberRepository;
  final FinancialRepository financialRepository;
  final ExpenseRepository expenseRepository;
  final AttendanceRepository attendanceRepository;

  DataUtilityServiceImpl(
    this.memberRepository,
    this.financialRepository,
    this.expenseRepository,
    this.attendanceRepository,
  );

  Future<String> getPowerHouseDirectoryPath() async {
    // If this code is run on Android/iOS/Web, getDesktopDirectory() will return null
    // or throw an error, as it is only supported on Windows, macOS, and Linux.
    try {
      // 1. Call the method provided by path_provider
      final desktopDir = await getDownloadsDirectory();

      if (desktopDir == null) {
        // Fallback for non-desktop environments or if the path is unknown.
        print(
          'Warning: Desktop directory not resolvable. Using temporary directory instead.',
        );
        final tempDir = await getTemporaryDirectory();
        return p.join(tempDir.path, 'PowerHouse');
      }

      // 2. Construct the full path: /Desktop/PowerHouse
      final powerhouseDirPath = p.join(desktopDir.path, 'PowerHouse');
      final powerhouseDir = Directory(powerhouseDirPath);

      // 3. Ensure the directory is created.
      await powerhouseDir.create(recursive: true);

      print('PowerHouse directory ready at: $powerhouseDirPath');

      // 4. Return the path string.
      return powerhouseDirPath;
    } catch (e) {
      print(
        'Error finding or creating PowerHouse directory. Check if you ran "flutter pub get": $e',
      );
      return '';
    }
  }

  @override
  Future<void> exportData() async {
    print('--- Use Case: Starting Data Export Orchestration ---');
    final baseDirectoryPath = await getPowerHouseDirectoryPath();
    // 1. Fetch all necessary data from the Repositories
    // (This is the business logic determining what data needs to go out)
    final members = await memberRepository.exportToCsv();
    final transactions = await financialRepository.exportToCsv();
    final expenses = await expenseRepository.exportToCsv();
    final attendance = await attendanceRepository.exportToCsv();

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
    for (final task in tasks) {
      if (task.data.isNotEmpty) {
        try {
          // 3. Create a File object using the target path
          final file = File(task.filePath);

          // 4. Use writeAsString to asynchronously save the content
          await file.writeAsString(task.data, encoding: systemEncoding);

          print('SUCCESS: CSV file generated and saved.');
          print('Path: ${file.absolute.path}');
          print('Content saved:\n---');
        } catch (e) {
          print('ERROR: Could not write file: $e');
        }
      } else {
        print('Skipping export for empty table: ${task.tableName}');
      }
    }

    print('--- Use Case: Batch Export completed!');
  }

  @override
  Future<List<List<String>>> importNewMembers(String filePath) async {
    return await SimpleCsvConverter().readCsvFile(filePath);
  }
  
  @override
  Future<int> insertBatchFromCsv(ImportDataParams data) async {
  switch (data.type) {
    case CsvImportType.member:
      return await memberRepository.insertBatchFromCsv(data.csvData);
    case CsvImportType.attendance:
      return await attendanceRepository.insertBatchFromCsv(data.csvData);
    case CsvImportType.expense:
      return await expenseRepository.insertBatchFromCsv(data.csvData);
    case CsvImportType.financial:
      return await financialRepository.insertBatchFromCsv(data.csvData);
  }
}

}

abstract class DataUtilityService {
  Future<void> exportData();

  Future<List<List<String>>> importNewMembers(String filePath);

 Future<int> insertBatchFromCsv(ImportDataParams data);

}

class _ExportTask {
  final String data;
  final String tableName;
  final String filePath;

  _ExportTask({
    required this.data,
    required this.tableName,
    required this.filePath,
  });
}
