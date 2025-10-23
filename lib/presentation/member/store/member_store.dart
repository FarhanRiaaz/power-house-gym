import 'dart:typed_data' as typed_data;

import 'package:finger_print_flutter/core/enum.dart';
import 'package:finger_print_flutter/data/service/report/export/export_data_service_impl.dart';
import 'package:finger_print_flutter/domain/usecases/export/import_export_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/member/member_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../../../domain/entities/models/member.dart';

part 'member_store.g.dart';

class MemberStore = _MemberStore with _$MemberStore;

abstract class _MemberStore with Store {
  // --- Dependencies (Use Cases) ---
  final GetAllMembersUseCase _getAllMembersUseCase;
  final UpdateMemberUseCase _updateMemberUseCase;
  final InsertMemberUseCase _insertMemberUseCase;
  final DeleteMemberUseCase _deleteMemberUseCase;
  final FindMemberByIdUseCase _findMemberByIdUseCase;
  final FindMemberByFingerprintUseCase _findByFingerprintUseCase;
  final ImportDataUseCase _importDataUseCase;

  _MemberStore(
    this._getAllMembersUseCase,
    this._updateMemberUseCase,
    this._insertMemberUseCase,
    this._deleteMemberUseCase,
    this._findMemberByIdUseCase,
    this._findByFingerprintUseCase,
      this._importDataUseCase
  ) {
       print("Doing this hereXX");

   getAllMembers(Gender.male);
   print("Doing this here");
  }

  // --- Store State Variables ---

  // Observables for managing state of lists and single items
  @observable
  ObservableList<Member> memberList = ObservableList();

  @observable
  Stream<List<Member>> memberListStream = Stream.value(const []);

  @observable
  Member? newMember = Member(); // Used for registration forms

  @observable
  Member? selectedMember = Member(); // Used for editing or displaying details

  @observable
  Gender? currentGenderFilter; // Filter for UI lists

  @observable
  bool isSortedByNameAscending = true;

  // ObservableFuture for loading state management (following your template)
  static ObservableFuture<List<Member>?> emptyListResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<List<Member>?> fetchMembersFuture =
      ObservableFuture<List<Member>?>(emptyListResponse);

  @observable
  bool isLoadingMembers = false; // Custom loading flag for the stream

  // --- Computed Values ---

  @computed
  bool get isLoading =>
      isLoadingMembers || fetchMembersFuture.status == FutureStatus.pending;

  // --- Actions (Mutations and Data Fetching) ---

  /// Fetches or watches all members based on the current filter.
  /// We assume the UseCase returns a Stream for reactive updates.
  
  @action
  Future<void> getAllMembers(Gender gender) async {
    print("We have been called $gender");
    isLoadingMembers = true;
    try {
      final records = await _getAllMembersUseCase.call(params: gender);
    print("We have been called and size is  ${records.length}");

      runInAction(() {
        memberList = ObservableList.of(records);
      });

    print("We have been called and size isXX  ${memberList.length}");


    } catch (e) {
      print("Error generating daily report: $e");
      memberList = ObservableList();
    } finally {
      isLoadingMembers = false;
    }
  }

  @action
  Future<void> watchMembers({Gender? genderFilter}) async{
    currentGenderFilter = genderFilter;
  //
  //   // Set a custom loading flag before starting the stream process
  //   isLoadingMembers = true;
  //   print("We are here to get the members");
  // //   // The use case returns a Future<Stream<List<Member>>>
  //  await _getAllMembersUseCase
  //       .call(params: currentGenderFilter)
  //       .then((stream) {
  //         memberListStream = stream;
  //
  //         // We subscribe to the stream manually to populate the observable list
  //         // for easier UI consumption, and manage the loading state.
  //         memberListStream.listen((list) {
  //           runInAction(() {
  //
  //                 print("We are here to get the membersList ${list.length}");
  //
  //
  //             memberList = ObservableList.of(list);
  //             isLoadingMembers =
  //                 false; // Loading finishes once the first list arrives
  //           });
  //         });
  //       })
  //       .catchError((error) {
  //         runInAction(() {
  //           print("Error setting up member stream: $error");
  //           isLoadingMembers = false;
  //         });
  //         // Do not re-throw here, let the stream handle its own errors or recovery
  //       });
  }
  @action
  Future<int> importDataToDatabase(List<List<String>> csvData) async {
    return await _importDataUseCase.call(params: ImportDataParams(csvData: csvData,type: CsvImportType.member));
  }

  /// Looks up a member for attendance check-in.
  @action
  Future<Member?> findMemberByFingerprint(String template) async {
    try {
      final member = await _findByFingerprintUseCase.call(params: template);
      selectedMember = member;
      return member;
    } catch (e) {
      print("Fingerprint lookup failed: $e");
      selectedMember = null;
      return null;
    }
  }

  /// Inserts a new member into the database.
  @action
  Future<Member?> registerMember(Member? member) async {
    print("SomeHOw i am here ${member.toString()}  and ${member.toString()}");
    if (member == null || member!.fingerprintTemplate!.isEmpty) {
      print("Member data is incomplete.");
      return null;
    }

    try {
      // Set timestamps before inserting
      member = member!.copyWith(
        registrationDate: DateTime.now(),
        lastFeePaymentDate:
            DateTime.now(), // Assume first fee paid on registration
      );

      final insertedMember = await _insertMemberUseCase.call(
        params: member!,
      );

      // Update UI list and clear the form model
      newMember = Member(); // Clear form
      selectedMember = insertedMember;
      await getAllMembers(currentGenderFilter??Gender.male); // Refresh list
      return insertedMember;
    } catch (error) {
      print("Error registering member: $error");
      rethrow;
    }
  }

  /// Updates an existing member record.
  @action
  Future<void> updateMember(Member? member) async {
    if (member == null || member!.memberId == null) return;

    try {
      final memberToUpdate = member!.copyWith(notes: "Updated",lastFeePaymentDate: DateTime.now());

      await _updateMemberUseCase.call(params: memberToUpdate);

      // Refresh the list to reflect changes
      getAllMembers(currentGenderFilter??Gender.male);
      print("Member ${member!.memberId} updated.");
    } catch (error) {
      print("Error updating member: $error");
      rethrow;
    }
  }

  /// Deletes a member record.
  @action
  Future<void> deleteMember(Member member) async {
    try {
      await _deleteMemberUseCase.call(params: member);

      // Update the state
      memberList.removeWhere((m) => m.memberId == member.memberId);
      selectedMember = null;
    } catch (error) {
      if (kDebugMode) {
        print("Error deleting member: $error");
      }
      rethrow;
    }
  }
}
