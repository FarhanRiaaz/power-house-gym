import 'dart:convert' show jsonEncode;

import 'package:finger_print_flutter/data/service/biometric/biometric_service.dart';
import 'package:finger_print_flutter/domain/repository/member/member_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

/// Concrete implementation using external process execution.
class BiometricServiceImpl implements BiometricService {
  final MemberRepository _memberRepository;
  final isScanning = Observable<bool>(false);

  // NOTE: In a real app, these would point to your EXE and shared JSON file.
  static const String _exePath = 'C:\\FingerprintApp.exe';
  static const String _jsonPath = 'C:\\fmd_data.json';
  BiometricServiceImpl(this._memberRepository);

  // BiometricServiceImpl(this.memberStore, this.attendanceStore, this.customWidgets) {
  //   // Start scanning loop immediately if required by a MobX state change
  //   reaction((_) => isScanning.value, (bool scanning) {
  //     if (scanning) {
  //       // Start the continuous scanning loop when the observable changes to true
  //       _startScanningLoop();
  //     }
  //   });
  // }

  /// MOCK of the real dart:io Process.run
  Future<String> _mockExecuteApp(String command, [String? filePath]) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate hardware/process time

    if (command == 'enroll') {
      // Simulate success with a new FMD
      return 'ENROLL_SUCCESS\nFMD_BASE64: Rk1SACAyMAABQAAz/v8AAAD8AUQAxQDFAQAAAFYwQJUA2IdkgHoA...';
    }

    if (command == 'match') {
      // 1. In the real app, we would read the file at [filePath]
      final allFmds = await _memberRepository.getAllFmds();
      final jsonData = jsonEncode({"members": allFmds.map((m) => m.toJson()).toList()});

      // 2. We mock a successful match to the second member (M-102)
      if (allFmds.isNotEmpty) {
        return 'MATCH: M-102\nMATCH_SUCCESS';
      }
      return 'NO_MATCH_REGISTER';
    }

    return 'UNKNOWN_COMMAND';
  }

  // MOCK of the real dart:io File.writeAsString
  Future<void> _mockWriteFile(String path, String contents) async {
    // In a real application, this writes the JSON to the disk.
    // Here, we just print the optimized payload.
    debugPrint('*** Optimised JSON Payload Sent to C# Path: $path ***');
    debugPrint(contents);
    await Future.delayed(const Duration(milliseconds: 50));
  }

  @override
  Future<String?> enrollUser() async {
    // Execute the C# app with the 'enroll' command.
    final output = await _mockExecuteApp('enroll');

    // Parse the output
    final lines = output.split('\n');
    if (lines.contains("ENROLL_FAILED_EMPTY_FMD") || !lines.contains("ENROLL_SUCCESS")) {
      return null;
    }

    final fmdLine = lines.firstWhere(
          (line) => line.startsWith("FMD_BASE64:"),
      orElse: () => "",
    );

    if (fmdLine.isEmpty) {
      return null;
    }

    final fmdBase64 = fmdLine.split(":")[1].trim();
    return fmdBase64;
  }

  @override
  Future<String?> verifyUser() async {
    // 1. Fetch all FMD data (lean model for efficiency)
    final allFmds = await _memberRepository.getAllFmds();

    // 2. Prepare JSON data for the C# app
    final jsonData = {
      "members": allFmds.map((m) => m.toJson()).toList(),
    };

    // 3. Write data to the shared JSON file (MOCK)
    await _mockWriteFile(_jsonPath, jsonEncode(jsonData));

    // 4. Execute the C# app with the 'match' command and the file path (MOCK)
    final output = await _mockExecuteApp('match', _jsonPath);

    // 5. Parse the output
    final lines = output.split('\n').map((line) => line.trim()).toList();
    final matchLine = lines.firstWhere(
          (line) => line.startsWith('MATCH:'),
      orElse: () => '',
    );

    if (matchLine.startsWith('MATCH:')) {
      return matchLine.split(':')[1].trim(); // Returns the memberId
    }

    return null; // No match
  }
}