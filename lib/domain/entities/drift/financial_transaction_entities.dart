import 'package:drift/drift.dart';
import 'package:finger_print_flutter/domain/entities/drift/members_entities.dart';

/// Table representing all financial transactions (payments, expenses, etc.).
class FinancialTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 'Fee Payment', 'Expense', 'Bill', etc.
  TextColumn get type => text().withLength(min: 1, max: 50)();

  // Using RealColumn for double/decimal values
  RealColumn get amount => real()();

  DateTimeColumn get transactionDate => dateTime()();

  TextColumn get description => text().withLength(min: 1, max: 255)();

  // Optional link back to the member if it's a fee payment
  IntColumn get relatedMemberId =>
      integer().references(Members, #memberId).nullable()();
}