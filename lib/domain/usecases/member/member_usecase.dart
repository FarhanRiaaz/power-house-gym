import 'package:finger_print_flutter/core/base_usecase.dart';
import 'package:finger_print_flutter/data/service/report/export/export_data_service_impl.dart';
import 'package:finger_print_flutter/domain/entities/models/fmd_model.dart';
import 'package:finger_print_flutter/domain/usecases/export/import_export_usecase.dart';
import 'dart:typed_data';
import '../../../core/enum.dart';
import '../../entities/models/member.dart';
import '../../repository/member/member_repository.dart';

/// Fetches or watches a list of all members, optionally filtered by gender.
///
/// Type: Stream<List<Member>> (Reactive list)
/// Params: Gender? (Optional filter)
class GetAllMembersUseCase extends UseCase<List<Member>, Gender?> {
  final MemberRepository _memberRepository;

  GetAllMembersUseCase(this._memberRepository);

  @override
  Future<List<Member>> call({required Gender? params}) async {
    // The repository returns a Stream, making this use case reactive
    return _memberRepository.getMembers(params);
  }
}



/// Inserts a new member record into the database.
///
/// Type: Member (The inserted member entity with its generated ID)
/// Params: Member (The entity to insert)
class InsertMemberUseCase extends UseCase<Member, Member> {
  final MemberRepository _memberRepository;

  InsertMemberUseCase(this._memberRepository);

  @override
  Future<Member> call({required Member params}) {
    return _memberRepository.insert(params);
  }
}

/// Updates an existing member record.
///
/// Type: void
/// Params: Member (The entity with updated fields)
class UpdateMemberUseCase extends UseCase<void, Member> {
  final MemberRepository _memberRepository;

  UpdateMemberUseCase(this._memberRepository);

  @override
  Future<void> call({required Member params}) {
    return _memberRepository.update(params);
  }
}

/// Deletes a member record.
///
/// Type: void
/// Params: Member (The entity to delete)
class DeleteMemberUseCase extends UseCase<void, Member> {
  final MemberRepository _memberRepository;

  DeleteMemberUseCase(this._memberRepository);

  @override
  Future<void> call({required Member params}) {
    // We only need the ID to delete
    return _memberRepository.delete(params.memberId??0);
  }
}

/// Finds a single member by their unique ID.
///
/// Type: Member?
/// Params: int (The member ID)
class FindMemberByIdUseCase extends UseCase<Member?, int> {
  final MemberRepository _memberRepository;

  FindMemberByIdUseCase(this._memberRepository);

  @override
  Future<Member?> call({required int params}) {
    return _memberRepository.findMemberById(params);
  }
}

/// Finds a member for check-in using their biometric fingerprint template.
///
/// NOTE: The repository and data source need to handle converting the template
/// string from the sensor/UI into a Uint8List for database lookup.
///
/// Type: Member?
/// Params: String (The encoded fingerprint template string)
class GetAllStoredFMDS extends UseCase<List<FmdData>?, Gender> {
  final MemberRepository _memberRepository;

  GetAllStoredFMDS(this._memberRepository);

  @override
  Future<List<FmdData>> call({required Gender params}) {
    // IMPORTANT: The repository layer will be responsible for converting
    // this String representation of the template back to Uint8List for the DB lookup.
    return _memberRepository.getAllFmds(genderFilter: params);
  }
}


