import 'package:finger_print_flutter/core/enum.dart';
import 'package:finger_print_flutter/core/list_to_csv_converter.dart';
import 'package:finger_print_flutter/core/printing/print_service.dart';
import 'package:finger_print_flutter/core/style/app_text_styles.dart';
import 'package:finger_print_flutter/domain/entities/models/financial_transaction.dart';
import 'package:finger_print_flutter/presentation/components/app_button.dart';
import 'package:finger_print_flutter/presentation/components/app_card.dart';
import 'package:finger_print_flutter/presentation/components/app_dialog.dart';
import 'package:finger_print_flutter/presentation/components/app_empty_state.dart';
import 'package:finger_print_flutter/presentation/components/app_list_tile.dart';
import 'package:finger_print_flutter/presentation/components/app_section_header.dart';
import 'package:finger_print_flutter/presentation/components/app_status_bar.dart';
import 'package:finger_print_flutter/presentation/components/app_text_field.dart';
import 'package:finger_print_flutter/presentation/components/background_wrapper.dart';
import 'package:finger_print_flutter/presentation/financial/store/financial_store.dart';
import 'package:finger_print_flutter/presentation/member/add_member_dialog.dart';
import 'package:finger_print_flutter/presentation/member/store/member_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../domain/entities/models/member.dart';
import '../../core/style/app_colors.dart';
import '../../di/service_locator.dart';
import 'package:intl/intl.dart';

class ManageMemberScreen extends StatefulWidget {
  const ManageMemberScreen({super.key});

  @override
  State<ManageMemberScreen> createState() => _ManageMemberScreenState();
}

class _ManageMemberScreenState extends State<ManageMemberScreen> {
  @override
  void initState() {
    super.initState();
    memberStore.getAllMembers(Gender.male);
  }

  MemberStore memberStore = getIt<MemberStore>();
  ReceiptService receiptService = ReceiptService();
  FinancialStore financialStore = getIt<FinancialStore>();
  Member? _selectedMember;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  static const double _wideScreenBreakpoint = 250;

  // --- State Management/Filtering Logic ---

