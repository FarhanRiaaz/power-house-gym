import 'package:finger_print_flutter/core/base_usecase.dart';
import 'package:finger_print_flutter/domain/repository/financial/financial_repository.dart';

import '../../entities/models/financial_transaction.dart';

/// Records a new financial transaction (e.g., fee payment).
///
/// Type: FinancialTransaction (The inserted record)
/// Params: FinancialTransaction (The transaction object)
class RecordFinancialTransactionUseCase
    extends UseCase<FinancialTransaction, FinancialTransaction> {
  final FinancialRepository _financialRepository;

  RecordFinancialTransactionUseCase(this._financialRepository);

  @override
  Future<FinancialTransaction> call({required FinancialTransaction params}) {
    return _financialRepository.recordTransaction(params);
  }
}

/// Parameters for querying transactions between two dates.
class DateRangeParams {
  final DateTime start;
  final DateTime end;

  DateRangeParams({required this.start, required this.end});
}

/// Fetches a one-time list of financial transactions within a date range.
///
/// Type: List<FinancialTransaction>
/// Params: DateRangeParams (Start and end dates)
class GetTransactionsByDateRangeUseCase
    extends UseCase<List<FinancialTransaction>, DateRangeParams> {
  final FinancialRepository _financialRepository;

  GetTransactionsByDateRangeUseCase(this._financialRepository);

  @override
  Future<List<FinancialTransaction>> call({required DateRangeParams params}) {
    return _financialRepository.getTransactionsByDateRange(
      params.start,
      params.end,
    );
  }
}

/// Provides a real-time stream of all financial transactions, ordered by date.
///
/// Type: Stream<List<FinancialTransaction>>
/// Params: void (no parameters needed)
class WatchAllTransactionsUseCase
    extends UseCase<Stream<List<FinancialTransaction>>, void> {
  final FinancialRepository _financialRepository;

  WatchAllTransactionsUseCase(this._financialRepository);

  @override
  Future<Stream<List<FinancialTransaction>>> call({void params}) async {
    return _financialRepository.watchAllTransactions();
  }
}

/// Deletes a specific financial transaction record by its ID.
///
/// Type: void
/// Params: int (The ID of the transaction record)
class DeleteTransactionUseCase extends UseCase<void, int> {
  final FinancialRepository _financialRepository;

  DeleteTransactionUseCase(this._financialRepository);

  @override
  Future<void> call({required int params}) {
    return _financialRepository.deleteTransaction(params);
  }
}