import 'package:drift/drift.dart';

import '../../core/data/drift/drift_client.dart' as Financialz;
import '../../domain/entities/models/financial_transaction.dart';

class FinancialTransactionDatasource {
  final Financialz.DriftClient _driftClient;

  FinancialTransactionDatasource(this._driftClient);

  // --- Utility Functions (Mappers) ---

  FinancialTransaction mapTransactionEntityToTransaction(
      Financialz.FinancialTransaction entity,
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
    List<Financialz.FinancialTransaction> entities,
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
      Financialz.FinancialTransactionsCompanion(
            type: Value(transaction.type??""),
            amount: Value(transaction.amount??0.0),
            transactionDate: Value(transaction.transactionDate??DateTime.now()),
            description: Value(transaction.description??""),
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
