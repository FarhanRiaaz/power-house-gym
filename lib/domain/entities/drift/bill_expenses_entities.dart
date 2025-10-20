import 'package:drift/drift.dart';

class BillExpenses extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 'Rent', 'Utility', 'Salary'
  TextColumn get category => text().withLength(min: 1, max: 50)();

  RealColumn get amount => real()();

  DateTimeColumn get date => dateTime()();

  TextColumn get description => text().withLength(min: 1, max: 255)();

  @override
  Set<Column> get primaryKey => {id};
}