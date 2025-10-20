import 'package:drift/drift.dart';
import 'package:finger_print_flutter/core/data/drift/drift_client.dart' as Expenz;

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
      List<Expenz.BillExpense> entities) {
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
        category: Value(billExpense.category??""),
        amount: Value(billExpense.amount??0.0),
        date: Value(billExpense.date??DateTime.now()),
        description: Value(billExpense.description??""),
      ),
      mode: InsertMode.insert,
    )
        .then((rows) => mapBillExpenseEntityToBillExpense(rows));
  }

  // Get Bills/Expenses by Date Range:------------------------------------------
  /// Retrieves all bills and expenses within a specified date range for reporting.
  Future<List<BillExpense>> getBillsByDateRange(
      DateTime start, DateTime end) async {
    final entities = await (_driftClient.select(_driftClient.billExpenses)
      ..where((t) =>
          t.date.isBetween(Variable.withDateTime(start), Variable.withDateTime(end))))
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
    await (_driftClient.delete(_driftClient.billExpenses)
      ..where((t) => t.id.equals(billId)))
        .go();
  }
}