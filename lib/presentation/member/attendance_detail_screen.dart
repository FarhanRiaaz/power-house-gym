import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/presentation/components/app_empty_state.dart';
import 'package:finger_print_flutter/presentation/components/app_list_tile.dart';
import 'package:finger_print_flutter/presentation/components/app_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/models/attendance_record.dart';
import '../../domain/entities/models/member.dart';
import 'attendance_screen.dart';

class MemberAttendanceDetailScreen extends StatelessWidget {
  final Member member;

  const MemberAttendanceDetailScreen({super.key, required this.member});

  List<AttendanceRecord> get _memberAttendance {
    return GlobalState.attendanceRecords.where((r) => r.memberId == member.memberId).toList();
  }

  @override
  Widget build(BuildContext context) {
    final historicalRecords = _memberAttendance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
      ),
      body: Center(
        child: SizedBox(
          width: 800,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Member Profile Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          member.name![0],
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name!,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'S/O: ${member.fatherName}',
                            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                          ),
                          Text(
                            'Total Check-ins: ${historicalRecords.length}',
                            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                    'Historical Check-in Log',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF263238))
                ),
                const Divider(),

                // Historical List
                Expanded(
                  child: historicalRecords.isEmpty
                      ? const AppEmptyState(message: 'No historical attendance found.', icon: Icons.history)
                      : ListView.builder(
                    itemCount: historicalRecords.length,
                    itemBuilder: (context, index) {
                      final record = historicalRecords[index];
                      final checkInTime = record.checkInTime!;
                      final isLate = checkInTime.hour >= 9;
                      final statusColor = isLate ? AppColors.warning : AppColors.success;

                      return AppListTile(
                        title: DateFormat('EEEE, MMM dd, yyyy').format(checkInTime),
                        subtitle: 'Check-in Time: ${DateFormat('hh:mm:ss a').format(checkInTime)}',
                        leadingIcon: isLate ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                        statusColor: statusColor,
                        trailing: AppStatusBadge(
                          label: isLate ? 'LATE ENTRY' : 'NORMAL',
                          color: statusColor,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}