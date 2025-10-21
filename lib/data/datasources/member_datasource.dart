import 'dart:typed_data';
import 'package:drift/drift.dart';
import 'package:finger_print_flutter/core/data/drift/drift_client.dart' as Memberz;
import 'package:finger_print_flutter/core/enum.dart';
import 'package:finger_print_flutter/core/list_to_csv_converter.dart';
import 'package:finger_print_flutter/domain/entities/models/fmd_model.dart';

import '../../domain/entities/models/member.dart' ;

class MemberDatasource {
  final Memberz.DriftClient _driftClient;

  MemberDatasource(this._driftClient);

  Member mapEntityToModel(Memberz.Member entity) {
    return Member(
      memberId: entity.memberId,
      name: entity.name,
      phoneNumber: entity.phoneNumber,
      fatherName: entity.fatherName,
      gender: Gender.values.firstWhere((g) => g.name == entity.gender),
      membershipType: entity.membershipType,
      registrationDate: entity.registrationDate,
      lastFeePaymentDate: entity.lastFeePaymentDate,
      fingerprintTemplate: entity.fingerprintTemplate,
      notes: entity.notes,
    );
  }

  Future<Member> insert(Member member) async {
    final inserted = await _driftClient.into(_driftClient.members).insertReturning(
      Memberz.MembersCompanion.insert(
        memberId: Value(member.memberId??0),
        name: member.name ??"",
        phoneNumber: member.phoneNumber??"",
        fatherName: member.fatherName??"",
        gender: member.gender??Gender.male,
        membershipType: member.membershipType??"",
        registrationDate: member.registrationDate??DateTime.now(),
        lastFeePaymentDate: member.lastFeePaymentDate??DateTime.now(),
        fingerprintTemplate: member.fingerprintTemplate ?? "",
        notes: Value(member.notes),
      ),
    );
    return mapEntityToModel(inserted);
  }

  Future<Member?> getById(int memberId) async {
    final entity = await (_driftClient.select(_driftClient.members)
          ..where((m) => m.memberId.equals(memberId)))
        .getSingleOrNull();
    return entity != null ? mapEntityToModel(entity) : null;
  }

  Future<Member?> getByFingerprint(String template) async {
    final entity = await (_driftClient.select(_driftClient.members)
          ..where((m) => m.fingerprintTemplate.equals(template)))
        .getSingleOrNull();
    return entity != null ? mapEntityToModel(entity) : null;
  }

  Future<List<Member>> getAll({Gender? genderFilter}) async {
    final query = _driftClient.select(_driftClient.members);
    if (genderFilter != null) {
      query.where((m) => m.gender.equals(genderFilter.name));
    }
    final entities = await query.get();
    return entities.map(mapEntityToModel).toList();
  }

  Future<void> update(Member member) async {
    await (_driftClient.update(_driftClient.members)
          ..where((m) => m.memberId.equals(member.memberId??0)))
        .write(Memberz.MembersCompanion(
      name: Value(member.name??""),
      phoneNumber: Value(member.phoneNumber??""),
      fatherName: Value(member.fatherName??""),
      membershipType: Value(member.membershipType??""),
      lastFeePaymentDate: Value(member.lastFeePaymentDate??DateTime.now()),
      fingerprintTemplate: Value(member.fingerprintTemplate ?? ""),
      notes: Value(member.notes),
    ));
  }

  // 1. Reactive stream for watching all members (with optional gender filter)
  Stream<List<Member>> watchAll({Gender? genderFilter}) {
    final query = _driftClient.select(_driftClient.members);
    if (genderFilter != null) {
      query.where((m) => m.gender.equals(genderFilter.name));
    }

    // Use .watch() to get a stream of query results
    return query.watch().map((entities) {
      return entities.map(mapEntityToModel).toList();
    });
  }

// 2. Reactive stream for watching a single member by ID
  Stream<Member?> watchById(int memberId) {
    return (_driftClient.select(_driftClient.members)
      ..where((m) => m.memberId.equals(memberId)))
        .watchSingleOrNull()
        .map((entity) => entity != null ? mapEntityToModel(entity) : null);
  }

  Future<void> delete(int memberId) async {
    await (_driftClient.delete(_driftClient.members)
          ..where((m) => m.memberId.equals(memberId)))
        .go();
  }

  Future<List<FmdData>> getAllFmds({Gender? genderFilter}) async {
    // Pass the filter down to the getAll function
    final allMembers = await getAll(genderFilter: genderFilter);

    // Map the full Member objects to the lean FmdData objects
    return allMembers.map((m) => FmdData(
        memberId: m.memberId.toString(),
        fmdBase64: m.fingerprintTemplate.toString()
    )).toList();
  }

  Future<int> insertBatchFromCsv(List<List<String>> csvData) async {
    final membersToInsert = <Member>[];
    int successCount = 0;

    // 1. Convert CSV rows to Member objects (Validation and Mapping)
    for (final row in csvData) {
      try {
        final member = Member.fromCsvRow(row);
        membersToInsert.add(member);
      } on FormatException catch (e) {
        // Log the error for the specific row and skip it.
        print('Skipping row due to format error: ${e.message} in row: $row');
      } catch (e) {
        print('An unexpected error occurred during parsing: $e');
      }
    }

    if (membersToInsert.isEmpty) {
      print('No valid members found to insert.');
      return 0;
    }

    // 2. Insert objects in a single, efficient database batch transaction
    try {
      await _driftClient.batch((batch) async {
        for (final member in membersToInsert) {
          // IMPORTANT: Convert the Member model back into a Drift Companion
          // (or map/entity) format before inserting.
          // This mock uses a simplified insert call for demonstration.
          await _driftClient.into(_driftClient.members).insertReturning(
            Memberz.MembersCompanion.insert(
              memberId: Value(member.memberId??0),
              name: member.name ??"",
              phoneNumber: member.phoneNumber??"",
              fatherName: member.fatherName??"",
              gender: member.gender??Gender.male,
              membershipType: member.membershipType??"",
              registrationDate: member.registrationDate??DateTime.now(),
              lastFeePaymentDate: member.lastFeePaymentDate??DateTime.now(),
              fingerprintTemplate: member.fingerprintTemplate ?? "",
              notes: Value(member.notes),
            ),
          );
          successCount++;
        }
      });
      print('Batch insertion complete. $successCount members processed.');
      return successCount;

    } catch (e) {
      print('Database Batch Error: Failed to insert members: $e');
      return 0; // Return 0 or re-throw based on required error handling
    }
  }

  /// Retrieves all members and generates a complete CSV string for export.
  ///
  /// Returns a Future<String> containing the CSV data.
  Future<String> exportToCsv() async {
    // 1. Retrieve data from the database
    print('Fetching all members from database...');
    final List<Member> members = await getAll();

    if (members.isEmpty) {
      print('No members found to export.');
      // Return a CSV with only the header
      return const SimpleCsvConverter().convert([Member().toCsvHeader()]);
    }

    // 2. Prepare all data rows
    final List<List<dynamic>> csvData = [];

    // Add the header row first
    csvData.add(members.first.toCsvHeader());

    // Add all member data rows
    for (final member in members) {
      csvData.add(member.toCsvRow());
    }

    // 3. Convert the list of lists into a single CSV string
    const converter = SimpleCsvConverter(
      // Using a comma separator is standard for CSV, but you can change it
      fieldDelimiter: ',',
      textDelimiter: '"', // Use quotes to encapsulate strings that contain commas
    );

    final csvString = converter.convert(csvData);

    print('CSV string generated successfully.');
    return csvString;
  }
}
