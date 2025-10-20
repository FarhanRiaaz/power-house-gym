import 'package:finger_print_flutter/core/enum.dart';

import '../../entities/models/attendance_record.dart';



/// Defines the contract for managing all attendance-related data and logic.
abstract class AttendanceRepository {
  /// Records a new check-in for a member.
  Future<AttendanceRecord> logCheckIn(AttendanceRecord memberId);

  /// Retrieves the complete attendance history for a single member.
  Future<List<AttendanceRecord>> getAttendanceHistory(String memberId);

  /// Gets a report of all check-ins for a specific date, optionally filtered by gender.
  Future<List<AttendanceRecord>> getDailyAttendanceReport(DateTime date, Gender? scope);

  /// Watches all attendance records for the day, filtered by gender scope,
  /// for real-time dashboard updates.
  Stream<List<AttendanceRecord>> watchTodayAttendance(Gender? scope);
}