import 'dart:convert';
import 'dart:io';
import 'package:finger_print_flutter/enrollment_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(FingerprintApp());

class FingerprintApp extends StatelessWidget {
  const FingerprintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Fingerprint System',
      theme: ThemeData.dark(),
      home: FingerprintHome(),
    );
  }
}

class Member {
  final String memberId;
  final String name;
  final DateTime feeDue;
  final List<DateTime> attendance;
  final String fmdBase64;

  Member({
    required this.memberId,
    required this.name,
    required this.feeDue,
    required this.attendance,
    required this.fmdBase64,
  });

  Map<String, dynamic> toJson() => {
        "member_id": memberId,
        "name": name,
        "fmd_base64": fmdBase64,
      };

  static Member fromJson(Map<String, dynamic> json) => Member(
        memberId: json["member_id"],
        name: json["name"],
        feeDue: DateTime.now().add(Duration(days: 7)),
        attendance: [],
        fmdBase64: json["fmd_base64"],
      );

  @override
  String toString() {
    return 'Member(memberId: $memberId, name: $name, feeDue: $feeDue, attendance: ${attendance.length} entries, fmdBase64: ${fmdBase64.substring(0, 20)}...)';
  }
}

class FingerprintHome extends StatefulWidget {
  const FingerprintHome({super.key});

  @override
  _FingerprintHomeState createState() => _FingerprintHomeState();
}

class _FingerprintHomeState extends State<FingerprintHome> {
  String result = "Ready";
  Map<String, Member> members = {};
  bool scanningEnabled = false;
  bool isPopupVisible = false;

  final String jsonPath = 'C:\\Users\\farha\\finger_print_flutter\\assets\\members.json';
 // final String exePath = 'C:\\Users\\farha\\FingerprintApp\\bin\\Debug\\net9.0\\FingerprintApp.exe';

 final String exePath = 'C:\\Users\\farha\\finger_print_flutter\\assets\\FingerprintApp.exe';

  @override
  void initState() {
    super.initState();
    loadMembers();
  }

  void loadMembers() {
    final file = File(jsonPath);
    print("Members file exists: ${file.existsSync()}");

    if (!file.existsSync()) return;

    final jsonData = jsonDecode(file.readAsStringSync());
    for (var m in jsonData["members"]) {
      final member = Member.fromJson(m);
      print("Loaded member: ${member.toString()}");
      members[member.memberId] = member;
    }
  }

  Future<void> saveMembersToJson() async {
    final file = File(jsonPath);
    final jsonData = {
      "members": members.values.map((m) => m.toJson()).toList()
    };
    await file.writeAsString(jsonEncode(jsonData));
  }

  void toggleScanning() {
    setState(() {
      scanningEnabled = !scanningEnabled;
      result = scanningEnabled ? "Scanning started..." : "Scanning stopped.";
    });

    if (scanningEnabled) startScanningLoop();
  }

Future<void> startScanningLoop() async {
  while (mounted && scanningEnabled) {
    final result = await Process.run(
      exePath,
      ['match', jsonPath],
      workingDirectory: File(exePath).parent.path,
    );

    final output = result.stdout.toString().trim();
    final error = result.stderr.toString().trim();
    print("C# STDOUT:\n$output");
    if (error.isNotEmpty) print("C# STDERR:\n$error");

    if (output.isEmpty || output.contains("MATCH_FAILED_TIMEOUT")) {
      await Future.delayed(Duration(milliseconds: 400));
      continue; // No finger detected — skip popup
    }

    final lines = output.split('\n').map((line) => line.trim()).toList();
    final matchLine = lines.firstWhere(
      (line) => line.startsWith('MATCH:') || line == 'NO_MATCH_REGISTER',
      orElse: () => '',
    );

    if (matchLine.startsWith('MATCH:')) {
      final memberId = matchLine.split(':')[1].trim();
      final member = members[memberId];

      if (member == null) {
        showPopup("User not registered. Please enroll.");
      } else if (DateTime.now().isAfter(member.feeDue)) {
        showPopup("Your fee is overdue. Please pay.");
      } else {
        member.attendance.add(DateTime.now());
        await saveMembersToJson();
        showPopup("Welcome ${member.name}! Attendance marked.");
      }
    } else if (matchLine == 'NO_MATCH_REGISTER') {
      final fmdLine = lines.firstWhere(
        (line) => line.startsWith('FMD_BASE64:'),
        orElse: () => '',
      );

      if (fmdLine.isNotEmpty) {
        final fmdBase64 = fmdLine.split(':')[1].trim();
        showUnrecognizedFingerprintPopup(fmdBase64);
      } else {
        print("FMD_BASE64 line not found.");
      }
    }

    await Future.delayed(Duration(milliseconds: 400));
  }
}

void showUnrecognizedFingerprintPopup(String fmdBase64) {
  if (isPopupVisible) return;
  isPopupVisible = true;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Unrecognized Fingerprint"),
      content: Text("Fingerprint not recognized. Register this user?"),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
            isPopupVisible = false;
          },
        ),
        ElevatedButton(
          child: Text("Register"),
          onPressed: () {
            Navigator.of(context).pop();
            isPopupVisible = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EnrollmentFormScreen(
                  fmdBase64: fmdBase64,
                  onSave: addNewMember,
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}

  // 🔹 NEW: Add this method to save a new member
  void addNewMember(Member member) async {
    members[member.memberId] = member;
    await saveMembersToJson();
    showPopup("Enrollment successful for ${member.name}");
  }

  // 🔹 NEW: Updated enrollment flow
  Future<void> enrollUser() async {
    scanningEnabled = false;
    setState(() => result = "Capturing fingerprint...");

    final enrollResult = await Process.run(
      exePath,
      ['enroll'],
      workingDirectory: File(exePath).parent.path,
    );

    final output = enrollResult.stdout.toString().trim();
    print("Enrollment STDOUT:\n$output");




    final lines = output.split('\n');
    if (lines.contains("ENROLL_FAILED_EMPTY_FMD")) {
  showPopup("No fingerprint detected. Please try again.");
  return;
}

    final successLine = lines.firstWhere(
      (line) => line.trim() == "ENROLL_SUCCESS",
      orElse: () => "",
    );

    if (successLine.isEmpty) {
      showPopup("Enrollment failed.");
      return;
    }

    final fmdLine = lines.firstWhere((line) => line.startsWith("FMD_BASE64:"), orElse: () => "");
    if (fmdLine.isEmpty) {
      showPopup("No fingerprint data received.");
      return;
    }

    final fmdBase64 = fmdLine.split(":")[1].trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EnrollmentFormScreen(fmdBase64: fmdBase64, onSave: addNewMember),
      ),
    );
  }

  void showPopup(String message) {
    if (isPopupVisible) return;
    isPopupVisible = true;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Fingerprint Result"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
              isPopupVisible = false;
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gym Fingerprint System")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Status: $result", style: TextStyle(fontSize: 20)),
            SizedBox(height: 30),
            // 🔹 NEW: Replaces old enroll button
            ElevatedButton.icon(
              icon: Icon(Icons.fingerprint),
              label: Text("Enroll User"),
              onPressed: enrollUser,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(scanningEnabled ? Icons.pause : Icons.play_arrow),
              label: Text(scanningEnabled ? "Stop Scanning" : "Start Scanning"),
              onPressed: toggleScanning,
            ),
          ],
        ),
      ),
    );
  }
}