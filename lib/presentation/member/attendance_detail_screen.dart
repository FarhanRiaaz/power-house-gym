import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/presentation/components/app_empty_state.dart';
import 'package:finger_print_flutter/presentation/components/app_list_tile.dart';
import 'package:finger_print_flutter/presentation/components/app_status_bar.dart';
import 'package:finger_print_flutter/presentation/components/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../di/service_locator.dart';
import '../../domain/entities/models/member.dart';
import '../attendance/store/attendance_store.dart';

class MemberAttendanceDetailScreen extends StatelessWidget {
  final Member member;

   MemberAttendanceDetailScreen({super.key, required this.member});
  final AttendanceStore attendanceStore = getIt<AttendanceStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('Attendance History'),
      ),
      body: BackgroundWrapper(
        child: Center(
          child: SizedBox(
            width: 800,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                              'Total Check-ins: ${attendanceStore.reportAttendanceList.length}',
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
                    child: attendanceStore.reportAttendanceList.isEmpty
                        ? const AppEmptyState(message: 'No historical attendance found.', icon: Icons.history)
                        : ListView.builder(
                      itemCount: attendanceStore.reportAttendanceList.length,
                      itemBuilder: (context, index) {
                        final record = attendanceStore.reportAttendanceList[index];
                        final checkInTime = record.checkInTime!;
                        final isLate = checkInTime.hour >= 9;
                        final statusColor = isLate ? AppColors.warning : AppColors.success;
        
                        return
                        
                        
                        Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: DecoratedBox(
        
                              decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary),),
                              
                        child:
                         AppListTile(
                          title: DateFormat('EEEE, MMM dd, yyyy').format(checkInTime),
                          subtitle: 'Check-in Time: ${DateFormat('hh:mm:ss a').format(checkInTime)}',
                          leadingIcon: isLate ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                          statusColor: statusColor,
                          trailing: AppStatusBadge(
                            label: isLate ? 'LATE ENTRY' : 'NORMAL',
                            color: statusColor,
                          ),
                        )
                          ));  },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}