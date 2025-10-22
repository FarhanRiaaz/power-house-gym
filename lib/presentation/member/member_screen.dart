import 'package:finger_print_flutter/presentation/attendance/store/attendance_store.dart';
import 'package:finger_print_flutter/presentation/auth/store/auth_store.dart';
import 'package:finger_print_flutter/presentation/components/app_button.dart';
import 'package:finger_print_flutter/presentation/components/app_section_header.dart';
import 'package:finger_print_flutter/presentation/components/background_wrapper.dart';
import 'package:finger_print_flutter/presentation/expense/store/expense_store.dart';
import 'package:finger_print_flutter/presentation/financial/store/financial_store.dart';
import 'package:finger_print_flutter/presentation/member/store/member_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/enum.dart';
import '../../../domain/entities/models/member.dart';
import '../../di/service_locator.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
   
      final authStore =getIt<AuthStore>();
    final memberStore =getIt<MemberStore>();
    final attendanceStore =getIt<AttendanceStore>();
    final financeStore =getIt<FinancialStore>();
    final expenseStore =getIt<ExpenseStore>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Role-based filter
    final role = authStore.currentUser?.role;
    Gender? genderFilter;
    if (role == UserRole.maleAdmin) genderFilter = Gender.male;
    if (role == UserRole.femaleAdmin) genderFilter = Gender.female;

    memberStore.watchMembers(genderFilter: genderFilter);
  }

  void _showAddMemberDialog() {
    // TODO: Implement your add member form
  }

  void _showEditMemberDialog(Member member) {
    memberStore.selectedMember = member;
    // TODO: Implement your edit member form
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundWrapper(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔸 Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppSectionHeader(title: 'Members'),
                  Row(
                    children: [
                      AppButton(
                        label: 'Add Member',
                        icon: Icons.person_add,
                        onPressed: _showAddMemberDialog,
                      ),
                      const SizedBox(width: 12),
                      // SizedBox(
                      //   width: 220,
                      //   child: AppTextField(
                      //     label: 'Search',
                      //     prefixIcon: Icons.search,
                      //     onChanged: memberStore.setSearchQuery,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 🔸 Member List
              // Expanded(
              //   child: Observer(
              //     builder: (_) {
              //       if (memberStore.isLoading) {
              //         return const Center(child: CircularProgressIndicator());
              //       }
              //       final members = memberStore.memberList.where((m) {
              //         final query = memberStore.searchQuery.toLowerCase();
              //         return m.name.toLowerCase().contains(query) ||
              //             m.phone.contains(query) ||
              //             m.memberId.contains(query);
              //       }).toList();

              //       if (members.isEmpty) {
              //         return const Center(child: Text('No members found.'));
              //       }

              //       return ListView.builder(
              //         itemCount: members.length,
              //         itemBuilder: (_, index) {
              //           final member = members[index];
              //           return AppListTile(
              //             title: member.name,
              //             subtitle: 'Phone: ${member.phone}',
              //             icon: Icons.person,
              //             trailing: AppStatusBadge(
              //               label: member.feePaid ? 'Paid' : 'Unpaid',
              //               color: member.feePaid ? Colors.green : Colors.red,
              //             ),
              //             onTap: () => _showEditMemberDialog(member),
              //           );
              //         },
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
