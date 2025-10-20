import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:finger_print_flutter/core/db_constants.dart';
import 'package:finger_print_flutter/domain/entities/drift/attendance_record_entities.dart';
import 'package:finger_print_flutter/domain/entities/drift/bill_expenses_entities.dart';
import 'package:finger_print_flutter/domain/entities/drift/financial_transaction_entities.dart';
import 'package:finger_print_flutter/domain/entities/drift/members_entities.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import '../../enum.dart';

part 'drift_client.g.dart';


@DriftDatabase(tables: [Members,BillExpenses,FinancialTransactions,AttendanceRecords])
class DriftClient extends _$DriftClient {
  DriftClient() : super(_configureDatabase());
  @override
  int get schemaVersion => 1;

}
LazyDatabase _configureDatabase() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, DBConstants.dbName));

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sand boxing.
    final cacheBase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cacheBase;

    return NativeDatabase.createInBackground(file);
  });
}