  List<Member> get _filteredMembers {
    if (_searchQuery.isEmpty) {
      return memberStore.memberList;
    }
    final query = _searchQuery.toLowerCase();
    return memberStore.memberList.where((member) {
      return member.name!.toLowerCase().contains(query) ||
          member.fatherName!.toLowerCase().contains(query);
    }).toList();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _addOrUpdateMember(Member member) {
    setState(() async {
      if (memberStore.memberList.any((m) => m.memberId == member.memberId)) {
        final index = memberStore.memberList.indexWhere(
          (m) => m.memberId == member.memberId,
        );
        memberStore.selectedMember!.copyWith(
          name: member.name,
          phoneNumber: member.phoneNumber,
          fatherName: member.fatherName,
          gender: member.gender,
          membershipType: member.membershipType,
          fingerprintTemplate: member.fingerprintTemplate,
          notes: member.notes,
        );
        await memberStore.updateMember();
      } else {
        memberStore.newMember!.copyWith(
          name: member.name,
          phoneNumber: member.phoneNumber,
          fatherName: member.fatherName,
          gender: member.gender,
          membershipType: member.membershipType,
          fingerprintTemplate: member.fingerprintTemplate,
          notes: member.notes,
        );
        await memberStore.registerMember();
      }
      _selectedMember = member;
    });
  }

  void _removeMember(Member member) {
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Confirm Deletion',
        message:
            'Are you sure you want to remove ${member.name}? This action cannot be undone.',
        type: AppDialogType.warning,
        actions: [
          AppButton(
            label: 'Cancel',
            onPressed: () => Navigator.of(ctx).pop(),
            variant: AppButtonVariant.secondary,
          ),
          AppButton(
            label: 'Remove',
            onPressed: () {
              setState(() {
                memberStore.memberList.removeWhere(
                  (m) => m.memberId == member.memberId,
                );
                if (_selectedMember?.memberId == member.memberId) {
                  _selectedMember = null;
                }
              });
              Navigator.of(ctx).pop();
            },
            variant: AppButtonVariant.danger,
          ),
        ],
      ),
    );
  }

  Future<void> _payFee(Member member) async {
    memberStore.selectedMember!.copyWith(
      name: member.name,
      phoneNumber: member.phoneNumber,
      fatherName: member.fatherName,
      gender: member.gender,
      membershipType: member.membershipType,
      fingerprintTemplate: member.fingerprintTemplate,
      notes: member.notes,
    );
    financialStore.newTransaction.copyWith(
      type: "Fee Payment",
      amount: member.membershipType!.contains("cardio") ? 2500.0 : 1000.0,
      transactionDate: DateTime.now(),
      relatedMemberId: member.memberId,
    );

    await processFeePayment(member);
  }

  /// Executes the fee payment process, updates the database, and shows a success dialog.
  Future<void> processFeePayment(Member member) async {
    if (member.memberId == null) {
      _showAppDialog(
        context,
        'Error',
        'Cannot process payment: Member ID is missing.',
        AppDialogType.error,
        member,
      );
      return;
    }

    try {
      // 1. Database/API Call: Execute the transaction record operation.
      // This is the line you provided:
      memberStore.selectedMember!.copyWith(lastFeePaymentDate: DateTime.now());
      await memberStore.updateMember();
      await financialStore.recordTransaction();
      // 2. UI Notification: Show the success dialog after the database call completes.
      // This is the line you provided:
      _showAppDialog(
        context,
        'Payment Successful',
        'Fee payment for ${member.name ?? 'a member'} has been processed.',
        AppDialogType.success,
        member,
      );
    } catch (e) {
      // Handle potential errors during the database transaction
      _showAppDialog(
        context,
        'Payment Failed',
        'An error occurred while processing the payment for ${member.name}. Error: $e',
        AppDialogType.error,
        member,
      );
    }
  }

  Future<void> _printReceipt(Member member) async {
    await receiptService.generateAndPrintReceipt(
      params: FinancialTransaction(
        type: member.membershipType,
        amount: member.membershipType!.contains('cardio') ? 2500.0 : 1000.0,
        transactionDate: DateTime.now(),
        description: "Membership renewal",
        relatedMemberId: member.memberId,
      ),
    );
  }

  void _showAppDialog(
    BuildContext context,
    String title,
    String content,
    AppDialogType type,
    Member member,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: title,
        message: content,
        type: type,
        actions: [
          AppButton(
            label: title == "Payment Successful" ? 'Print Receipt' : 'Close',
            onPressed: () async {
              if (title == "Payment Successful") {
                await receiptService.generateAndPrintReceipt(
                  params: FinancialTransaction(
                    type: member.membershipType,
                    amount: member.membershipType!.contains('cardio')
                        ? 2500.0
                        : 1000.0,
                    transactionDate: DateTime.now(),
                    description: "Membership renewal",
                    relatedMemberId: member.memberId,
                  ),
                );
                Navigator.of(ctx).pop();
              } else {
                Navigator.of(ctx).pop();
              }
            },
            isOutline: true,
            variant: title == "Payment Successful"
                ? AppButtonVariant.danger
                : AppButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  // --- Widget Builders ---
  Widget _buildMemberListView(bool isWide) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  // Ensures the text field takes up most space
                  child: AppTextField(
                    controller: _searchController,
                    onChanged: _updateSearchQuery,
                    label: 'Search Members',
                    hint: 'Name or Father Name',
                    prefixIcon: Icons.search,
                  ),
                ),
                const SizedBox(width: 12),
                AppButton(
                  label: 'Add Member',
                  icon: Icons.person_add,
                  onPressed: () => _showMemberForm(null, isWide),
                  variant: AppButtonVariant.primary,
                  fullWidth: false,
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          SizedBox(
            height: 500,
            width: double.infinity,
            child: Observer(
              builder: (context) {
                final filteredList = _filteredMembers;

                return filteredList.isEmpty
                    // 💡 AppEmptyState for empty list
                    ? AppEmptyState(
                        message: _searchQuery.isEmpty
                            ? 'No members registered yet.'
                            : 'No members found for "$_searchQuery".',
                        icon: _searchQuery.isEmpty
                            ? Icons.group_off
                            : Icons.search_off,
                        actionLabel: _searchQuery.isEmpty
                            ? 'Enroll New Member'
                            : null,
                        onActionTap: _searchQuery.isEmpty
                            ? () => _showMemberForm(null, isWide)
                            : null,
                      )
                    : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final member = filteredList[index];
                          final isSelected =
                              member.memberId == _selectedMember?.memberId;

                          final isFeeDue =
                              member.lastFeePaymentDate != null &&
                              DateTime.now()
                                      .difference(member.lastFeePaymentDate!)
                                      .inDays >
                                  30;

                          // 💡 AppListTile for each member
                          return AppListTile(
                            title: member.name!,
                            subtitle:
                                'ID: ${member.memberId} | Type: ${member.membershipType}',
                            leadingIcon: Icons.person,
                            statusColor: member.isFeeOverdue
                                ? AppColors.danger
                                : AppColors.success,
                            isSelected: isSelected,
                            trailing: member.isFeeOverdue
                                ? const AppStatusBadge(
                                    label: 'FEE DUE',
                                    color: AppColors.danger,
                                    filled: true,
                                  )
                                : const AppStatusBadge(
                                    label: 'Valid Membership',
                                    color: AppColors.success,
                                    filled: false,
                                  ),
                            onTap: () {
                              setState(() {
                                _selectedMember = member;
                              });
                              if (!isWide) {
                                _showMemberDetail(member);
                              }
                            },
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberDetailView(Member member) {
    final lastFeeDate = member.lastFeePaymentDate != null
        ? DateFormat('MMM dd, yyyy').format(member.lastFeePaymentDate!)
        : 'N/A';

    final registrationDate = member.registrationDate != null
        ? DateFormat('MMM dd, yyyy').format(member.registrationDate!)
        : 'N/A';

    final isFeeDue =
        member.lastFeePaymentDate != null &&
        DateTime.now().difference(member.lastFeePaymentDate!).inDays > 30;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💡 AppSectionHeader for title (adjusting for layout)
            AppSectionHeader(title: member.name!),

            // Actions (Edit/Delete)
            Row(
              children: [
                const Spacer(),
                AppButton(
                  label: 'Edit',
                  icon: Icons.edit,
                  onPressed: () => _showMemberForm(member, true),
                  variant: AppButtonVariant.secondary,
                  isOutline: true,
                  fullWidth: false,
                ),
                const SizedBox(width: 8),
                AppButton(
                  label: 'Delete',
                  icon: Icons.delete,
                  onPressed: () => _removeMember(member),
                  fullWidth: false,
                  variant: AppButtonVariant.danger,
                ),
              ],
            ),
            const Divider(height: 20),

            // 💡 AppCard for Fee Status
            AppCard(
              title: isFeeDue
                  ? 'MEMBERSHIP PAYMENT REQUIRED'
                  : 'Membership Status: Current',
              subtitle: 'Last Payment: $lastFeeDate',
              statusColor: isFeeDue ? AppColors.danger : AppColors.success,
              padding: const EdgeInsets.all(16),
              trailing: isFeeDue
                  ? const AppStatusBadge(label: 'DUE', color: AppColors.danger)
                  : const AppStatusBadge(
                      label: 'PAID',
                      color: AppColors.success,
                    ),
            ),
            const SizedBox(height: 20),

            _buildDetailRow('Member ID', member.memberId.toString()),
            _buildDetailRow('Father Name', member.fatherName!),
            _buildDetailRow('Phone Number', member.phoneNumber!),
            _buildDetailRow('Gender', member.gender?.name ?? 'N/A'),
            _buildDetailRow('Membership Type', member.membershipType!),
            _buildDetailRow('Registered On', registrationDate),

            const SizedBox(height: 20),
            Text(
              'Notes:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              member.notes ?? 'No notes available.',
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 30),

            // Pay Fee & Print Receipt Actions
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                // 💡 AppButton for Pay Fee
                AppButton(
                  label: 'PAY FEE NOW',
                  icon: Icons.payment,
                  onPressed: () async => await _payFee(member),
                  fullWidth: false,
                  variant: AppButtonVariant.primary,
                ),
                // 💡 AppButton for Print Receipt
                AppButton(
                  label: 'Print Receipt',
                  icon: Icons.print,
                  onPressed: () async => await _printReceipt(member),
                  fullWidth: false,
                  variant: AppButtonVariant.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showMemberDetail(Member member) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: AppSectionHeader(title: member.name!),
        content: SizedBox(
          width: 500, // Constrain dialog width
          child: _buildMemberDetailView(member),
        ),
        actions: [
          AppButton(
            label: 'Close',
            fullWidth: false,
            onPressed: () => Navigator.of(ctx).pop(),
            variant: AppButtonVariant.secondary,
          ),
        ],
      ),
    );
  }

  void _showMemberForm(Member? member, bool isWide) {
    showDialog(
      context: context,
      builder: (ctx) => MemberFormDialog(
        member: member,
        onSave: (m) {
          _addOrUpdateMember(m);
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSectionHeader(
                  title: 'Manage Members',
                  trailingWidget: Column(
                    children: [
                      Observer(
                        builder: (context) {
                          return memberStore.memberList.isNotEmpty
                              ? Text(
                                  "Total Members: ${memberStore.memberList.length}",
                                  style: AppTextStyles.subheading,
                                )
                              : SizedBox.shrink();
                        },
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            final filePath = await SimpleCsvConverter()
                                .pickExcelFile();

                            final csvData = await SimpleCsvConverter()
                                .readCsvFile(filePath);
                            await memberStore.importDataToDatabase(csvData);
                          } catch (e) {
                            print('Import failed: $e');
                            // Optionally show a dialog or snackbar here
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.import_contacts_outlined),
                            SizedBox(width: 16),
                            Text("Import Members"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: _buildMemberListView(true),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _selectedMember != null
                          ? _buildMemberDetailView(_selectedMember!)
                          : AppEmptyState(
                              message:
                                  'Select a member to view details and actions.',
                              icon: Icons.person_3_outlined,
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
