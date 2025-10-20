import 'package:drift/drift.dart';
import 'package:finger_print_flutter/domain/entities/drift/members_entities.dart';

/// Table representing daily member check-ins.
class AttendanceRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Foreign Key reference to the Members table
  TextColumn get memberId => text().references(Members, #memberId)();

  DateTimeColumn get checkInTime => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
