// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FinancialStore on _FinancialStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??= Computed<bool>(
    () => super.isLoading,
    name: '_FinancialStore.isLoading',
  )).value;
  Computed<double>? _$totalIncomeInReportComputed;

  @override
  double get totalIncomeInReport =>
      (_$totalIncomeInReportComputed ??= Computed<double>(
        () => super.totalIncomeInReport,
        name: '_FinancialStore.totalIncomeInReport',
      )).value;

  late final _$allTransactionsStreamAtom = Atom(
    name: '_FinancialStore.allTransactionsStream',
    context: context,
  );

  @override
  Stream<List<FinancialTransaction>> get allTransactionsStream {
    _$allTransactionsStreamAtom.reportRead();
    return super.allTransactionsStream;
  }

  @override
  set allTransactionsStream(Stream<List<FinancialTransaction>> value) {
    _$allTransactionsStreamAtom.reportWrite(
      value,
      super.allTransactionsStream,
      () {
        super.allTransactionsStream = value;
      },
    );
  }

  late final _$allTransactionsListAtom = Atom(
    name: '_FinancialStore.allTransactionsList',
    context: context,
  );

  @override
  ObservableList<FinancialTransaction> get allTransactionsList {
    _$allTransactionsListAtom.reportRead();
    return super.allTransactionsList;
  }

  @override
  set allTransactionsList(ObservableList<FinancialTransaction> value) {
    _$allTransactionsListAtom.reportWrite(value, super.allTransactionsList, () {
      super.allTransactionsList = value;
    });
  }

  late final _$reportTransactionsListAtom = Atom(
    name: '_FinancialStore.reportTransactionsList',
    context: context,
  );

  @override
  ObservableList<FinancialTransaction> get reportTransactionsList {
    _$reportTransactionsListAtom.reportRead();
    return super.reportTransactionsList;
  }

  @override
  set reportTransactionsList(ObservableList<FinancialTransaction> value) {
    _$reportTransactionsListAtom.reportWrite(
      value,
      super.reportTransactionsList,
      () {
        super.reportTransactionsList = value;
      },
    );
  }

  late final _$reportStartDateAtom = Atom(
    name: '_FinancialStore.reportStartDate',
    context: context,
  );

  @override
  DateTime get reportStartDate {
    _$reportStartDateAtom.reportRead();
    return super.reportStartDate;
  }

  @override
  set reportStartDate(DateTime value) {
    _$reportStartDateAtom.reportWrite(value, super.reportStartDate, () {
      super.reportStartDate = value;
    });
  }

  late final _$reportEndDateAtom = Atom(
    name: '_FinancialStore.reportEndDate',
    context: context,
  );

  @override
  DateTime get reportEndDate {
    _$reportEndDateAtom.reportRead();
    return super.reportEndDate;
  }

  @override
  set reportEndDate(DateTime value) {
    _$reportEndDateAtom.reportWrite(value, super.reportEndDate, () {
      super.reportEndDate = value;
    });
  }

  late final _$newTransactionAtom = Atom(
    name: '_FinancialStore.newTransaction',
    context: context,
  );

  @override
  FinancialTransaction get newTransaction {
    _$newTransactionAtom.reportRead();
    return super.newTransaction;
  }

  @override
  set newTransaction(FinancialTransaction value) {
    _$newTransactionAtom.reportWrite(value, super.newTransaction, () {
      super.newTransaction = value;
    });
  }

  late final _$isLoadingReportAtom = Atom(
    name: '_FinancialStore.isLoadingReport',
    context: context,
  );

  @override
  bool get isLoadingReport {
    _$isLoadingReportAtom.reportRead();
    return super.isLoadingReport;
  }

  @override
  set isLoadingReport(bool value) {
    _$isLoadingReportAtom.reportWrite(value, super.isLoadingReport, () {
      super.isLoadingReport = value;
    });
  }

  late final _$recordTransactionAsyncAction = AsyncAction(
    '_FinancialStore.recordTransaction',
    context: context,
  );

  @override
  Future<FinancialTransaction?> recordTransaction(
    FinancialTransaction newTransaction,
  ) {
    return _$recordTransactionAsyncAction.run(
      () => super.recordTransaction(newTransaction),
    );
  }

  late final _$importDataToDatabaseAsyncAction = AsyncAction(
    '_FinancialStore.importDataToDatabase',
    context: context,
  );

  @override
  Future<int> importDataToDatabase(List<List<String>> csvData) {
    return _$importDataToDatabaseAsyncAction.run(
      () => super.importDataToDatabase(csvData),
    );
  }

  late final _$generateRangeReportAsyncAction = AsyncAction(
    '_FinancialStore.generateRangeReport',
    context: context,
  );

  @override
  Future<void> generateRangeReport() {
    return _$generateRangeReportAsyncAction.run(
      () => super.generateRangeReport(),
    );
  }

  late final _$deleteTransactionAsyncAction = AsyncAction(
    '_FinancialStore.deleteTransaction',
    context: context,
  );

  @override
  Future<void> deleteTransaction(int transactionId) {
    return _$deleteTransactionAsyncAction.run(
      () => super.deleteTransaction(transactionId),
    );
  }

  late final _$_FinancialStoreActionController = ActionController(
    name: '_FinancialStore',
    context: context,
  );

  @override
  void watchAllTransactions() {
    final _$actionInfo = _$_FinancialStoreActionController.startAction(
      name: '_FinancialStore.watchAllTransactions',
    );
    try {
      return super.watchAllTransactions();
    } finally {
      _$_FinancialStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
allTransactionsStream: ${allTransactionsStream},
allTransactionsList: ${allTransactionsList},
reportTransactionsList: ${reportTransactionsList},
reportStartDate: ${reportStartDate},
reportEndDate: ${reportEndDate},
newTransaction: ${newTransaction},
isLoadingReport: ${isLoadingReport},
isLoading: ${isLoading},
totalIncomeInReport: ${totalIncomeInReport}
    ''';
  }
}
