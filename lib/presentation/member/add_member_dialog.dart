import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/presentation/components/app_button.dart';
import 'package:finger_print_flutter/presentation/components/app_date_picker.dart';
import 'package:finger_print_flutter/presentation/components/app_dialog.dart';
import 'package:finger_print_flutter/presentation/components/app_text_field.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/models/member.dart';
import '../../../core/enum.dart';


class MemberFormDialog extends StatefulWidget {
  final Member? member;
  final ValueChanged<Member> onSave;

  const MemberFormDialog({super.key, required this.onSave, this.member});

  @override
  State<MemberFormDialog> createState() => MemberFormDialogState();
}

class MemberFormDialogState extends State<MemberFormDialog> {
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
      _currentMember.fingerprintTemplate = "akjshdjahsbdd";
      _currentMember.lastFeePaymentDate = DateTime.now();
      _currentMember.registrationDate = _tempRegistrationDate;

      print("Current member $_currentMember");
      widget.onSave(_currentMember);
    }
  }

  void _showFingerprintDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Fingerprint Registration',
        // The message requested by the user
        message: 'Put your finger into the biometric device to capture.',
        type: AppDialogType.info,
        actions: [
          // Simulated registration completion (just closes the dialog)
          AppButton(
            label: 'Captured (OK)',
            onPressed: () => Navigator.of(ctx).pop(),
            variant: AppButtonVariant.primary,
            icon: Icons.check_circle,
          ),
        ],
      ),
    );
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
                const SizedBox(height: 14),
                // 💡 AppTextField for Father Name - Now passes required controller
                AppTextField(
                  label: 'Father Name *',
                  controller: _fatherNameController,
                  validator: (value) => value!.isEmpty ? 'Father Name is required' : null,
                  prefixIcon: Icons.family_restroom,
                ),

                const  SizedBox(height: 14),
                // 💡 AppTextField for Phone Number - Now passes required controller
                AppTextField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone,
                ),

                const  SizedBox(height: 14),

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

                const   SizedBox(height: 14),
                // Standard Flutter Dropdown for Gender
                DropdownButtonFormField<Gender>(
                  value: _currentMember.gender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: AppColors.backgroundDark,
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

                const    SizedBox(height: 16,),
                // 💡 AppTextField for Membership Type - Now passes required controller
                AppTextField(
                  label: 'Membership Type',
                  controller: _membershipController,
                  prefixIcon: Icons.fitness_center,
                ),
                // 💡 AppTextField for Notes - Now passes required controller

                const     SizedBox(height: 14),
                AppTextField(
                  label: 'Notes',
                  controller: _notesController,
                  maxLines: 3,
                  prefixIcon: Icons.note_alt,
                ),
                const SizedBox(height: 14),
                widget.member == null?   AppButton(
                  label: 'Register Fingerprint',
                  icon: Icons.fingerprint,
                  onPressed: _showFingerprintDialog,
                  variant: AppButtonVariant.secondary,
                  fullWidth: true, // Make it span the width of the dialog
                ):SizedBox.shrink(),

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
