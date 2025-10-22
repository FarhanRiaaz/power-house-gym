import 'package:finger_print_flutter/presentation/components/app_button.dart';
import 'package:finger_print_flutter/presentation/member/store/member_store.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/models/member.dart';
import '../../di/service_locator.dart';
import '../components/app_text_field.dart';

class EditMemberDialog extends StatelessWidget {
  final Member member;

  const EditMemberDialog({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final store =getIt<MemberStore>();
    store.selectedMember = member;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Edit Member', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            // AppTextField(
            //   label: 'Name',
            //   initialValue: member.name,
            //   onChanged: (val) => store.selectedMember = member.copyWith(name: val),
            // ),
            const SizedBox(height: 12),
            // AppTextField(
            //   label: 'Phone',
            //   initialValue: member.phone,
            //   onChanged: (val) => store.selectedMember = member.copyWith(phone: val),
            // ),
            const SizedBox(height: 12),
            // AppTextField(
            //   label: 'Notes',
            //   initialValue: member.notes,
            //   onChanged: (val) => store.selectedMember = member.copyWith(notes: val),
            // ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  label: 'Delete',
                  icon: Icons.delete,
                  onPressed: () async {
                    await store.deleteMember(member);
                    Navigator.pop(context);
                  },
                ),
                AppButton(
                  label: 'Update',
                  icon: Icons.save,
                  onPressed: () async {
                    await store.updateMember();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
