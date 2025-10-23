// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MemberStore on _MemberStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??= Computed<bool>(
    () => super.isLoading,
    name: '_MemberStore.isLoading',
  )).value;

  late final _$memberListAtom = Atom(
    name: '_MemberStore.memberList',
    context: context,
  );

  @override
  ObservableList<Member> get memberList {
    _$memberListAtom.reportRead();
    return super.memberList;
  }

  @override
  set memberList(ObservableList<Member> value) {
    _$memberListAtom.reportWrite(value, super.memberList, () {
      super.memberList = value;
    });
  }

  late final _$memberListStreamAtom = Atom(
    name: '_MemberStore.memberListStream',
    context: context,
  );

  @override
  Stream<List<Member>> get memberListStream {
    _$memberListStreamAtom.reportRead();
    return super.memberListStream;
  }

  @override
  set memberListStream(Stream<List<Member>> value) {
    _$memberListStreamAtom.reportWrite(value, super.memberListStream, () {
      super.memberListStream = value;
    });
  }

  late final _$newMemberAtom = Atom(
    name: '_MemberStore.newMember',
    context: context,
  );

  @override
  Member? get newMember {
    _$newMemberAtom.reportRead();
    return super.newMember;
  }

  @override
  set newMember(Member? value) {
    _$newMemberAtom.reportWrite(value, super.newMember, () {
      super.newMember = value;
    });
  }

  late final _$selectedMemberAtom = Atom(
    name: '_MemberStore.selectedMember',
    context: context,
  );

  @override
  Member? get selectedMember {
    _$selectedMemberAtom.reportRead();
    return super.selectedMember;
  }

  @override
  set selectedMember(Member? value) {
    _$selectedMemberAtom.reportWrite(value, super.selectedMember, () {
      super.selectedMember = value;
    });
  }

  late final _$currentGenderFilterAtom = Atom(
    name: '_MemberStore.currentGenderFilter',
    context: context,
  );

  @override
  Gender? get currentGenderFilter {
    _$currentGenderFilterAtom.reportRead();
    return super.currentGenderFilter;
  }

  @override
  set currentGenderFilter(Gender? value) {
    _$currentGenderFilterAtom.reportWrite(value, super.currentGenderFilter, () {
      super.currentGenderFilter = value;
    });
  }

  late final _$isSortedByNameAscendingAtom = Atom(
    name: '_MemberStore.isSortedByNameAscending',
    context: context,
  );

  @override
  bool get isSortedByNameAscending {
    _$isSortedByNameAscendingAtom.reportRead();
    return super.isSortedByNameAscending;
  }

  @override
  set isSortedByNameAscending(bool value) {
    _$isSortedByNameAscendingAtom.reportWrite(
      value,
      super.isSortedByNameAscending,
      () {
        super.isSortedByNameAscending = value;
      },
    );
  }

  late final _$fetchMembersFutureAtom = Atom(
    name: '_MemberStore.fetchMembersFuture',
    context: context,
  );

  @override
  ObservableFuture<List<Member>?> get fetchMembersFuture {
    _$fetchMembersFutureAtom.reportRead();
    return super.fetchMembersFuture;
  }

  @override
  set fetchMembersFuture(ObservableFuture<List<Member>?> value) {
    _$fetchMembersFutureAtom.reportWrite(value, super.fetchMembersFuture, () {
      super.fetchMembersFuture = value;
    });
  }

  late final _$isLoadingMembersAtom = Atom(
    name: '_MemberStore.isLoadingMembers',
    context: context,
  );

  @override
  bool get isLoadingMembers {
    _$isLoadingMembersAtom.reportRead();
    return super.isLoadingMembers;
  }

  @override
  set isLoadingMembers(bool value) {
    _$isLoadingMembersAtom.reportWrite(value, super.isLoadingMembers, () {
      super.isLoadingMembers = value;
    });
  }

  late final _$getAllMembersAsyncAction = AsyncAction(
    '_MemberStore.getAllMembers',
    context: context,
  );

  @override
  Future<void> getAllMembers(Gender gender) {
    return _$getAllMembersAsyncAction.run(() => super.getAllMembers(gender));
  }

  late final _$watchMembersAsyncAction = AsyncAction(
    '_MemberStore.watchMembers',
    context: context,
  );

  @override
  Future<void> watchMembers({Gender? genderFilter}) {
    return _$watchMembersAsyncAction.run(
      () => super.watchMembers(genderFilter: genderFilter),
    );
  }

  late final _$importDataToDatabaseAsyncAction = AsyncAction(
    '_MemberStore.importDataToDatabase',
    context: context,
  );

  @override
  Future<int> importDataToDatabase(List<List<String>> csvData) {
    return _$importDataToDatabaseAsyncAction.run(
      () => super.importDataToDatabase(csvData),
    );
  }

  late final _$findMemberByFingerprintAsyncAction = AsyncAction(
    '_MemberStore.findMemberByFingerprint',
    context: context,
  );

  @override
  Future<Member?> findMemberByFingerprint(String template) {
    return _$findMemberByFingerprintAsyncAction.run(
      () => super.findMemberByFingerprint(template),
    );
  }

  late final _$registerMemberAsyncAction = AsyncAction(
    '_MemberStore.registerMember',
    context: context,
  );

  @override
  Future<Member?> registerMember(Member? member) {
    return _$registerMemberAsyncAction.run(() => super.registerMember(member));
  }

  late final _$updateMemberAsyncAction = AsyncAction(
    '_MemberStore.updateMember',
    context: context,
  );

  @override
  Future<void> updateMember(Member? member) {
    return _$updateMemberAsyncAction.run(() => super.updateMember(member));
  }

  late final _$deleteMemberAsyncAction = AsyncAction(
    '_MemberStore.deleteMember',
    context: context,
  );

  @override
  Future<void> deleteMember(Member member) {
    return _$deleteMemberAsyncAction.run(() => super.deleteMember(member));
  }

  @override
  String toString() {
    return '''
memberList: ${memberList},
memberListStream: ${memberListStream},
newMember: ${newMember},
selectedMember: ${selectedMember},
currentGenderFilter: ${currentGenderFilter},
isSortedByNameAscending: ${isSortedByNameAscending},
fetchMembersFuture: ${fetchMembersFuture},
isLoadingMembers: ${isLoadingMembers},
isLoading: ${isLoading}
    ''';
  }
}
