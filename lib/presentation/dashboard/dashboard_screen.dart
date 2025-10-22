import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/core/style/app_text_styles.dart';
import 'package:finger_print_flutter/presentation/attendance/store/attendance_store.dart';
import 'package:finger_print_flutter/presentation/auth/store/auth_store.dart';
import 'package:finger_print_flutter/presentation/components/app_button.dart';
import 'package:finger_print_flutter/presentation/components/app_card.dart';
import 'package:finger_print_flutter/presentation/components/app_section_header.dart';
import 'package:finger_print_flutter/presentation/components/app_status_bar.dart';
import 'package:finger_print_flutter/presentation/components/background_wrapper.dart';
import 'package:finger_print_flutter/presentation/expense/store/expense_store.dart';
import 'package:finger_print_flutter/presentation/financial/store/financial_store.dart';
import 'package:finger_print_flutter/presentation/member/store/member_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../di/service_locator.dart';

class AttendanceLog {
  final int memberId;
  final String name;
  final DateTime checkInTime;
  // Optional: Add checkOutTime if needed, but using checkInTime for simplicity

  AttendanceLog({
    required this.memberId,
    required this.name,
    required this.checkInTime,
  });
}


// Helper class for mock data (mimics data structures typically returned by stores)
class RecentLog {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  RecentLog(this.title, this.subtitle, this.icon, this.color);
}

class DashboardScreen extends StatelessWidget {
  // Assume stores are accessible via getIt
  final AuthStore authStore = getIt<AuthStore>();
  final MemberStore memberStore = getIt<MemberStore>();
  final AttendanceStore attendanceStore = getIt<AttendanceStore>();
  final FinancialStore financeStore = getIt<FinancialStore>();
  final ExpenseStore expenseStore = getIt<ExpenseStore>();

  DashboardScreen({super.key});

  // --- HARDCODED MOCK DATA ---
  // Replace this with observer logic to use actual store data later.
  final mockData = {
    // Operational
    'activeCheckIns': 42,
    'lastReceiptId': 'T-90328',
    'occupiedHours': '08:00 - 09:00',

    // Financial
    'expense': 3500,
    'todayRevenue': 1500.00,
    'todayRevenueChange': 12.5,
    'monthlyRevenue': 65000.00,
    'monthlyRevenueChange': 3.1,

    // Membership/Engagement
    'activeMemberCount': 485,
    'attendanceRate': 75.5, // percentage
    'newMembersThisWeek': 14,
    'expiringMembers': 21,
  };

  // Hardcoded Logs for the Recent Activity Feed
  final List<RecentLog> recentLogs = [
    RecentLog('Omar Saeed', 'Checked In (7:55 AM)', Icons.directions_run, AppColors.success),
    RecentLog('Sale: New Contract', 'Cardio Membership (PKR 25,000)', Icons.receipt, AppColors.primary),
    RecentLog('Fatima Khan', 'Checked Out (9:10 AM)', Icons.logout, AppColors.success),
    RecentLog('Ahmed Zaki', 'Membership Expired (Follow Up)', Icons.warning, AppColors.warning),
    RecentLog('Staff Login', 'Admin logged in at 6:45 AM', Icons.verified_user, AppColors.danger),
  ];


