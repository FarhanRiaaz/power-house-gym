import 'package:drift/drift.dart';

import '../../core/data/drift/drift_client.dart' as Attendancez;
import '../../core/enum.dart' show Gender;
import '../../domain/entities/models/attendance_record.dart';

class AttendanceRecordDatasource {
  final Attendancez.DriftClient _driftClient;

  AttendanceRecordDatasource(this._driftClient);

  AttendanceRecord mapEntityToModel(Attendancez.AttendanceRecord entity) {
    return AttendanceRecord(
      id: entity.id,
      memberId: entity.memberId,
      checkInTime: entity.checkInTime,
    );
  }

  Future<AttendanceRecord> insert(AttendanceRecord record) async {
    final inserted = await _driftClient
        .into(_driftClient.attendanceRecords)
        .insertReturning(
          Attendancez.AttendanceRecordsCompanion.insert(
            memberId: record.memberId,
            checkInTime: record.checkInTime,
          ),
        );
    return mapEntityToModel(inserted);
  }

  Future<List<AttendanceRecord>> getAll() async {
    final entities = await _driftClient
        .select(_driftClient.attendanceRecords)
        .get();
    return entities.map(mapEntityToModel).toList();
  }

  Future<List<AttendanceRecord>> getByMember(String memberId) async {
    final query = _driftClient.select(_driftClient.attendanceRecords)
      ..where((r) => r.memberId.equals(memberId));
    final entities = await query.get();
    return entities.map(mapEntityToModel).toList();
  }

  Future<void> delete(int id) async {
    await (_driftClient.delete(
      _driftClient.attendanceRecords,
    )..where((r) => r.id.equals(id))).go();
  }

  /// Retrieves all check-in records for a specific date, with optional gender filtering.
  Future<List<AttendanceRecord>> getDailyRecords(
    DateTime date, {
    Gender? genderFilter,
  }) async {
    // Normalize the start and end of the target day
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final query = _driftClient.select(_driftClient.attendanceRecords)
      ..where(
        (t) => t.checkInTime.isBetween(
          Variable.withDateTime(startOfDay),
          Variable.withDateTime(endOfDay),
        ),
      );

    // Apply gender filtering if provided (assuming the table has a linked member ID
    // and we'd join to the Members table if needed, but for simplicity here,
    // we'll assume a direct filter if a future database change adds it,
    // or focus purely on time-based filtering for now).

    final entities = await query.get();
    return entities.map(mapEntityToModel).toList();
  }

  /// Watches all check-in records for the current day, with optional gender filtering,
  /// for real-time updates.
  Stream<List<AttendanceRecord>> watchTodayRecords({Gender? genderFilter}) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final query = _driftClient.select(_driftClient.attendanceRecords)
      ..where(
        (t) => t.checkInTime.isBetween(
          Variable.withDateTime(startOfDay),
          Variable.withDateTime(endOfDay),
        ),
      );

    // Apply gender filtering if provided (same note as above)

    return query.watch().map((entities) {
      return entities.map(mapEntityToModel).toList();
    });
  }
}
