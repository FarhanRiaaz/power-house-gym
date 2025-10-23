import 'package:finger_print_flutter/core/enum.dart';
import 'package:finger_print_flutter/core/list_to_csv_converter.dart';
import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/presentation/attendance/store/attendance_store.dart';
import 'package:finger_print_flutter/presentation/components/app_empty_state.dart';
import 'package:finger_print_flutter/presentation/components/app_list_tile.dart';
import 'package:finger_print_flutter/presentation/components/app_section_header.dart';
import 'package:finger_print_flutter/presentation/components/app_status_bar.dart';
import 'package:finger_print_flutter/presentation/components/background_wrapper.dart';
import 'package:finger_print_flutter/presentation/member/store/member_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../di/service_locator.dart';
import '../../domain/entities/models/attendance_record.dart';
import '../../domain/entities/models/financial_transaction.dart';
import '../../domain/entities/models/member.dart';
import 'attendance_detail_screen.dart';

class AttendanceScreen extends StatefulWidget {
  final VoidCallback onUpdate;

  const AttendanceScreen({super.key, required this.onUpdate});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {

  @override
  void initState() {
    attendanceStore.watchTodayAttendance(genderFilter: Gender.male);
    super.initState();
  }

  String _searchQuery = '';
  final AttendanceStore attendanceStore = getIt<AttendanceStore>();
  final MemberStore memberStore = getIt<MemberStore>();

  // Filtered list getter
  List<AttendanceRecord> get _filteredRecords {
    if (_searchQuery.isEmpty) {
      // Group records by day for better viewing in the main list
      return attendanceStore.todayAttendanceList;
    }

    final query = _searchQuery.toLowerCase();

    // Filter records based on member name or father name
    return attendanceStore.todayAttendanceList.where((record) {
      final member = getMemberById(record.memberId);
      if (member == null) return false;

      final name = member.name!.toLowerCase();
      final fatherName = member.fatherName!.toLowerCase();

      return name.contains(query) || fatherName.contains(query);
    }).toList();
  }

  // Grouping function to display daily headers (optional, but improves list readability)
  Map<DateTime, List<AttendanceRecord>> _getRecordsGroupedByDay(
    List<AttendanceRecord> records,
  ) {
    Map<DateTime, List<AttendanceRecord>> grouped = {};
    for (var record in records) {
      final date = DateTime(
        record.checkInTime!.year,
        record.checkInTime!.month,
        record.checkInTime!.day,
      );
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(record);
    }
    return grouped;
  }

  // Helper to handle navigation to the detail screen
  void _viewMemberAttendance(Member member) {
    attendanceStore.getSingleAttendanceList(member.memberId!??0);
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => MemberAttendanceDetailScreen(member: member),
          ),
        )
        .then((_) {
          // Rebuild the list when returning from the detail screen
          widget.onUpdate();
        });
  }

  @override
  Widget build(BuildContext context) {
    final groupedRecords = _getRecordsGroupedByDay(_filteredRecords);
    final sortedDates = groupedRecords.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      body: BackgroundWrapper(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              AppSectionHeader(
                title: 'Attendance Log',
                trailingWidget: GestureDetector(
                  onTap: () async {
                    try {
                      final filePath = await SimpleCsvConverter()
                          .pickExcelFile();

                      final csvData = await SimpleCsvConverter().readCsvFile(
                        filePath,
                      );
                      await attendanceStore.importDataToDatabase(csvData);
                    } catch (e) {
                      print('Import failed: $e');
                      // Optionally show a dialog or snackbar here
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.import_contacts_outlined),
                      SizedBox(width: 16),
                      Text("Import Attendance"),
                    ],
                  ),
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by Member Name or Father\'s Name',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primary,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundDark,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),

              // Attendance List
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: sortedDates.isEmpty
                      ? const AppEmptyState(
                          message: 'No attendance records found.',
                          icon: Icons.watch_later_outlined,
                        )
                      : ListView.builder(
                          itemCount: sortedDates.length,
                          itemBuilder: (context, dateIndex) {
                            final date = sortedDates[dateIndex];
                            final recordsForDay = groupedRecords[date]!;

                            // Determine the header text (Today, Yesterday, or Date)
                            String headerText;
                            final now = DateTime.now();
                            final today = DateTime(
                              now.year,
                              now.month,
                              now.day,
                            );
                            final yesterday = today.subtract(
                              const Duration(days: 1),
                            );

                            if (date.isAtSameMomentAs(today)) {
                              headerText = 'Today';
                            } else if (date.isAtSameMomentAs(yesterday)) {
                              headerText = 'Yesterday';
                            } else {
                              headerText = DateFormat(
                                'EEEE, MMM dd',
                              ).format(date);
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    24,
                                    16,
                                    16,
                                    8,
                                  ),
                                  child: Text(
                                    headerText,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                ...recordsForDay.map((record) {
                                  final member = getMemberById(record.memberId);
                                  if (member == null) {
                                    return const SizedBox.shrink(); // Skip if no member data
                                  }

                                  final checkInTime = record.checkInTime!;
                                  final isLate =
                                      checkInTime.hour >=
                                      9; // Mock rule: check-in after 9 AM is late
                                  final statusColor = isLate
                                      ? AppColors.warning
                                      : AppColors.success;

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      child: AppListTile(
                                        onTap: () =>
                                            _viewMemberAttendance(member),
                                        title: member.name!,
                                        subtitle: 'S/O: ${member.fatherName}',
                                        leadingIcon:
                                            Icons.person_pin_circle_outlined,
                                        statusColor: statusColor,
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              DateFormat(
                                                'hh:mm a',
                                              ).format(checkInTime),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: isLate
                                                    ? AppColors.warning
                                                    : AppColors.success,
                                              ),
                                            ),
                                            // const SizedBox(height: 4),
                                            AppStatusBadge(
                                              label: isLate
                                                  ? 'LATE'
                                                  : 'ON TIME',
                                              color: isLate
                                                  ? AppColors.warning
                                                  : AppColors.success,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<AttendanceRecord> get attendanceRecords =>
      attendanceStore.todayAttendanceList;

  // UPDATED: Central member getter
  Member? getMemberById(int? id) {
    if (id == null) return null;
    return memberStore.memberList.firstWhereOrNull((m) => m.memberId == id);
  }

  String? getMemberNameById(int? id) =>
      memberStore.memberList.firstWhereOrNull((m) => m.memberId == id)?.name;
}
