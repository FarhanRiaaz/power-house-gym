import 'package:finger_print_flutter/core/data/drift/drift_client.dart';
import 'package:finger_print_flutter/data/datasources/attendance_datasource.dart';
import 'package:finger_print_flutter/domain/repository/attendance/attendance_repository.dart';

import '../../../core/enum.dart' show Gender;


class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRecordDatasource _attendanceDatasource;

  AttendanceRepositoryImpl(this._attendanceDatasource);

  @override
  Future<AttendanceRecord> logCheckIn(AttendanceRecord memberId) {
    return _attendanceDatasource.insert(memberId);
  }

  @override
  Future<List<AttendanceRecord>> getAttendanceHistory(String memberId) {
    return _attendanceDatasource.getByMember(memberId);
  }

  @override
  Future<List<AttendanceRecord>> getDailyAttendanceReport(
      DateTime date, Gender? scope) {
    return _attendanceDatasource.getDailyRecords(date, genderFilter: scope);
  }

  @override
  Stream<List<AttendanceRecord>> watchTodayAttendance(Gender? scope) {
    return _attendanceDatasource.watchTodayRecords(genderFilter: scope);
  }
}
