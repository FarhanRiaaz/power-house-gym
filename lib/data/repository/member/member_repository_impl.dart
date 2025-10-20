import 'dart:typed_data';

import 'package:finger_print_flutter/core/enum.dart';
import 'package:finger_print_flutter/data/datasources/member_datasource.dart';
import 'package:finger_print_flutter/domain/repository/member/member_repository.dart';

import '../../../core/data/drift/drift_client.dart' show Member;

class MemberRepositoryImpl implements MemberRepository {
  final MemberDatasource _memberDataSource;

  MemberRepositoryImpl(this._memberDataSource);

  @override
  Future<void> delete(int memberId) async {
    // Delegates to the new delete method in Datasource
    return _memberDataSource.delete(memberId);
  }

  @override
  Future<Member> findMemberById(int id) {
    // Delegates to the new getById method in Datasource
    return _memberDataSource.getById(id).then((member) => member!);
  }

  @override
  Future<Member?> findMemberByFingerprint(Uint8List fingerprintTemplate) {
     return _memberDataSource.getByFingerprint(fingerprintTemplate);

  }

  @override
  Future<Member> insert(Member member) {
    // Delegates to the new insert method in Datasource
    return _memberDataSource.insert(member);
  }

  @override
  Future<void> update(Member member) {
    // Delegates to the new update method in Datasource
    return _memberDataSource.update(member);
  }

  @override
  Future<List<Member>> getMembers(Gender? scope) {
    return _memberDataSource.getAll(genderFilter: scope);
  }

  @override
  Stream<List<Member>> watchMembers(Gender? scope) {
    return _memberDataSource.watchAll(genderFilter: scope);
  }

  @override
  Stream<Member?> watchMemberById(int id) {
    return _memberDataSource.watchById(id);
  }
}
