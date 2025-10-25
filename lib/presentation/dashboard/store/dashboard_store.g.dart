// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DashboardStore on _DashboardStore, Store {
  Computed<DashboardData?>? _$dataComputed;

  @override
  DashboardData? get data => (_$dataComputed ??= Computed<DashboardData?>(
    () => super.data,
    name: '_DashboardStore.data',
  )).value;
  Computed<DateRangeParams?>? _$currentFilterRangeComputed;

  @override
  DateRangeParams? get currentFilterRange =>
      (_$currentFilterRangeComputed ??= Computed<DateRangeParams?>(
        () => super.currentFilterRange,
        name: '_DashboardStore.currentFilterRange',
      )).value;

  late final _$isLoadingAtom = Atom(
    name: '_DashboardStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$_dataAtom = Atom(
    name: '_DashboardStore._data',
    context: context,
  );

  @override
  DashboardData? get _data {
    _$_dataAtom.reportRead();
    return super._data;
  }

  @override
  set _data(DashboardData? value) {
    _$_dataAtom.reportWrite(value, super._data, () {
      super._data = value;
    });
  }

  late final _$_currentFilterRangeAtom = Atom(
    name: '_DashboardStore._currentFilterRange',
    context: context,
  );

  @override
  DateRangeParams? get _currentFilterRange {
    _$_currentFilterRangeAtom.reportRead();
    return super._currentFilterRange;
  }

  @override
  set _currentFilterRange(DateRangeParams? value) {
    _$_currentFilterRangeAtom.reportWrite(value, super._currentFilterRange, () {
      super._currentFilterRange = value;
    });
  }

  late final _$memberListAtom = Atom(
    name: '_DashboardStore.memberList',
    context: context,
  );

  @override
  ObservableList<Member> get memberList {
    _$memberListAtom.reportRead();
    return super.memberList;
  }

  @override
  set memberList(ObservableList<Member> value) {
    _$memberListAtom.reportWrite(value, super.memberList, () {
      super.memberList = value;
    });
  }

  late final _$singleAttendanceListAtom = Atom(
    name: '_DashboardStore.singleAttendanceList',
    context: context,
  );

  @override
  ObservableList<AttendanceRecord> get singleAttendanceList {
    _$singleAttendanceListAtom.reportRead();
    return super.singleAttendanceList;
  }

  @override
  set singleAttendanceList(ObservableList<AttendanceRecord> value) {
    _$singleAttendanceListAtom.reportWrite(
      value,
      super.singleAttendanceList,
      () {
        super.singleAttendanceList = value;
      },
    );
  }

  late final _$allTransactionsListAtom = Atom(
    name: '_DashboardStore.allTransactionsList',
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

  late final _$allExpensesListAtom = Atom(
    name: '_DashboardStore.allExpensesList',
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

  late final _$fetchDashboardDataAsyncAction = AsyncAction(
    '_DashboardStore.fetchDashboardData',
    context: context,
  );

  @override
  Future<void> fetchDashboardData({DateRangeParams? range}) {
    return _$fetchDashboardDataAsyncAction.run(
      () => super.fetchDashboardData(range: range),
    );
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
memberList: ${memberList},
singleAttendanceList: ${singleAttendanceList},
allTransactionsList: ${allTransactionsList},
allExpensesList: ${allExpensesList},
data: ${data},
currentFilterRange: ${currentFilterRange}
    ''';
  }
}
