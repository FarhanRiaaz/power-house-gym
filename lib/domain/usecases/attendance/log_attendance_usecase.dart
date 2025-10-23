import 'package:finger_print_flutter/core/base_usecase.dart';
import 'package:finger_print_flutter/core/enum.dart';
import 'package:finger_print_flutter/domain/repository/attendance/attendance_repository.dart';

import '../../entities/models/attendance_record.dart';

/// Logs a new attendance record (check-in) for a given member ID.
///
/// Type: AttendanceRecord (The inserted record)
/// Params: int (The ID of the member checking in)
class LogAttendanceUseCase extends UseCase<AttendanceRecord, AttendanceRecord> {
  final AttendanceRepository _attendanceRepository;

  LogAttendanceUseCase(this._attendanceRepository);

  @override
  Future<AttendanceRecord> call({required AttendanceRecord params}) {
    return _attendanceRepository.logCheckIn(params);
  }
}

class GetAttendanceRecordUseCase extends UseCase<List<AttendanceRecord>, int> {
  final AttendanceRepository _attendanceRepository;

  GetAttendanceRecordUseCase(this._attendanceRepository);

  @override
  Future<List<AttendanceRecord>> call({required int params}) {
    return _attendanceRepository.getAttendanceHistory(params);
  }
}

class AttendanceReportParams {
  final DateTime date;
  final Gender? genderFilter;

  AttendanceReportParams({required this.date, this.genderFilter});
}

/// Fetches a one-time list of attendance records for a specific date and filter.
///
/// Type: List<AttendanceRecord>
/// Params: AttendanceReportParams (Date and optional gender filter)
class GetDailyAttendanceReportUseCase
    extends UseCase<List<AttendanceRecord>, AttendanceReportParams> {
  final AttendanceRepository _attendanceRepository;

  GetDailyAttendanceReportUseCase(this._attendanceRepository);

  @override
  Future<List<AttendanceRecord>> call({
    required AttendanceReportParams params,
  }) {
    return _attendanceRepository.getDailyAttendanceReport(
      params.date,
      params.genderFilter,
    );
  }
}

/// Provides a real-time stream of attendance records for the current day.
///
/// Type: Stream<List<AttendanceRecord>>
/// Params: Gender? (Optional filter)
class WatchTodayAttendanceUseCase
    extends UseCase<Stream<List<AttendanceRecord>>, Gender?> {
  final AttendanceRepository _attendanceRepository;

  WatchTodayAttendanceUseCase(this._attendanceRepository);

  @override
  Future<Stream<List<AttendanceRecord>>> call({required Gender? params}) async {
    return _attendanceRepository.watchTodayAttendance(params);
  }
}
