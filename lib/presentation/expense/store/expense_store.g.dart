// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExpenseStore on _ExpenseStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??= Computed<bool>(
    () => super.isLoading,
    name: '_ExpenseStore.isLoading',
  )).value;
  Computed<double>? _$totalExpensesInReportComputed;

  @override
  double get totalExpensesInReport =>
      (_$totalExpensesInReportComputed ??= Computed<double>(
        () => super.totalExpensesInReport,
        name: '_ExpenseStore.totalExpensesInReport',
      )).value;

  late final _$allExpensesStreamAtom = Atom(
    name: '_ExpenseStore.allExpensesStream',
    context: context,
  );

  @override
  Stream<List<BillExpense>> get allExpensesStream {
    _$allExpensesStreamAtom.reportRead();
    return super.allExpensesStream;
  }

  @override
  set allExpensesStream(Stream<List<BillExpense>> value) {
    _$allExpensesStreamAtom.reportWrite(value, super.allExpensesStream, () {
      super.allExpensesStream = value;
    });
  }

  late final _$allExpensesListAtom = Atom(
    name: '_ExpenseStore.allExpensesList',
    context: context,
  );

  @override
  ObservableList<BillExpense> get allExpensesList {
    _$allExpensesListAtom.reportRead();
    return super.allExpensesList;
  }

  @override
  set allExpensesList(ObservableList<BillExpense> value) {
    _$allExpensesListAtom.reportWrite(value, super.allExpensesList, () {
      super.allExpensesList = value;
    });
  }

  late final _$reportExpensesListAtom = Atom(
    name: '_ExpenseStore.reportExpensesList',
    context: context,
  );

  @override
  ObservableList<BillExpense> get reportExpensesList {
    _$reportExpensesListAtom.reportRead();
    return super.reportExpensesList;
  }

  @override
  set reportExpensesList(ObservableList<BillExpense> value) {
    _$reportExpensesListAtom.reportWrite(value, super.reportExpensesList, () {
      super.reportExpensesList = value;
    });
  }

  late final _$reportStartDateAtom = Atom(
    name: '_ExpenseStore.reportStartDate',
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
    name: '_ExpenseStore.reportEndDate',
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

  late final _$newExpenseAtom = Atom(
    name: '_ExpenseStore.newExpense',
    context: context,
  );

  @override
  BillExpense get newExpense {
    _$newExpenseAtom.reportRead();
    return super.newExpense;
  }

  @override
  set newExpense(BillExpense value) {
    _$newExpenseAtom.reportWrite(value, super.newExpense, () {
      super.newExpense = value;
    });
  }

  late final _$isLoadingReportAtom = Atom(
    name: '_ExpenseStore.isLoadingReport',
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

  late final _$recordExpenseAsyncAction = AsyncAction(
    '_ExpenseStore.recordExpense',
    context: context,
  );

  @override
  Future<BillExpense?> recordExpense() {
    return _$recordExpenseAsyncAction.run(() => super.recordExpense());
  }

  late final _$generateRangeReportAsyncAction = AsyncAction(
    '_ExpenseStore.generateRangeReport',
    context: context,
  );

  @override
  Future<void> generateRangeReport() {
    return _$generateRangeReportAsyncAction.run(
      () => super.generateRangeReport(),
    );
  }

  late final _$deleteExpenseAsyncAction = AsyncAction(
    '_ExpenseStore.deleteExpense',
    context: context,
  );

  @override
  Future<void> deleteExpense(int billId) {
    return _$deleteExpenseAsyncAction.run(() => super.deleteExpense(billId));
  }

  late final _$_ExpenseStoreActionController = ActionController(
    name: '_ExpenseStore',
    context: context,
  );

  @override
  void watchAllExpenses() {
    final _$actionInfo = _$_ExpenseStoreActionController.startAction(
      name: '_ExpenseStore.watchAllExpenses',
    );
    try {
      return super.watchAllExpenses();
    } finally {
      _$_ExpenseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
allExpensesStream: ${allExpensesStream},
allExpensesList: ${allExpensesList},
reportExpensesList: ${reportExpensesList},
reportStartDate: ${reportStartDate},
reportEndDate: ${reportEndDate},
newExpense: ${newExpense},
isLoadingReport: ${isLoadingReport},
isLoading: ${isLoading},
totalExpensesInReport: ${totalExpensesInReport}
    ''';
  }
}
