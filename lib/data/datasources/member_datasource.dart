import 'dart:typed_data';
import 'package:drift/drift.dart';
import 'package:finger_print_flutter/core/data/drift/drift_client.dart';
import 'package:finger_print_flutter/core/enum.dart';

class MemberDatasource {
  final DriftClient _driftClient;

  MemberDatasource(this._driftClient);

  Member mapEntityToModel(Member entity) {
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
      MembersCompanion.insert(
        memberId: Value(member.memberId),
        name: member.name,
        phoneNumber: member.phoneNumber,
        fatherName: member.fatherName,
        gender: member.gender,
        membershipType: member.membershipType,
        registrationDate: member.registrationDate,
        lastFeePaymentDate: member.lastFeePaymentDate,
        fingerprintTemplate: Value(member.fingerprintTemplate),
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

  Future<Member?> getByFingerprint(Uint8List template) async {
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
          ..where((m) => m.memberId.equals(member.memberId)))
        .write(MembersCompanion(
      name: Value(member.name),
      phoneNumber: Value(member.phoneNumber),
      fatherName: Value(member.fatherName),
      membershipType: Value(member.membershipType),
      lastFeePaymentDate: Value(member.lastFeePaymentDate),
      fingerprintTemplate: Value(member.fingerprintTemplate),
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
}
