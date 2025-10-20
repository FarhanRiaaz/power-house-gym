import 'package:finger_print_flutter/main.dart';
import 'package:flutter/material.dart';

class EnrollmentFormScreen extends StatefulWidget {
  final String fmdBase64;
  final Function(Member) onSave;

  const EnrollmentFormScreen({super.key, required this.fmdBase64, required this.onSave});

  @override
  _EnrollmentFormScreenState createState() => _EnrollmentFormScreenState();
}

class _EnrollmentFormScreenState extends State<EnrollmentFormScreen> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  DateTime feeDue = DateTime.now().add(Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Member Details")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: "Member ID"),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Save Member"),
              onPressed: () {
                final member = Member(
                  memberId: _idController.text.trim(),
                  name: _nameController.text.trim(),
                  feeDue: feeDue,
                  attendance: [],
                  fmdBase64: widget.fmdBase64,
                );
                widget.onSave(member);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
