import 'dart:typed_data';

import 'package:finger_print_flutter/core/enum.dart';

import '../../../core/data/drift/drift_client.dart' show Member;

abstract class MemberRepository {
  /// Retrieves a list of all members, filtered by gender scope.
  /// Used primarily for the admin dashboard lists.
  Future<List<Member>> getMembers(Gender? scope);

  /// Finds a member by their primary key ID.
  Future<Member> findMemberById(int id);

  /// Finds a member by their unique fingerprint template ID.
  Future<Member?> findMemberByFingerprint(Uint8List fingerprintTemplate);

  /// Creates a new member record.
  Future<Member> insert(Member member);

  /// Updates an existing member's details.
  Future<void> update(Member member);

  /// Deletes a member record.
  Future<void> delete(int memberId);

  /// Watches all members, filtered by gender, for real-time UI updates.
  Stream<List<Member>> watchMembers(Gender? scope);

  /// Watches a single member by their ID for real-time updates.
  Stream<Member?> watchMemberById(int id);
}
