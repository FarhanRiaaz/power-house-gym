import 'package:drift/drift.dart';
import 'package:finger_print_flutter/core/list_to_csv_converter.dart';

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
            memberId: record.memberId ?? 0,
            checkInTime: record.checkInTime ?? DateTime.now(),
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

  Future<List<AttendanceRecord>> getByMember(int memberId) async {
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

  Future<int> insertBatchFromCsv(List<List<String>> csvData) async {
    final attendanceToInsert = <AttendanceRecord>[];
    int successCount = 0;

    // 1. Convert CSV rows to Member objects (Validation and Mapping)
    for (final row in csvData) {
      try {
        final member = AttendanceRecord.fromCsvRow(row);
        attendanceToInsert.add(member);
      } on FormatException catch (e) {
        // Log the error for the specific row and skip it.
        print('Skipping row due to format error: ${e.message} in row: $row');
      } catch (e) {
        print('An unexpected error occurred during parsing: $e');
      }
    }

    if (attendanceToInsert.isEmpty) {
      print('No valid members found to insert.');
      return 0;
    }

    // 2. Insert objects in a single, efficient database batch transaction
    try {
      await _driftClient.batch((batch) async {
        for (final member in attendanceToInsert) {
          // IMPORTANT: Convert the Member model back into a Drift Companion
          // (or map/entity) format before inserting.
          // This mock uses a simplified insert call for demonstration.
          await _driftClient
              .into(_driftClient.attendanceRecords)
              .insertReturning(
                Attendancez.AttendanceRecordsCompanion.insert(
                  memberId: member.memberId ?? 0,
                  checkInTime: member.checkInTime ?? DateTime.now(),
                ),
              );
          successCount++;
        }
      });
      print('Batch insertion complete. $successCount attendance processed.');
      return successCount;
    } catch (e) {
      print('Database Batch Error: Failed to insert attendance: $e');
      return 0; // Return 0 or re-throw based on required error handling
    }
  }

  /// Retrieves all members and generates a complete CSV string for export.
  ///
  /// Returns a Future<String> containing the CSV data.
  Future<String> exportToCsv() async {
    // 1. Retrieve data from the database
    print('Fetching all members from database...');
    final List<AttendanceRecord> members = await getAll();
    if (members.isEmpty) {
      print('No members found to export.');
      // Return a CSV with only the header
      return const SimpleCsvConverter().convert([
        AttendanceRecord().toCsvHeader(),
      ]);
    }

    // 2. Prepare all data rows
    final List<List<dynamic>> csvData = [];

    // Add the header row first
    //csvData.add(members.first.toCsvHeader());

    // Add all member data rows
    for (final member in members) {
      csvData.add(member.toCsvRow());
    }
    // 3. Convert the list of lists into a single CSV string
    const converter = SimpleCsvConverter(
      // Using a comma separator is standard for CSV, but you can change it
      fieldDelimiter: ',',
      textDelimiter:
          '"', // Use quotes to encapsulate strings that contain commas
    );
    //final csvString =
    return converter.convert(csvData);
    // print('CSV string generated successfully.');
    // return csvString;
  }
}
