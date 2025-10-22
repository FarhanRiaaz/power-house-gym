import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/presentation/components/app_empty_state.dart';
import 'package:finger_print_flutter/presentation/components/app_list_tile.dart';
import 'package:finger_print_flutter/presentation/components/app_section_header.dart';
import 'package:finger_print_flutter/presentation/components/app_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/models/attendance_record.dart';
import '../../domain/entities/models/financial_transaction.dart';
import '../../domain/entities/models/member.dart';
import 'attendance_detail_screen.dart';

class GlobalState {

  // Mock Members (Updated with fatherName)
  static List<Member> members = [
    Member(memberId: 1001, name: 'Ahmed Khan', fatherName: 'Zahid Khan'),
    Member(memberId: 1002, name: 'Fatima Ali', fatherName: 'Tariq Ali'),
    Member(memberId: 1003, name: 'Usman Sharif', fatherName: 'Imran Sharif'),
    Member(memberId: 1004, name: 'Aisha Malik', fatherName: 'Haroon Malik'),
  ];

  // Mock Transaction Source
  static final List<FinancialTransaction> _mockTransactions = [
    FinancialTransaction(id: 3001, type: 'Fee Payment', amount: 5000.00, transactionDate: DateTime(2024, 10, 15), description: 'Monthly fee paid by Ahmed Khan', relatedMemberId: 1001),
    FinancialTransaction(id: 3002, type: 'Fee Payment', amount: 7500.00, transactionDate: DateTime(2024, 10, 21), description: 'Annual membership fee', relatedMemberId: 1003),
    FinancialTransaction(id: 3003, type: 'Fee Payment', amount: 5000.00, transactionDate: DateTime(2024, 9, 28), description: 'September fee - Fatima Ali', relatedMemberId: 1002),
    FinancialTransaction(id: 3004, type: 'Expense', amount: -50000.00, transactionDate: DateTime(2024, 10, 1), description: 'Monthly facility rent'),
    FinancialTransaction(id: 3005, type: 'Expense', amount: -35000.00, transactionDate: DateTime(2024, 10, 25), description: 'Trainer salary - October'),
    FinancialTransaction(id: 3006, type: 'Bill', amount: -12500.00, transactionDate: DateTime(2024, 10, 10), description: 'Electricity and water bill'),
    FinancialTransaction(id: 3007, type: 'Expense', amount: -5000.00, transactionDate: DateTime(2024, 10, 20), description: 'New set of weights'),
  ];

  // NEW MOCK DATA: Attendance
  static final List<AttendanceRecord> _mockAttendance = [
    // Today's records
    AttendanceRecord(id: 1, memberId: 1001, checkInTime: DateTime(2024, 10, 26, 7, 30)),
    AttendanceRecord(id: 2, memberId: 1002, checkInTime: DateTime(2024, 10, 26, 8, 05)),
    AttendanceRecord(id: 3, memberId: 1003, checkInTime: DateTime(2024, 10, 26, 9, 15)), // Late check-in
    AttendanceRecord(id: 4, memberId: 1004, checkInTime: DateTime(2024, 10, 26, 7, 45)),
    // Previous records
    AttendanceRecord(id: 5, memberId: 1001, checkInTime: DateTime(2024, 10, 25, 7, 40)),
    AttendanceRecord(id: 6, memberId: 1002, checkInTime: DateTime(2024, 10, 25, 8, 15)),
    AttendanceRecord(id: 7, memberId: 1003, checkInTime: DateTime(2024, 10, 24, 7, 50)),
    AttendanceRecord(id: 8, memberId: 1004, checkInTime: DateTime(2024, 10, 24, 12, 00)),
    AttendanceRecord(id: 9, memberId: 1001, checkInTime: DateTime(2024, 10, 23, 7, 55)),
    AttendanceRecord(id: 10, memberId: 1002, checkInTime: DateTime(2024, 10, 22, 7, 45)),
  ].toList()..sort((a, b) => b.checkInTime!.compareTo(a.checkInTime!)); // Sort by date descending

