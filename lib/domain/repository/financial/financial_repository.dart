

import '../../entities/models/financial_transaction.dart';

/// Defines the contract for managing all income (Financial Transactions) and reporting.
abstract class FinancialRepository {
  /// Records a new financial transaction (e.g., membership fee payment).
  Future<FinancialTransaction> recordTransaction(FinancialTransaction transaction);

  /// Retrieves a list of all transactions within a specific date range for reporting.
  Future<List<FinancialTransaction>> getTransactionsByDateRange(
      DateTime start, DateTime end);

  /// Provides a real-time stream of all transactions for dashboard updates.
  Stream<List<FinancialTransaction>> watchAllTransactions();

  /// Deletes a financial transaction record (typically restricted to Super Admin).
  Future<void> deleteTransaction(int transactionId);
}
