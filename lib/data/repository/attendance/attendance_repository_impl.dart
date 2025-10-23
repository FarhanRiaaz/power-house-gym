import 'package:finger_print_flutter/data/datasources/attendance_datasource.dart';
import 'package:finger_print_flutter/domain/repository/attendance/attendance_repository.dart';

import '../../../core/enum.dart' show Gender;
import '../../../domain/entities/models/attendance_record.dart';


class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRecordDatasource _attendanceDatasource;

  AttendanceRepositoryImpl(this._attendanceDatasource);

  @override
  Future<AttendanceRecord> logCheckIn(AttendanceRecord memberId) {
    return _attendanceDatasource.insert(memberId);
  }

  @override
  Future<List<AttendanceRecord>> getAttendanceHistory() {
    return _attendanceDatasource.getAll();
  }

  @override
  Future<List<AttendanceRecord>> getAttendanceById(int memberId) {
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

  /// Takes parsed CSV data and inserts it into the database using a batch operation.
  /// This is the single, powerful function you can call from your Import Use Case.
  @override
  Future<int> insertBatchFromCsv(List<List<String>> csvData) async {
    return await _attendanceDatasource.insertBatchFromCsv(csvData);
  }

  @override
  Future<String> exportToCsv() async {
    return await _attendanceDatasource.exportToCsv();
  }
}
