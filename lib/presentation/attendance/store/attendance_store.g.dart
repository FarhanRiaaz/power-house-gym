// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AttendanceStore on _AttendanceStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??= Computed<bool>(
    () => super.isLoading,
    name: '_AttendanceStore.isLoading',
  )).value;

  late final _$todayRecordsStreamAtom = Atom(
    name: '_AttendanceStore.todayRecordsStream',
    context: context,
  );

  @override
  Stream<List<AttendanceRecord>> get todayRecordsStream {
    _$todayRecordsStreamAtom.reportRead();
    return super.todayRecordsStream;
  }

  @override
  set todayRecordsStream(Stream<List<AttendanceRecord>> value) {
    _$todayRecordsStreamAtom.reportWrite(value, super.todayRecordsStream, () {
      super.todayRecordsStream = value;
    });
  }

  late final _$todayAttendanceListAtom = Atom(
    name: '_AttendanceStore.todayAttendanceList',
    context: context,
  );

  @override
  ObservableList<AttendanceRecord> get todayAttendanceList {
    _$todayAttendanceListAtom.reportRead();
    return super.todayAttendanceList;
  }

  @override
  set todayAttendanceList(ObservableList<AttendanceRecord> value) {
    _$todayAttendanceListAtom.reportWrite(value, super.todayAttendanceList, () {
      super.todayAttendanceList = value;
    });
  }

  late final _$reportAttendanceListAtom = Atom(
    name: '_AttendanceStore.reportAttendanceList',
    context: context,
  );

  @override
  ObservableList<AttendanceRecord> get reportAttendanceList {
    _$reportAttendanceListAtom.reportRead();
    return super.reportAttendanceList;
  }

  @override
  set reportAttendanceList(ObservableList<AttendanceRecord> value) {
    _$reportAttendanceListAtom.reportWrite(
      value,
      super.reportAttendanceList,
      () {
        super.reportAttendanceList = value;
      },
    );
  }

  late final _$singleAttendanceListAtom = Atom(
    name: '_AttendanceStore.singleAttendanceList',
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

  late final _$reportSelectedDateAtom = Atom(
    name: '_AttendanceStore.reportSelectedDate',
    context: context,
  );

  @override
  DateTime get reportSelectedDate {
    _$reportSelectedDateAtom.reportRead();
    return super.reportSelectedDate;
  }

  @override
  set reportSelectedDate(DateTime value) {
    _$reportSelectedDateAtom.reportWrite(value, super.reportSelectedDate, () {
      super.reportSelectedDate = value;
    });
  }

  late final _$currentReportFilterAtom = Atom(
    name: '_AttendanceStore.currentReportFilter',
    context: context,
  );

  @override
  Gender? get currentReportFilter {
    _$currentReportFilterAtom.reportRead();
    return super.currentReportFilter;
  }

  @override
  set currentReportFilter(Gender? value) {
    _$currentReportFilterAtom.reportWrite(value, super.currentReportFilter, () {
      super.currentReportFilter = value;
    });
  }

  late final _$isLoadingReportAtom = Atom(
    name: '_AttendanceStore.isLoadingReport',
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

  late final _$lastCheckInAtom = Atom(
    name: '_AttendanceStore.lastCheckIn',
    context: context,
  );

  @override
  AttendanceRecord? get lastCheckIn {
    _$lastCheckInAtom.reportRead();
    return super.lastCheckIn;
  }

  @override
  set lastCheckIn(AttendanceRecord? value) {
    _$lastCheckInAtom.reportWrite(value, super.lastCheckIn, () {
      super.lastCheckIn = value;
    });
  }

  late final _$logCheckInAsyncAction = AsyncAction(
    '_AttendanceStore.logCheckIn',
    context: context,
  );

  @override
  Future<void> logCheckIn(AttendanceRecord memberId) {
    return _$logCheckInAsyncAction.run(() => super.logCheckIn(memberId));
  }

  late final _$importDataToDatabaseAsyncAction = AsyncAction(
    '_AttendanceStore.importDataToDatabase',
    context: context,
  );

  @override
  Future<int> importDataToDatabase(List<List<String>> csvData) {
    return _$importDataToDatabaseAsyncAction.run(
      () => super.importDataToDatabase(csvData),
    );
  }

  late final _$generateDailyReportAsyncAction = AsyncAction(
    '_AttendanceStore.generateDailyReport',
    context: context,
  );

  @override
  Future<void> generateDailyReport() {
    return _$generateDailyReportAsyncAction.run(
      () => super.generateDailyReport(),
    );
  }

  late final _$getSingleAttendanceListAsyncAction = AsyncAction(
    '_AttendanceStore.getSingleAttendanceList',
    context: context,
  );

  @override
  Future<void> getSingleAttendanceList(int memberId) {
    return _$getSingleAttendanceListAsyncAction.run(
      () => super.getSingleAttendanceList(memberId),
    );
  }

  late final _$getAttendanceDetailAsyncAction = AsyncAction(
    '_AttendanceStore.getAttendanceDetail',
    context: context,
  );

  @override
  Future<void> getAttendanceDetail(int memberId) {
    return _$getAttendanceDetailAsyncAction.run(
      () => super.getAttendanceDetail(memberId),
    );
  }

  late final _$_AttendanceStoreActionController = ActionController(
    name: '_AttendanceStore',
    context: context,
  );

  @override
  void watchTodayAttendance({Gender? genderFilter}) {
    final _$actionInfo = _$_AttendanceStoreActionController.startAction(
      name: '_AttendanceStore.watchTodayAttendance',
    );
    try {
      return super.watchTodayAttendance(genderFilter: genderFilter);
    } finally {
      _$_AttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
todayRecordsStream: ${todayRecordsStream},
todayAttendanceList: ${todayAttendanceList},
reportAttendanceList: ${reportAttendanceList},
singleAttendanceList: ${singleAttendanceList},
reportSelectedDate: ${reportSelectedDate},
currentReportFilter: ${currentReportFilter},
isLoadingReport: ${isLoadingReport},
lastCheckIn: ${lastCheckIn},
isLoading: ${isLoading}
    ''';
  }
}
