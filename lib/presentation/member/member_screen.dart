import 'package:finger_print_flutter/presentation/attendance/store/attendance_store.dart';
import 'package:finger_print_flutter/presentation/auth/store/auth_store.dart';
import 'package:finger_print_flutter/presentation/components/app_button.dart';
import 'package:finger_print_flutter/presentation/components/app_card.dart';
import 'package:finger_print_flutter/presentation/components/app_date_picker.dart';
import 'package:finger_print_flutter/presentation/components/app_dialog.dart';
import 'package:finger_print_flutter/presentation/components/app_empty_state.dart';
import 'package:finger_print_flutter/presentation/components/app_list_tile.dart';
import 'package:finger_print_flutter/presentation/components/app_section_header.dart';
import 'package:finger_print_flutter/presentation/components/app_status_bar.dart';
import 'package:finger_print_flutter/presentation/components/app_text_field.dart';
import 'package:finger_print_flutter/presentation/components/background_wrapper.dart';
import 'package:finger_print_flutter/presentation/expense/store/expense_store.dart';
import 'package:finger_print_flutter/presentation/financial/store/financial_store.dart';
import 'package:finger_print_flutter/presentation/member/store/member_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/enum.dart';
import '../../../domain/entities/models/member.dart';
import '../../core/style/app_colors.dart';
import '../../core/style/app_text_styles.dart';
import '../../di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



List<Member> initialMembers = [
  Member(
    memberId: 1001,
    name: 'Ahmed Khan',
    phoneNumber: '03001234567',
    fatherName: 'Irfan Khan',
    gender: Gender.male,
    membershipType: 'Gold 12 Months',
    registrationDate: DateTime(2023, 1, 15),
    lastFeePaymentDate: DateTime(2024, 10, 1),
    notes: 'Renewed in Oct. Target: Cardio.',
  ),
  Member(
    memberId: 1002,
    name: 'Fatima Ali',
    phoneNumber: '03337654321',
    fatherName: 'Javed Ali',
    gender: Gender.female,
    membershipType: 'Silver 6 Months',
    registrationDate: DateTime(2024, 3, 20),
    lastFeePaymentDate: DateTime(2024, 9, 20),
    notes: 'Fee due soon!',
  ),
  Member(
    memberId: 1003,
    name: 'Usman Sharif',
    phoneNumber: '03219876543',
    fatherName: 'Khalid Sharif',
    gender: Gender.male,
    membershipType: 'Platinum 3 Months',
    registrationDate: DateTime(2024, 8, 1),
    lastFeePaymentDate: DateTime(2024, 10, 1),
    notes: 'New joiner. Needs intro session.',
  ),
  Member(
    memberId: 1004,
    name: 'Zainab Qureshi',
    phoneNumber: '03451122334',
    fatherName: 'Tariq Qureshi',
    gender: Gender.female,
    membershipType: 'Bronze 1 Month',
    registrationDate: DateTime(2024, 10, 10),
    lastFeePaymentDate: DateTime(2024, 11, 10),
    notes: 'First month trial.',
  ),
];

// --- Manage Member Screen Widget ---

class ManageMemberScreen extends StatefulWidget {
  const ManageMemberScreen({super.key});

  @override
  State<ManageMemberScreen> createState() => _ManageMemberScreenState();
}

class _ManageMemberScreenState extends State<ManageMemberScreen> {
  List<Member> _members = initialMembers;
  Member? _selectedMember;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  static const double _wideScreenBreakpoint = 250;

  // --- State Management/Filtering Logic ---

