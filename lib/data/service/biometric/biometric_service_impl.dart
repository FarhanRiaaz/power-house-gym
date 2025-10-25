import 'dart:convert' show jsonEncode;
import 'dart:io';

import 'package:finger_print_flutter/data/service/biometric/biometric_service.dart';
import 'package:finger_print_flutter/domain/entities/models/fmd_model.dart';
import 'package:finger_print_flutter/domain/entities/models/scan_status.dart';
import 'package:finger_print_flutter/presentation/attendance/store/attendance_store.dart';
import 'package:finger_print_flutter/presentation/member/store/member_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

import '../../../di/service_locator.dart';
import '../../../domain/entities/models/attendance_record.dart';

/// Concrete implementation using external process execution.
class BiometricServiceImpl implements BiometricService {
  // NOTE: In a real app, these would point to your EXE and shared JSON file.
  static const String _exePath = 'assets/FingerprintApp.exe';

  BiometricServiceImpl() {
    reaction((_) => isScanning.value, (bool scanning) {
      if (scanning) {
        print("i ahve enjoed");
        verifyUser();
      }
    });
  }

  final MemberStore memberStore = getIt<MemberStore>();
  final AttendanceStore attendanceStore = getIt<AttendanceStore>();

  final isScanning = Observable<bool>(false);

  final lastScanResult = Observable<Map<String, dynamic>?>(null);

  void toggleScanning(bool enable) {
    print("Passing it to utwwww $enable");
    runInAction(() {
      isScanning.value = enable;
    });
  }

  @override
  Future<String?> enrollUser() async {
    final enrollResult = await Process.run(_exePath, [
      'enroll',
    ], workingDirectory: File(_exePath).parent.path);

    final output = enrollResult.stdout.toString().trim();
    final lines = output.split('\n').map((l) => l.trim()).toList();

    if (lines.contains("ENROLL_FAILED_EMPTY_FMD")) {
      // "No fingerprint detected. Please try again."
      return "ID-1";
    }

    if (!lines.contains("ENROLL_SUCCESS")) {
      //"Enrollment Failed", "Enrollment process failed.");
      return "ID-2";
    }

    final fmdLine = lines.firstWhere(
      (line) => line.startsWith("FMD_BASE64:"),
      orElse: () => "",
    );

    if (fmdLine.isEmpty) {
      //"Enrollment Failed", "No fingerprint data received.");
      return "ID-3";
    }

    // 5. Return the valid fingerprint template (FMD Base64 string)
    return fmdLine.split(":")[1].trim();
  }

  Future<String> getTempFile(List<FmdData> fmdList) async {
    final fmdJson = jsonEncode({'members': fmdList});
    final tempFileName = 'temp_fmd_data.json';
    final tempFilePath =
        File(_exePath).parent.path + Platform.pathSeparator + tempFileName;
    final tempFile = File(tempFilePath);
    try {
      // Write the large JSON data to the temporary file
      await tempFile.writeAsString(fmdJson);
      return tempFilePath;
    } catch (e) {
      debugPrint("Error writing temp FMD file: $e");
      return "";
    }
  }

  @override
  Future<void> verifyUser() async {
    while (isScanning.value) {
      print("i am here ${isScanning.value}");
      final result = await _performSingleScanAndMatch();
      // Update the observable so the UI can react
      runInAction(() async {
        lastScanResult.value = result;
              print("Got RESuLts ${await lastScanResult.toString()}");

      });
      // Wait before the next scan attempt
      if (result['status'] != ScanStatus.matchSuccess &&
          result['status'] != ScanStatus.matchFeeOverdue) {
        // Only delay if it wasn't a success (to prevent rapid popups)
        await Future.delayed(const Duration(milliseconds: 400));
      }
    }
  }

  // NEW: Performs a single scan and returns a structured result
  Future<Map<String, dynamic>> _performSingleScanAndMatch() async {
    final processResult = await Process.run(_exePath, [
      'match',
      "${File(_exePath).parent.path}${Platform.pathSeparator}temp_fmd_data.json",
    ], workingDirectory: File(_exePath).parent.path);
              print("Got results aksjlhdajksd");

    final output = processResult.stdout.toString().trim();
    final error = processResult.stderr.toString().trim();

              print("Got resultsX $output and  $error");

    if (error.isNotEmpty) debugPrint("C# STDERR:\n$error");

    // 1. Timeout / No Finger detected
    if (output.isEmpty || output.contains("MATCH_FAILED_TIMEOUT")) {
      return {'status': ScanStatus.noFinger};
    }

    final lines = output.split('\n').map((line) => line.trim()).toList();
    final matchLine = lines.firstWhere(
      (line) => line.startsWith('MATCH:') || line == 'NO_MATCH_REGISTER',
      orElse: () => '',
    );

    // 2. --- Match Successful ---
    if (matchLine.startsWith('MATCH:')) {
      final memberIdStr = matchLine.split(':')[1].trim();
      final memberId = int.tryParse(memberIdStr);

      if (memberId == null) {
        // Data integrity error from C# app
        return {'status': ScanStatus.errorIntegrity, 'data': memberIdStr};
      }

      final member = await memberStore.findMemberById(memberId);

      if (member == null) {
        // Data integrity error: ID exists in FMD file but not in DB
        return {'status': ScanStatus.errorIntegrity, 'data': memberId};
      }

      // 3. Fee Overdue Check
      if (member.lastFeePaymentDate != null &&
          DateTime.now().isAfter(
            member.lastFeePaymentDate!.add(const Duration(days: 30)),
          )) {
        return {
          'status': ScanStatus.matchFeeOverdue,
          'data': memberId,
          'name': member.name,
        };
      }

      // 4. Match Success (Attendance Marked)
      await attendanceStore.logCheckIn(
        AttendanceRecord(
          memberId: member.memberId,
          checkInTime: DateTime.now(),
        ),
      );
      return {
        'status': ScanStatus.matchSuccess,
        'data': memberId,
        'name': member.name,
      };
    }
    // 5. --- No Match Found / Needs Enrollment ---
    else if (matchLine == 'NO_MATCH_REGISTER') {
      final fmdLine = lines.firstWhere(
        (line) => line.startsWith('FMD_BASE64:'),
        orElse: () => '',
      );

      if (fmdLine.isNotEmpty) {
        final fmdBase64 = fmdLine.split(':')[1].trim();
        return {'status': ScanStatus.notRecognized, 'data': fmdBase64};
      }
    }

    return {'status': ScanStatus.errorGeneric};
  }
}
