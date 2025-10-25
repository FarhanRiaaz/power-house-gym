import 'package:drift/drift.dart';
import 'package:finger_print_flutter/core/data/drift/drift_client.dart'
    as Expenz;
import 'package:finger_print_flutter/core/list_to_csv_converter.dart';

import '../../domain/entities/models/bill_payment.dart';

class BillExpenseDatasource {
  final Expenz.DriftClient _driftClient;

  BillExpenseDatasource(this._driftClient);

  // --- Utility Functions (Mappers) ---

  BillExpense mapBillExpenseEntityToBillExpense(Expenz.BillExpense entity) {
    return BillExpense(
      id: entity.id,
      category: entity.category,
      amount: entity.amount,
      date: entity.date,
      description: entity.description,
    );
  }

  List<BillExpense> mapBillExpenseEntityListToBillExpenseList(
    List<Expenz.BillExpense> entities,
  ) {
    return entities
        .map((entity) => mapBillExpenseEntityToBillExpense(entity))
        .toList();
  }

  // --- CRUD Operations ---

  // Insert Bill/Expense:-------------------------------------------------------
  /// Records a new monthly bill or operating expense.
  Future<BillExpense> insertBillExpense(BillExpense billExpense) {
    return _driftClient
        .into(_driftClient.billExpenses)
        .insertReturning(
          Expenz.BillExpensesCompanion(
            category: Value(billExpense.category ?? ""),
            amount: Value(billExpense.amount ?? 0.0),
            date: Value(billExpense.date ?? DateTime.now()),
            description: Value(billExpense.description ?? ""),
          ),
          mode: InsertMode.insert,
        )
        .then((rows) => mapBillExpenseEntityToBillExpense(rows));
  }
  /// Update expenses
  Future<void> update(BillExpense billExpense) async {
    await (_driftClient.update(_driftClient.billExpenses)
      ..where((m) => m.id.equals(billExpense.id??0)))
        .write(Expenz.BillExpensesCompanion(
      // Explicitly define updated fields, similar to SiteDatasource
      category: Value(billExpense.category ?? ""),
      amount: Value(billExpense.amount ?? 0.0),
      date: Value(billExpense.date ?? DateTime.now()),
      description: Value(billExpense.description ?? ""),
    ));
  }

  // Get Bills/Expenses by Date Range:------------------------------------------
  /// Retrieves all bills and expenses within a specified date range for reporting.
  Future<List<BillExpense>> getBillsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final entities =
        await (_driftClient.select(_driftClient.billExpenses)..where(
              (t) => t.date.isBetween(
                Variable.withDateTime(start),
                Variable.withDateTime(end),
              ),
            ))
            .get();
    return mapBillExpenseEntityListToBillExpenseList(entities);
  }

  // Watch All Bills/Expenses (Reactive):--------------------------------------
  /// Provides a stream of all bills and expenses for real-time reporting.
  Stream<List<BillExpense>> watchAllBillExpenses() {
    return (_driftClient.select(_driftClient.billExpenses)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch()
        .map(mapBillExpenseEntityListToBillExpenseList);
  }

  // Delete Bill/Expense:-------------------------------------------------------
  /// Deletes an expense record (Super Admin only).
  Future<void> deleteBillExpense(int billId) async {
    await (_driftClient.delete(
      _driftClient.billExpenses,
    )..where((t) => t.id.equals(billId))).go();
  }

  Future<int> insertBatchFromCsv(List<List<String>> csvData) async {
    final billToInsert = <BillExpense>[];
    int successCount = 0;

    // 1. Convert CSV rows to Member objects (Validation and Mapping)
    for (final row in csvData) {
      try {
        final member = BillExpense.fromCsvRow(row);
        billToInsert.add(member);
      } on FormatException catch (e) {
        // Log the error for the specific row and skip it.
        print('Skipping row due to format error: ${e.message} in row: $row');
      } catch (e) {
        print('An unexpected error occurred during parsing: $e');
      }
    }

    if (billToInsert.isEmpty) {
      print('No valid bill found to insert.');
      return 0;
    }

    // 2. Insert objects in a single, efficient database batch transaction
    try {
      await _driftClient.batch((batch) async {
        for (final billExpense in billToInsert) {
          // IMPORTANT: Convert the Member model back into a Drift Companion
          // (or map/entity) format before inserting.
          // This mock uses a simplified insert call for demonstration.
          await _driftClient
              .into(_driftClient.billExpenses)
              .insertReturning(
                Expenz.BillExpensesCompanion(
                  category: Value(billExpense.category ?? ""),
                  amount: Value(billExpense.amount ?? 0.0),
                  date: Value(billExpense.date ?? DateTime.now()),
                  description: Value(billExpense.description ?? ""),
                ),
                mode: InsertMode.insert,
              );
          successCount++;
        }
      });
      print('Batch insertion complete. $successCount bill processed.');
      return successCount;
    } catch (e) {
      print('Database Batch Error: Failed to insert bill: $e');
      return 0; // Return 0 or re-throw based on required error handling
    }
  }

  /// Retrieves all bill and generates a complete CSV string for export.
  ///
  /// Returns a Future<String> containing the CSV data.
  Future<String> exportToCsv() async {
    // 1. Retrieve data from the database
    print('Fetching all bill from database...');
    final List<BillExpense> bill = mapBillExpenseEntityListToBillExpenseList(
      await (_driftClient.select(
        _driftClient.billExpenses,
      )..orderBy([(t) => OrderingTerm.desc(t.date)])).get(),
    );

    if (bill.isEmpty) {
      print('No bill found to export.');
      // Return a CSV with only the header
      return const SimpleCsvConverter().convert([BillExpense().toCsvHeader()]);
    }

    // 2. Prepare all data rows
    final List<List<dynamic>> csvData = [];

    // Add the header row first
    //csvData.add(bill.first.toCsvHeader());

    // Add all member data rows
    for (final member in bill) {
      csvData.add(member.toCsvRow());
    }

    // 3. Convert the list of lists into a single CSV string
    const converter = SimpleCsvConverter(
      // Using a comma separator is standard for CSV, but you can change it
      fieldDelimiter: ',',
      textDelimiter:
          '"', // Use quotes to encapsulate strings that contain commas
    );

    final csvString = converter.convert(csvData);

    print('CSV string generated successfully.');
    return csvString;
  }
}