  static List<FinancialTransaction> get transactions {
    _mockTransactions.sort((a, b) => b.transactionDate!.compareTo(a.transactionDate!));
    return _mockTransactions;
  }

  static List<AttendanceRecord> get attendanceRecords => _mockAttendance;

  static void deleteTransaction(int id) {
    _mockTransactions.removeWhere((t) => t.id == id);
  }

  // UPDATED: Central member getter
  static Member? getMemberById(int? id) {
    if (id == null) return null;
    return members.firstWhereOrNull((m) => m.memberId == id);
  }

  static String? getMemberNameById(int? id) => getMemberById(id)?.name;
}


class AttendanceScreen extends StatefulWidget {
  final VoidCallback onUpdate;

  const AttendanceScreen({super.key, required this.onUpdate});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _searchQuery = '';
  final List<AttendanceRecord> _allRecords = GlobalState.attendanceRecords;

  // Filtered list getter
  List<AttendanceRecord> get _filteredRecords {
    if (_searchQuery.isEmpty) {
      // Group records by day for better viewing in the main list
      return _allRecords;
    }

    final query = _searchQuery.toLowerCase();

    // Filter records based on member name or father name
    return _allRecords.where((record) {
      final member = GlobalState.getMemberById(record.memberId);
      if (member == null) return false;

      final name = member.name!.toLowerCase();
      final fatherName = member.fatherName!.toLowerCase();

      return name.contains(query) || fatherName.contains(query);
    }).toList();
  }

  // Grouping function to display daily headers (optional, but improves list readability)
  Map<DateTime, List<AttendanceRecord>> _getRecordsGroupedByDay(List<AttendanceRecord> records) {
    Map<DateTime, List<AttendanceRecord>> grouped = {};
    for (var record in records) {
      final date = DateTime(record.checkInTime!.year, record.checkInTime!.month, record.checkInTime!.day);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(record);
    }
    return grouped;
  }

  // Helper to handle navigation to the detail screen
  void _viewMemberAttendance(Member member) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MemberAttendanceDetailScreen(member: member),
      ),
    ).then((_) {
      // Rebuild the list when returning from the detail screen
      widget.onUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupedRecords = _getRecordsGroupedByDay(_filteredRecords);
    final sortedDates = groupedRecords.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const AppSectionHeader(title: 'Attendance Log'),
      
            // Search Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by Member Name or Father\'s Name',
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: sortedDates.isEmpty
                    ? const AppEmptyState(message: 'No attendance records found.', icon: Icons.watch_later_outlined)
                    : ListView.builder(
                  itemCount: sortedDates.length,
                  itemBuilder: (context, dateIndex) {
                    final date = sortedDates[dateIndex];
                    final recordsForDay = groupedRecords[date]!;
      
                    // Determine the header text (Today, Yesterday, or Date)
                    String headerText;
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final yesterday = today.subtract(const Duration(days: 1));
      
                    if (date.isAtSameMomentAs(today)) {
                      headerText = 'Today';
                    } else if (date.isAtSameMomentAs(yesterday)) {
                      headerText = 'Yesterday';
                    } else {
                      headerText = DateFormat('EEEE, MMM dd').format(date);
                    }
      
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
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
                          final member = GlobalState.getMemberById(record.memberId);
                          if (member == null) return const SizedBox.shrink(); // Skip if no member data
      
                          final checkInTime = record.checkInTime!;
                          final isLate = checkInTime.hour >= 9; // Mock rule: check-in after 9 AM is late
                          final statusColor = isLate ? AppColors.warning : AppColors.success;
      
                          return AppListTile(
                            onTap: () => _viewMemberAttendance(member),
                            title: member.name!,
                            subtitle: 'S/O: ${member.fatherName}',
                            leadingIcon: Icons.person_pin_circle_outlined,
                            statusColor: statusColor,
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  DateFormat('hh:mm a').format(checkInTime),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isLate ? AppColors.warning : AppColors.success
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AppStatusBadge(
                                    label: isLate ? 'LATE' : 'ON TIME',
                                    color: isLate ? AppColors.warning : AppColors.success
                                ),
                              ],
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
    );
  }
}