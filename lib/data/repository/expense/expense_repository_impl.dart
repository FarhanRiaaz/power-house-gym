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
}
