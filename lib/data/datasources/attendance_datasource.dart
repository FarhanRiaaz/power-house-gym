import 'package:finger_print_flutter/core/data/drift/drift_client.dart';

class AttendanceRecordDatasource {
  final DriftClient _driftClient;

  AttendanceRecordDatasource(this._driftClient);

  AttendanceRecord mapEntityToModel(AttendanceRecord entity) {
    return AttendanceRecord(
      id: entity.id,
      memberId: entity.memberId,
      checkInTime: entity.checkInTime,
    );
  }

  Future<AttendanceRecord> insert(AttendanceRecord record) async {
    final inserted = await _driftClient.into(_driftClient.attendanceRecords).insertReturning(
      AttendanceRecordsCompanion.insert(
        memberId: record.memberId,
        checkInTime: record.checkInTime,
      ),
    );
    return mapEntityToModel(inserted);
  }

  Future<List<AttendanceRecord>> getAll() async {
    final entities = await _driftClient.select(_driftClient.attendanceRecords).get();
    return entities.map(mapEntityToModel).toList();
  }

  Future<List<AttendanceRecord>> getByMember(String memberId) async {
    final query = _driftClient.select(_driftClient.attendanceRecords)
      ..where((r) => r.memberId.equals(memberId));
    final entities = await query.get();
    return entities.map(mapEntityToModel).toList();
  }

  Future<void> delete(int id) async {
    await (_driftClient.delete(_driftClient.attendanceRecords)..where((r) => r.id.equals(id))).go();
  }
}
