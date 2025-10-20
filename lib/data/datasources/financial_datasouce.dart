import 'package:drift/drift.dart';
import 'package:finger_print_flutter/core/data/drift/drift_client.dart';

class FinancialTransactionDatasource {
  final DriftClient _driftClient;

  FinancialTransactionDatasource(this._driftClient);

  // --- Utility Functions (Mappers) ---

  FinancialTransaction mapTransactionEntityToTransaction(
    FinancialTransaction entity,
  ) {
    return FinancialTransaction(
      id: entity.id,
      type: entity.type,
      amount: entity.amount,
      transactionDate: entity.transactionDate,
      description: entity.description,
      relatedMemberId: entity.relatedMemberId,
    );
  }

  List<FinancialTransaction> mapTransactionEntityListToTransactionList(
    List<FinancialTransaction> entities,
  ) {
    return entities
        .map((entity) => mapTransactionEntityToTransaction(entity))
        .toList();
  }

  // --- CRUD Operations ---

  // Record Transaction (Insert):-----------------------------------------------
  /// Records a new financial transaction (e.g., fee payment).
  Future<FinancialTransaction> recordTransaction(
    FinancialTransaction transaction,
  ) {
    return _driftClient
        .into(_driftClient.financialTransactions)
        .insertReturning(
          FinancialTransactionsCompanion(
            type: Value(transaction.type),
            amount: Value(transaction.amount),
            transactionDate: Value(transaction.transactionDate),
            description: Value(transaction.description),
            relatedMemberId: Value(transaction.relatedMemberId),
          ),
          mode: InsertMode.insert,
        )
        .then((rows) => mapTransactionEntityToTransaction(rows));
  }

  // Get Transactions by Date Range:--------------------------------------------
  /// Retrieves all transactions between a start and end date for sales reporting.
  Future<List<FinancialTransaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final entities =
        await (_driftClient.select(_driftClient.financialTransactions)..where(
              (t) => t.transactionDate.isBetween(
                Variable.withDateTime(start),
                Variable.withDateTime(end),
              ),
            ))
            .get();
    return mapTransactionEntityListToTransactionList(entities);
  }

  // Watch All Transactions (Reactive):-----------------------------------------
  /// Provides a stream of all transactions, useful for real-time sales dashboard updates.
  Stream<List<FinancialTransaction>> watchAllTransactions() {
    return (_driftClient.select(_driftClient.financialTransactions)
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .watch()
        .map(mapTransactionEntityListToTransactionList);
  }

  // Delete Transaction:--------------------------------------------------------
  /// Deletes a transaction record (Super Admin only).
  Future<void> deleteTransaction(int transactionId) async {
    await (_driftClient.delete(
      _driftClient.financialTransactions,
    )..where((t) => t.id.equals(transactionId))).go();
  }
}
