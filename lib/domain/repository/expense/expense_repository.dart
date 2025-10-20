
import '../../entities/models/bill_payment.dart';

/// Defines the contract for managing the gym's overhead costs (Bill Expenses).
abstract class ExpenseRepository {
  /// Records a new bill or operating expense.
  Future<BillExpense> insertExpense(BillExpense billExpense);

  /// Retrieves a list of all bills/expenses within a specific date range for reporting.
  Future<List<BillExpense>> getExpensesByDateRange(
      DateTime start, DateTime end);

  /// Provides a real-time stream of all bills/expenses for dashboard updates.
  Stream<List<BillExpense>> watchAllExpenses();

  /// Deletes an expense record (typically restricted to Super Admin).
  Future<void> deleteExpense(int billId);
}
