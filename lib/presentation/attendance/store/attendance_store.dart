import 'package:finger_print_flutter/core/enum.dart';
import 'package:finger_print_flutter/data/service/report/export/export_data_service_impl.dart';
import 'package:finger_print_flutter/domain/usecases/export/import_export_usecase.dart';
import 'package:mobx/mobx.dart';

import '../../../domain/entities/models/attendance_record.dart';
import '../../../domain/usecases/attendance/log_attendance_usecase.dart';

part 'attendance_store.g.dart';

class AttendanceStore = _AttendanceStore with _$AttendanceStore;

abstract class _AttendanceStore with Store {
  // --- Dependencies (Use Cases) ---
 final GetAttendanceByMemberIdRecordUseCase _attendanceByMemberIdRecordUseCase;
 final GetAttendanceRecordUseCase _getAttendanceRecordUseCase;
  final LogAttendanceUseCase _logAttendanceUseCase;
  final WatchTodayAttendanceUseCase _watchTodayAttendanceUseCase;
  final ImportDataUseCase _importDataUseCase;
  final GetDailyAttendanceReportUseCase _getDailyReportUseCase;

  _AttendanceStore(
      this._attendanceByMemberIdRecordUseCase,
      this._getAttendanceRecordUseCase,
      this._logAttendanceUseCase,
      this._watchTodayAttendanceUseCase,
      this._getDailyReportUseCase,
      this._importDataUseCase
      ) {
    generateDailyReport();
  }

  // --- Store State Variables ---

  @observable
  Stream<List<AttendanceRecord>> todayRecordsStream = Stream.value(const []);

  @observable
  ObservableList<AttendanceRecord> todayAttendanceList = ObservableList();

  @observable
  ObservableList<AttendanceRecord> reportAttendanceList = ObservableList();

  @observable
  ObservableList<AttendanceRecord> singleAttendanceList = ObservableList();

  @observable
  DateTime reportSelectedDate = DateTime.now();

  @observable
  Gender? currentReportFilter;

  @observable
  bool isLoadingReport = false;

  // Single record for immediate display after check-in
  @observable
  AttendanceRecord? lastCheckIn;

  // --- Computed Values ---

  @computed
  bool get isLoading => isLoadingReport;

  // --- Actions (Mutations and Data Fetching) ---

  /// Subscribes to the attendance records for the current day.
  @action
  void watchTodayAttendance({Gender? genderFilter}) {
    // Set a custom loading flag before starting the stream process
    // This is for the *initial* load of today's attendance display
    isLoadingReport = true;

    _watchTodayAttendanceUseCase.call(params: genderFilter).then((stream) {
      todayRecordsStream = stream;

      todayRecordsStream.listen((list) {
        runInAction(() {
          todayAttendanceList = ObservableList.of(list);

          // isLoadingReport = false; // Loading finishes once the first list arrives
        });
      });
    }).catchError((error) {
      runInAction(() {
        isLoadingReport = false;
      });
    });
  }

  /// Logs a check-in for the member matching the given ID.
  @action
  Future<void> logCheckIn(AttendanceRecord memberId) async {
    try {
      final record = await _logAttendanceUseCase.call(params: memberId);
      runInAction(() {
        lastCheckIn = record;
      });
      print("Member $memberId successfully checked in at ${record.checkInTime}");
      await generateDailyReport();
    } catch (e) {
      print("Error logging attendance: $e");
      lastCheckIn = null;
      throw e;
    }
  }

  @action
  Future<int> importDataToDatabase(List<List<String>> csvData) async {
   return await _importDataUseCase.call(params: ImportDataParams(csvData: csvData,type: CsvImportType.attendance));
  }

  /// Fetches a one-time report of attendance for the currently selected date and filter.
  @action
  Future<void> generateDailyReport() async {
    isLoadingReport = true;
    try {
      final params = AttendanceReportParams(
        date: reportSelectedDate,
        genderFilter: currentReportFilter,
      );

      final records = await _getDailyReportUseCase.call(params: params);

      runInAction(() {
        reportAttendanceList = ObservableList.of(records);
      });
    } catch (e) {
      print("Error generating daily report: $e");
      reportAttendanceList = ObservableList();
    } finally {
      isLoadingReport = false;
    }
  }

  @action
  Future<void> getSingleAttendanceList(int memberId) async {
    isLoadingReport = true;
    try {
      final records = await _getAttendanceRecordUseCase.call(params: memberId);
      runInAction(() {
        singleAttendanceList = ObservableList.of(records);
      });

    } catch (e) {
      print("Error generating daily report: $e");
      singleAttendanceList = ObservableList();
    } finally {
      isLoadingReport = false;
    }
  }

@action
  Future<void> getAttendanceDetail(int memberId) async {
    isLoadingReport = true;
    try {
      final records = await _attendanceByMemberIdRecordUseCase.call(params: memberId);

      runInAction(() {
        reportAttendanceList = ObservableList.of(records);
      });

    } catch (e) {
      print("Error generating daily report: $e");
      reportAttendanceList = ObservableList();
    } finally {
      isLoadingReport = false;
    }
  }
}
