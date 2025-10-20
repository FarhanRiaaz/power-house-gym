import 'package:finger_print_flutter/core/data/drift/drift_client.dart';
import 'package:finger_print_flutter/data/datasources/financial_datasouce.dart';
import 'package:finger_print_flutter/domain/repository/financial/financial_repository.dart';


class FinancialRepositoryImpl implements FinancialRepository {
  final FinancialTransactionDatasource _transactionDatasource;

  FinancialRepositoryImpl(this._transactionDatasource);

  @override
  Future<FinancialTransaction> recordTransaction(
      FinancialTransaction transaction) {
    return _transactionDatasource.recordTransaction(transaction);
  }

  @override
  Future<List<FinancialTransaction>> getTransactionsByDateRange(
      DateTime start, DateTime end) {
    return _transactionDatasource.getTransactionsByDateRange(start, end);
  }

  @override
  Stream<List<FinancialTransaction>> watchAllTransactions() {
    return _transactionDatasource.watchAllTransactions();
  }

  @override
  Future<void> deleteTransaction(int transactionId) {
    return _transactionDatasource.deleteTransaction(transactionId);
  }
}
