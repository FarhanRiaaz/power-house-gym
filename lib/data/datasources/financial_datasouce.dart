import 'package:drift/drift.dart';
import 'package:finger_print_flutter/core/list_to_csv_converter.dart';

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
            type: Value(transaction.type ?? ""),
            amount: Value(transaction.amount ?? 0.0),
            transactionDate: Value(
              transaction.transactionDate ?? DateTime.now(),
            ),
            description: Value(transaction.description ?? ""),
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

  Future<int> insertBatchFromCsv(List<List<String>> csvData) async {
    final membersToInsert = <FinancialTransaction>[];
    int successCount = 0;

    // 1. Convert CSV rows to Member objects (Validation and Mapping)
    for (final row in csvData) {
      try {
        final member = FinancialTransaction.fromCsvRow(row);
        membersToInsert.add(member);
      } on FormatException catch (e) {
        // Log the error for the specific row and skip it.
        print('Skipping row due to format error: ${e.message} in row: $row');
      } catch (e) {
        print('An unexpected error occurred during parsing: $e');
      }
    }

    if (membersToInsert.isEmpty) {
      print('No valid FinancialTransaction found to insert.');
      return 0;
    }

    // 2. Insert objects in a single, efficient database batch transaction
    try {
      await _driftClient.batch((batch) async {
        for (final transaction in membersToInsert) {
          // IMPORTANT: Convert the Member model back into a Drift Companion
          // (or map/entity) format before inserting.
          // This mock uses a simplified insert call for demonstration.
          await _driftClient
              .into(_driftClient.financialTransactions)
              .insertReturning(
                Financialz.FinancialTransactionsCompanion(
                  type: Value(transaction.type ?? ""),
                  amount: Value(transaction.amount ?? 0.0),
                  transactionDate: Value(
                    transaction.transactionDate ?? DateTime.now(),
                  ),
                  description: Value(transaction.description ?? ""),
                  relatedMemberId: Value(transaction.relatedMemberId),
                ),
                mode: InsertMode.insert,
              );
          successCount++;
        }
      });
      print('Batch insertion complete. $successCount members processed.');
      return successCount;
    } catch (e) {
      print('Database Batch Error: Failed to insert members: $e');
      return 0; // Return 0 or re-throw based on required error handling
    }
  }

  /// Retrieves all members and generates a complete CSV string for export.
  ///
  /// Returns a Future<String> containing the CSV data.
  Future<String> exportToCsv() async {
    // 1. Retrieve data from the database
    print('Fetching all members from database...');
    final entities = await _driftClient
        .select(_driftClient.financialTransactions)
        .get();

    final List<FinancialTransaction> members =
        mapTransactionEntityListToTransactionList(entities);

    if (members.isEmpty) {
      print('No members found to export.');
      // Return a CSV with only the header
      return const SimpleCsvConverter().convert([
        FinancialTransaction().toCsvHeader(),
      ]);
    }

    // 2. Prepare all data rows
    final List<List<dynamic>> csvData = [];

    // Add the header row first
   // csvData.add(members.first.toCsvHeader());

    // Add all member data rows
    for (final member in members) {
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
