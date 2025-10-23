import 'package:finger_print_flutter/data/service/report/export/export_data_service_impl.dart';
import 'package:finger_print_flutter/domain/usecases/export/import_export_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/financial/financial_usecase.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../domain/entities/models/financial_transaction.dart';

part 'financial_store.g.dart';

class FinancialStore = _FinancialStore with _$FinancialStore;

abstract class _FinancialStore with Store {
  // --- Dependencies (Use Cases) ---
  final RecordFinancialTransactionUseCase _recordTransactionUseCase;
  final WatchAllTransactionsUseCase _watchAllTransactionsUseCase;
  final ImportDataUseCase _importDataUseCase;
  final GetTransactionsByDateRangeUseCase _getRangeReportUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;

  _FinancialStore(
      this._recordTransactionUseCase,
      this._watchAllTransactionsUseCase,
      this._importDataUseCase,
      this._getRangeReportUseCase,
      this._deleteTransactionUseCase,
      );

  // --- Store State Variables ---

  // Reactive list for a central dashboard view
  @observable
  Stream<List<FinancialTransaction>> allTransactionsStream = Stream.value(const []);

  @observable
  ObservableList<FinancialTransaction> allTransactionsList = ObservableList();

  // For report generation
  @observable
  ObservableList<FinancialTransaction> reportTransactionsList = ObservableList();

  @observable
  DateTime reportStartDate = DateTime.now().subtract(const Duration(days: 30));

  @observable
  DateTime reportEndDate = DateTime.now();

  @observable
  List<FinancialTransaction> _filteredExpenses = [];

  void setFilterAndFetch(DateTimeRange? range) async {
    _currentFilterRange = range;
    reportStartDate = range?.start?? DateTime.now();
    reportEndDate = range?.end?? DateTime.now();

    await generateRangeReport();
  }

  DateTimeRange? _currentFilterRange;
  DateTimeRange? get currentFilterRange => _currentFilterRange;

  // For form input
  @observable
  FinancialTransaction newTransaction = FinancialTransaction(
    type: 'Fee Payment',
    amount: 0.0,
    transactionDate: DateTime.now(),
    description: '',
    relatedMemberId: null, id: null,
  );

  @observable
  bool isLoadingReport = false;

  // --- Computed Values ---

  @computed
  bool get isLoading => isLoadingReport;

  @computed
  double get totalIncomeInReport {
    return reportTransactionsList.fold(
      0.0,
          (sum, tx) => sum + tx.amount!,
    );
  }

  // --- Actions (Mutations and Data Fetching) ---

  /// Subscribes to all financial transactions for real-time updates.
  @action
  void watchAllTransactions() {
    // Set up the stream subscription
    _watchAllTransactionsUseCase.call(params: null).then((stream) {
      allTransactionsStream = stream;

      allTransactionsStream.listen((list) {
        runInAction(() {
          allTransactionsList = ObservableList.of(list);
        });
      });
    }).catchError((error) {
      runInAction(() {
        print("Error setting up transaction stream: $error");
      });
    });
  }

  /// Records a new financial transaction (e.g., a member fee payment).
  @action
  Future<FinancialTransaction?> recordTransaction(FinancialTransaction newTransaction) async {
    if (newTransaction.amount! <= 0.0 || newTransaction.type!.isEmpty) {
      print("Transaction amount or type is invalid. ${newTransaction.toString()}");
      return null;
    }

    try {
      final transaction = await _recordTransactionUseCase.call(params: newTransaction);

      // Clear the form model after successful insertion
      runInAction(() {
        newTransaction = FinancialTransaction(
          type: 'Fee Payment',
          amount: 0.0,
          transactionDate: DateTime.now(),
          description: '',
          relatedMemberId: null,
        );
      });

      // The allTransactionsList is automatically refreshed by the stream listener.
      return transaction;
    } catch (error) {
      print("Error recording transaction: $error");
      throw error;
    }
  }
 @action
  Future<int> importDataToDatabase(List<List<String>> csvData) async {
   return await _importDataUseCase.call(params: ImportDataParams(csvData: csvData,type: CsvImportType.financial));
  }
  /// Fetches a one-time report of transactions for the currently selected date range.
  @action
  Future<void> generateRangeReport() async {
    isLoadingReport = true;
    try {
      final params = DateRangeParams(
        start: reportStartDate,
        end: reportEndDate,
      );

      final records = await _getRangeReportUseCase.call(params: params);

      runInAction(() {
        reportTransactionsList = ObservableList.of(records);
      });
    } catch (e) {
      print("Error generating range report: $e");
      reportTransactionsList = ObservableList();
    } finally {
      isLoadingReport = false;
    }
  }

  /// Deletes a financial transaction record.
  @action
  Future<void> deleteTransaction(int transactionId) async {
    try {
      await _deleteTransactionUseCase.call(params: transactionId);
      // The deletion will automatically update the allTransactionsList stream.
      print("Transaction $transactionId deleted.");
      await generateRangeReport();
    } catch (e) {
      print("Error deleting transaction: $e");
      throw e;
    }
  }
}
