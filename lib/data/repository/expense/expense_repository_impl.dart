import 'package:finger_print_flutter/data/datasources/bill_expense_datasource.dart';
import 'package:finger_print_flutter/domain/repository/expense/expense_repository.dart';

import '../../../domain/entities/models/bill_payment.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final BillExpenseDatasource _expenseDatasource;

  ExpenseRepositoryImpl(this._expenseDatasource);

  @override
  Future<BillExpense> insertExpense(BillExpense billExpense) {
    return _expenseDatasource.insertBillExpense(billExpense);
  }

  @override
  Future<void> update(BillExpense billExpense) {
    // Delegates to the new update method in Datasource
    return _expenseDatasource.update(billExpense);
  }

  @override
  Future<List<BillExpense>> getExpensesByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return _expenseDatasource.getBillsByDateRange(start, end);
  }

  @override
  Stream<List<BillExpense>> watchAllExpenses() {
    return _expenseDatasource.watchAllBillExpenses();
  }

  @override
  Future<void> deleteExpense(int billId) {
    return _expenseDatasource.deleteBillExpense(billId);
  }

  /// Takes parsed CSV data and inserts it into the database using a batch operation.
  /// This is the single, powerful function you can call from your Import Use Case.
  @override
  Future<int> insertBatchFromCsv(List<List<String>> csvData) async {
    return await _expenseDatasource.insertBatchFromCsv(csvData);
  }

  @override
  Future<String> exportToCsv() async {
    return await _expenseDatasource.exportToCsv();
  }
}