  final List<AttendanceLog> mockAttendanceLogs = [
    AttendanceLog(memberId: 1001, name: 'Omar Saeed', checkInTime: DateTime.now().subtract(const Duration(minutes: 5))),
    AttendanceLog(memberId: 1005, name: 'Fatima Khan', checkInTime: DateTime.now().subtract(const Duration(minutes: 15))),
    AttendanceLog(memberId: 1012, name: 'Ahmed Zaki', checkInTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 22))),
    AttendanceLog(memberId: 1020, name: 'Sana Malik', checkInTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 40))),
    AttendanceLog(memberId: 1033, name: 'Bilal Qureshi', checkInTime: DateTime.now().subtract(const Duration(hours: 3, minutes: 10))),
    AttendanceLog(memberId: 1045, name: 'Aisha Jamil', checkInTime: DateTime.now().subtract(const Duration(hours: 4, minutes: 50))),
    AttendanceLog(memberId: 1050, name: 'Usman Ali', checkInTime: DateTime.now().subtract(const Duration(hours: 5, minutes: 5))),
  ];


  // --- WIDGET HELPERS ---

  /// Builds a KPI card with responsiveness based on constraints.
  Widget _buildKpiRow({
    required BuildContext context,
    required BoxConstraints constraints,
    required List<Widget> cards,
  }) {
    final isWide = constraints.maxWidth > 1000;
    final wrapSpacing = isWide ? 16.0 : 12.0;

    if (isWide) {
      // Use Row for very wide screens (3-4 cards horizontally)
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cards.expand((card) => [Expanded(child: card), SizedBox(width: wrapSpacing)]).toList()..removeLast(),
      );
    } else {
      // Use Wrap for standard desktop/tablet width (2-3 cards wrapping)
      return Wrap(
        spacing: wrapSpacing,
        runSpacing: wrapSpacing,
        children: cards.map((card) => SizedBox(
          width: constraints.maxWidth / (constraints.maxWidth > 800 ? 3 : 2) - (wrapSpacing * 1.5),
          child: card,
        )).toList(),
      );
    }
  }

  // Helper widget to display a single log item (assuming a functional AppListTile equivalent)
  Widget _buildRecentLogTile(RecentLog log) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AppCard(
        // Using AppCard as a list tile substitute since AppListTile wasn't defined
        title: log.title,
        subtitle: log.subtitle,
        leading: Icon(log.icon, color: log.color),
        trailing: log.color == AppColors.warning
            ?  AppStatusBadge(label: 'ACTION REQUIRED', color: AppColors.danger)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Currency format for better readability
    final currencyFormatter = NumberFormat.currency(locale: 'en_PK', symbol: 'PKR ');
    final attendanceColor = mockData['attendanceRate'] as double >= 70.0 ? AppColors.success : AppColors.warning;
    final revenueColor = mockData['todayRevenueChange'] as double >= 0 ? AppColors.success : AppColors.danger;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                AppSectionHeader(
                   title: 'Dashboard',),
                 const SizedBox(height: 24),

                                Observer(
                  builder: (_) => LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 800;
                      final cards = [
                        Expanded(
                          child:  Observer(
                            builder: (_) => AppStatusBadge(
                              label: authStore.currentUser?.role.name.toUpperCase() ?? 'Super Admin',
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          child:  AppButton(
                            label: 'Logout',
                            icon: Icons.logout,
                            onPressed: () => authStore.logout(),
                          ),
                        ),
                      ];
                      return Row(children: cards);
                    },
                  ),
                ),
                SizedBox(height: 24,),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    AppButton(
                      label: 'Scan Fingerprint',
                      icon: Icons.fingerprint,
                      // onPressed: () => fingerprintStore.scan(),

                      onPressed: () => (){},
                    ),
                    AppButton(
                      label: 'Enroll Member',
                      icon: Icons.person_add,

                      onPressed: () => (){},
                      //onPressed: () => memberStore.openEnrollDialog(),
                    ),
                    AppButton(
                      label: 'Export Data',
                      icon: Icons.download,

                      onPressed: () => (){},
                      // onPressed: () => financeStore.exportToExcel(),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                Observer(
                  builder: (_) => LayoutBuilder(
                    builder: (context, constraints) {
                      final cards = <Widget>[
                        // KPI 1: Active Check-Ins (Operational)

                        AppCard(
                          title: 'Hot Time 🔥',
                          subtitle: 'Occupied Hours',
                          leading: Icon(Icons.fitness_center_outlined, size: 36, color: AppColors.success),
                          trailing: Text(
                              mockData['occupiedHours'].toString(),
                              style: AppTextStyles.heading.copyWith(fontSize: 16, color: AppColors.success)
                          ),
                        ),
                        AppCard(
                          title: 'Active Check-Ins',
                          subtitle: 'Currently in Gym',
                          leading: Icon(Icons.fitness_center, size: 36, color: AppColors.success),
                          trailing: Text(
                              mockData['activeCheckIns'].toString(),
                              style: AppTextStyles.heading.copyWith(fontSize: 32, color: AppColors.success)
                          ),
                        ),
                        // KPI 2: Today's Revenue (Financial)
                        AppCard(
                          title: 'Finance',
                          subtitle: 'Change: ${mockData['todayRevenueChange']}%',
                          leading: Icon(Icons.attach_money, size: 36, color: AppColors.primary),
                          trailing: Text(
                              currencyFormatter.format(mockData['todayRevenue']),
                              style: AppTextStyles.heading.copyWith(fontSize: 20, color: revenueColor)
                          ),
                        ),
                        // KPI 3: Active Members (Membership)
                        AppCard(
                          title: 'Active Members',
                          subtitle: 'Total Registered & Current',
                          leading: Icon(Icons.group, size: 36, color: AppColors.textPrimary),
                          trailing: Text(
                              mockData['activeMemberCount'].toString(),
                              style: AppTextStyles.heading.copyWith(fontSize: 32, color: AppColors.textSecondary)
                          ),
                        ),

                      ];
                      return _buildKpiRow(context: context, constraints: constraints, cards: cards);
                    },
                  ),
                ),
          
                const SizedBox(height: 32),
          
                // 4. SECONDARY METRICS (Monthly Health & Alerts)
                const AppSectionHeader(title: 'Health & Alerts'),
                const SizedBox(height: 16),
          
                Observer(
                  builder: (_) => LayoutBuilder(
                    builder: (context, constraints) {
                      final cards = <Widget>[
                        AppCard(
                          title: 'Expense',
                          subtitle: 'Change: ${mockData['todayRevenueChange']}%',
                          leading: Icon(Icons.attach_money, size: 36, color: AppColors.primary),
                          trailing: Text(
                              currencyFormatter.format(mockData['expense']),
                              style: AppTextStyles.heading.copyWith(fontSize: 20, color: revenueColor)
                          ),
                        ),
                        AppCard(
                          title: 'Expiring Members',
                          subtitle: 'Contracts due in 7 days',
                          leading: const Icon(Icons.person_off, color: AppColors.danger),
                          trailing: Text(
                              mockData['expiringMembers'].toString(),
                              style: AppTextStyles.subheading.copyWith(color: AppColors.danger)
                          ),
                        ),
                        // Metric 4: New Members (Growth)
                        AppCard(
                          title: 'New Members',
                          subtitle: 'Signed up this week',
                          leading: const Icon(Icons.celebration, color: AppColors.success),
                          trailing: Text(
                              mockData['newMembersThisWeek'].toString(),
                              style: AppTextStyles.subheading.copyWith(color: AppColors.success)
                          ),
                        ),
                        AppCard(
                          title: 'Attendance Rate',
                          subtitle: 'Last 30 Days Average',
                          leading: const Icon(Icons.calendar_month, color: AppColors.primary),
                          trailing: Text(
                              '${mockData['attendanceRate']}%',
                              style: AppTextStyles.subheading.copyWith(color: attendanceColor)
                          ),
                        ),
                      ];
                      return _buildKpiRow(context: context, constraints: constraints, cards: cards);
                    },
                  ),
                ),
          
                const SizedBox(height: 32),
          
                // 5. RECENT ACTIVITY LOG
                const AppSectionHeader(title: 'Recent Activity Logs'),
                const SizedBox(height: 16),
          
                // Use a constrained height for the feed so the scroll view works better on desktop
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: recentLogs.length,
                    itemBuilder: (context, index) {
                      return _buildRecentLogTile(recentLogs[index]);
                    },
                  ),
                ),
          
                // Placeholder for Fingerprint Status (kept from original for structure)
                const SizedBox(height: 32),
                const AppSectionHeader(title: 'Attendance'),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: mockAttendanceLogs.length,
                    itemBuilder: (context, index) {
                      // 💡 Calling the new tile builder
                      return _buildAttendanceLogTile(mockAttendanceLogs[index]);
                    },
                  ),
                ),
                AppSectionHeader(title: 'Device Status'),
                const SizedBox(height: 16),
                Observer(
                  builder: (_) => AppCard(
                    title: 'Fingerprint Scanner Status',
                    subtitle: 'Last scan result: 10:15 AM',
                    leading: const Icon(Icons.fingerprint),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const AppStatusBadge(
                          label: "MATCH SUCCESSFUL",
                          color: AppColors.success,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Device connected and ready.',
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildAttendanceLogTile(AttendanceLog log) {
    // Format the time using Intl package
    final timeFormatted = DateFormat('hh:mm a').format(log.checkInTime);
    final dateFormatted = DateFormat('MMM dd').format(log.checkInTime);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AppCard(
        title: '${log.name} (ID: ${log.memberId})',
        subtitle: 'Checked In at $timeFormatted',
        leading: Icon(Icons.directions_run, color: AppColors.success, size: 30),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(timeFormatted, style: AppTextStyles.subheading.copyWith(fontSize: 18)),
            const SizedBox(height: 4),
            Text(dateFormatted, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}