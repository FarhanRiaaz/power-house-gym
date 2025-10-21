import 'package:drift/drift.dart';
import 'package:finger_print_flutter/core/enum.dart' show Gender;

class Members extends Table {
  // Primary Key (Manual ID generation in the app logic or UUID)
    IntColumn get memberId => integer().autoIncrement()();


  TextColumn get name => text().withLength(min: 1, max: 100)();

  TextColumn get phoneNumber => text().withLength(min: 1, max: 15)();

  TextColumn get fatherName => text().withLength(min: 1, max: 100)();

  // Stored as a string ('male' or 'female') for the Gender enum
  TextColumn get gender => textEnum<Gender>()();

  TextColumn get membershipType => text().withLength(min: 1, max: 50)();

  DateTimeColumn get registrationDate => dateTime()();

  DateTimeColumn get lastFeePaymentDate => dateTime()();

  // Biometric data (Uint8List in Dart, stored as BLOB in SQLite)
  TextColumn get fingerprintTemplate => text().withLength(min: 1, max: 6000)();

  TextColumn get notes => text().nullable()();
}
