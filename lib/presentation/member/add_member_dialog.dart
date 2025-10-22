import 'package:finger_print_flutter/presentation/components/app_button.dart';
import 'package:finger_print_flutter/presentation/components/app_text_field.dart';
import 'package:finger_print_flutter/presentation/member/store/member_store.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/models/member.dart';
import '../../../core/enum.dart';
import '../../di/service_locator.dart';

class AddMemberDialog extends StatelessWidget {
  const AddMemberDialog({super.key});

  @override
  Widget build(BuildContext context) {
 
    final store =getIt<MemberStore>();
    final member = store.newMember ?? Member();

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add New Member', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            // AppTextField(
            //   label: 'Name',
            //   initialValue: member.name,
            //   onChanged: (val) => store.newMember = member.copyWith(name: val),
            // ),
            const SizedBox(height: 12),
            // AppTextField(
            //   label: 'Phone',
            //   initialValue: member.phone,
            //   onChanged: (val) => store.newMember = member.copyWith(phone: val),
            // ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Gender>(
              value: member.gender,
              items: Gender.values.map((g) {
                return DropdownMenuItem(value: g, child: Text(g.name));
              }).toList(),
              onChanged: (val) => store.newMember = member.copyWith(gender: val),
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            const SizedBox(height: 12),
            // AppTextField(
            //   label: 'Fingerprint Template',
            //   initialValue: member.fingerprintTemplate,
            //   onChanged: (val) => store.newMember = member.copyWith(fingerprintTemplate: val),
            // ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Register',
              icon: Icons.check,
              onPressed: () async {
                await store.registerMember();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