  List<Member> get _filteredMembers {
    if (_searchQuery.isEmpty) {
      return _members;
    }
    final query = _searchQuery.toLowerCase();
    return _members.where((member) {
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
    setState(() {
      if (_members.any((m) => m.memberId == member.memberId)) {
        final index = _members.indexWhere((m) => m.memberId == member.memberId);
        _members[index] = member;
      } else {
        _members.add(member);
      }
      _selectedMember = member;
    });
  }

  void _removeMember(Member member) {
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Confirm Deletion',
        message: 'Are you sure you want to remove ${member.name}? This action cannot be undone.',
        type: AppDialogType.warning,
        actions: [
          AppButton(label: 'Cancel', onPressed: () => Navigator.of(ctx).pop(), variant: AppButtonVariant.secondary),
          AppButton(
            label: 'Remove',
            onPressed: () {
              setState(() {
                _members.removeWhere((m) => m.memberId == member.memberId);
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

  void _payFee(Member member) {
    setState(() {
     // member.payFee();
    });
    _showAppDialog(context, 'Payment Successful', 'Fee payment for ${member.name} has been processed.', AppDialogType.success);
  }

  void _printReceipt(Member member) {
    _showAppDialog(context, 'Receipt Generated', 'Printing receipt for ${member.name} (ID: ${member.memberId}).', AppDialogType.info);
  }

  void _showAppDialog(BuildContext context, String title, String content, AppDialogType type) {
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: title,
        message: content,
        type: type,
        actions: [
          AppButton(
            label: 'Close',
            onPressed: () => Navigator.of(ctx).pop(),
            variant: AppButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  // --- Widget Builders ---
  Widget _buildMemberListView(bool isWide) {
    final filteredList = _filteredMembers;
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
                Expanded( // Ensures the text field takes up most space
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
         SizedBox(height: 500,width: double.infinity,
         child:
          filteredList.isEmpty

          // 💡 AppEmptyState for empty list
              ? AppEmptyState(
            message: _searchQuery.isEmpty ? 'No members registered yet.' : 'No members found for "$_searchQuery".',
            icon: _searchQuery.isEmpty ? Icons.group_off : Icons.search_off,
            actionLabel: _searchQuery.isEmpty ? 'Enroll New Member' : null,
            onActionTap: _searchQuery.isEmpty ? () => _showMemberForm(null, isWide) : null,
          )
              :
          ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final member = filteredList[index];
              final isSelected = member.memberId == _selectedMember?.memberId;

              final isFeeDue = member.lastFeePaymentDate != null &&
                  DateTime.now().difference(member.lastFeePaymentDate!).inDays > 30;

              // 💡 AppListTile for each member
              return AppListTile(
                title: member.name!,
                subtitle: 'ID: ${member.memberId} | Type: ${member.membershipType}',
                leadingIcon: Icons.person,
                statusColor: isFeeDue ? AppColors.danger : AppColors.success,
                isSelected: isSelected,
                trailing: isFeeDue
                    ? const AppStatusBadge(
                  label: 'FEE DUE',
                  color: AppColors.danger,
                  filled: true,
                )
                    : null,
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
          ),
         )
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

    final isFeeDue = member.lastFeePaymentDate != null &&
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
              title: isFeeDue ? 'MEMBERSHIP PAYMENT REQUIRED' : 'Membership Status: Current',
              subtitle: 'Last Payment: $lastFeeDate',
              statusColor: isFeeDue ? AppColors.danger : AppColors.success,
              padding: const EdgeInsets.all(16),
              trailing: isFeeDue
                  ? const AppStatusBadge(label: 'DUE', color: AppColors.danger)
                  : const AppStatusBadge(label: 'PAID', color: AppColors.success),
            ),
            const SizedBox(height: 20),


            _buildDetailRow('Member ID', member.memberId.toString()),
            _buildDetailRow('Father Name', member.fatherName!),
            _buildDetailRow('Phone Number', member.phoneNumber!),
            _buildDetailRow('Gender', member.gender?.name ?? 'N/A'),
            _buildDetailRow('Membership Type', member.membershipType!),
            _buildDetailRow('Registered On', registrationDate),

            const SizedBox(height: 20),
            Text('Notes:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(member.notes ?? 'No notes available.', style: const TextStyle(fontSize: 14)),

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
                  onPressed: () => _payFee(member),
                  fullWidth: false,
                  variant: AppButtonVariant.primary,
                ),
                // 💡 AppButton for Print Receipt
                AppButton(
                  label: 'Print Receipt',
                  icon: Icons.print,
                  onPressed: () => _printReceipt(member),
                  fullWidth: false,
                  variant: AppButtonVariant.secondary,
                ),
              ],
            )
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
              style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textSecondary),
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
          AppButton(label: 'Close',
              fullWidth: false,
              onPressed: () => Navigator.of(ctx).pop(), variant: AppButtonVariant.secondary),
        ],
      ),
    );
  }

  void _showMemberForm(Member? member, bool isWide) {
    showDialog(
      context: context,
      builder: (ctx) => _MemberFormDialog(
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
                const AppSectionHeader(title: 'Manage Members'),
                const SizedBox(height: 20),
        
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width:MediaQuery.of(context).size.width * 0.4,
                  child: _buildMemberListView(true),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _selectedMember != null
                      ? _buildMemberDetailView(_selectedMember!)
                      : AppEmptyState(
                    message: 'Select a member to view details and actions.',
                    icon: Icons.contact_page,
                  ),
                ),
              ],
            )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Member Form Widget (Updated with AppTextField and AppDatePicker) ---


class _MemberFormDialog extends StatefulWidget {
  final Member? member;
  final ValueChanged<Member> onSave;

  const _MemberFormDialog({required this.onSave, this.member});

  @override
  State<_MemberFormDialog> createState() => _MemberFormDialogState();
}

class _MemberFormDialogState extends State<_MemberFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late Member _currentMember;
  late DateTime _tempRegistrationDate;

  // REQUIRED: Controllers for AppTextField
  late TextEditingController _nameController;
  late TextEditingController _fatherNameController;
  late TextEditingController _phoneController;
  late TextEditingController _membershipController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();

    // Initialize member data
    if (widget.member != null) {
      _currentMember = Member(
        memberId: widget.member!.memberId,
        name: widget.member!.name,
        phoneNumber: widget.member!.phoneNumber,
        fatherName: widget.member!.fatherName,
        gender: widget.member!.gender,
        membershipType: widget.member!.membershipType,
        registrationDate: widget.member!.registrationDate,
        lastFeePaymentDate: widget.member!.lastFeePaymentDate,
        fingerprintTemplate: widget.member!.fingerprintTemplate,
        notes: widget.member!.notes,
      );
    } else {
      _currentMember = Member(
        memberId: DateTime.now().millisecondsSinceEpoch % 10000,
        name: '',
        phoneNumber: '',
        fatherName: '',
        membershipType: '',
        registrationDate: DateTime.now(),
      );
    }

    _tempRegistrationDate = _currentMember.registrationDate ?? DateTime.now();

    // Initialize Controllers with existing data
    _nameController = TextEditingController(text: _currentMember.name);
    _fatherNameController = TextEditingController(text: _currentMember.fatherName);
    _phoneController = TextEditingController(text: _currentMember.phoneNumber);
    _membershipController = TextEditingController(text: _currentMember.membershipType);
    _notesController = TextEditingController(text: _currentMember.notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _phoneController.dispose();
    _membershipController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Pull data directly from controllers
      _currentMember.name = _nameController.text;
      _currentMember.fatherName = _fatherNameController.text;
      _currentMember.phoneNumber = _phoneController.text;
      _currentMember.membershipType = _membershipController.text;
      _currentMember.notes = _notesController.text;

      _currentMember.registrationDate = _tempRegistrationDate;

      widget.onSave(_currentMember);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.member == null ? 'Add New Member' : 'Edit Member: ${widget.member!.name}'),
      backgroundColor: AppColors.backgroundDark,
      content: SingleChildScrollView(
        child: SizedBox(
          width: 800,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // 💡 AppTextField for Name - Now passes required controller
                AppTextField(
                  label: 'Name *',
                  controller: _nameController,
                  validator: (value) => value!.isEmpty ? 'Name is required' : null,
                  prefixIcon: Icons.person,
                ),
                SizedBox(height: 14),
                // 💡 AppTextField for Father Name - Now passes required controller
                AppTextField(
                  label: 'Father Name *',
                  controller: _fatherNameController,
                  validator: (value) => value!.isEmpty ? 'Father Name is required' : null,
                  prefixIcon: Icons.family_restroom,
                ),
                
                SizedBox(height: 14),
                // 💡 AppTextField for Phone Number - Now passes required controller
                AppTextField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone,
                ),

                SizedBox(height: 14),
                // 💡 AppDatePicker for Registration Date
                AppDatePicker(
                  label: 'Registration Date',
                  initialDate: _tempRegistrationDate,
                  onDateSelected: (newDate) {
                    setState(() {
                      _tempRegistrationDate = newDate;
                    });
                  },
                ),

                SizedBox(height: 14),
                // Standard Flutter Dropdown for Gender
                DropdownButtonFormField<Gender>(
                  value: _currentMember.gender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: Gender.values.map((Gender gender) {
                    return DropdownMenuItem<Gender>(
                      value: gender,
                      
                      child: Text(gender.name.toUpperCase(),),
                    );
                  }).toList(),
                  onChanged: (Gender? newValue) {
                    setState(() {
                      _currentMember.gender = newValue;
                    });
                  },
                ),

                SizedBox(height: 16,),
                // 💡 AppTextField for Membership Type - Now passes required controller
                AppTextField(
                  label: 'Membership Type',
                  controller: _membershipController,
                  prefixIcon: Icons.fitness_center,
                ),
                // 💡 AppTextField for Notes - Now passes required controller
                
                SizedBox(height: 14),
                AppTextField(
                  label: 'Notes',
                  controller: _notesController,
                  maxLines: 3,
                  prefixIcon: Icons.note_alt,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        // 💡 AppButton for Cancel
        AppButton(
          label: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
          fullWidth: false,
          variant: AppButtonVariant.secondary,
        ),
        // 💡 AppButton for Save
        AppButton(
          label: widget.member == null ? 'Add Member' : 'Save Changes',
          onPressed: _saveForm,
          fullWidth: false,
          variant: AppButtonVariant.primary,
        ),
      ],
    );
  }
}
