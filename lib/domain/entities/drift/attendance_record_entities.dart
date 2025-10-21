import 'package:drift/drift.dart';
import 'package:finger_print_flutter/domain/entities/drift/members_entities.dart';

/// Table representing daily member check-ins.
class AttendanceRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Foreign Key reference to the Members table
  IntColumn get memberId => integer().references(Members, #memberId)();

  DateTimeColumn get checkInTime => dateTime()();
}
