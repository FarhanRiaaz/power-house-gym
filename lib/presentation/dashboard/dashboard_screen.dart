import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/core/style/app_text_styles.dart';
import 'package:finger_print_flutter/domain/entities/models/attendance_record.dart';
import 'package:finger_print_flutter/domain/entities/models/financial_transaction.dart';
import 'package:finger_print_flutter/presentation/attendance/store/attendance_store.dart';
import 'package:finger_print_flutter/presentation/auth/store/auth_store.dart';
import 'package:finger_print_flutter/presentation/components/app_button.dart';
import 'package:finger_print_flutter/presentation/components/app_card.dart';
import 'package:finger_print_flutter/presentation/components/app_section_header.dart';
import 'package:finger_print_flutter/presentation/components/app_status_bar.dart';
import 'package:finger_print_flutter/presentation/components/app_toggle.dart';
import 'package:finger_print_flutter/presentation/components/background_wrapper.dart';
import 'package:finger_print_flutter/presentation/dashboard/store/dashboard_store.dart';
import 'package:finger_print_flutter/presentation/expense/store/expense_store.dart';
import 'package:finger_print_flutter/presentation/financial/store/financial_store.dart';
import 'package:finger_print_flutter/presentation/member/store/member_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../di/service_locator.dart';
import 'dashboard_range_dialog.dart';

class DashboardScreen extends StatelessWidget {
  // Assume stores are accessible via getIt
  final AuthStore authStore = getIt<AuthStore>();
  final MemberStore memberStore = getIt<MemberStore>();
  final AttendanceStore attendanceStore = getIt<AttendanceStore>();
  final FinancialStore financeStore = getIt<FinancialStore>();
  final ExpenseStore expenseStore = getIt<ExpenseStore>();

  final DashboardStore dashboardStore = getIt<DashboardStore>();

  DashboardScreen({super.key});

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
        children:
            cards
                .expand(
                  (card) => [
                    Expanded(child: card),
                    SizedBox(width: wrapSpacing),
                  ],
                )
                .toList()
              ..removeLast(),
      );
    } else {
      // Use Wrap for standard desktop/tablet width (2-3 cards wrapping)
      return Wrap(
        spacing: wrapSpacing,
        runSpacing: wrapSpacing,
        children: cards
            .map(
              (card) => SizedBox(
                width:
                    constraints.maxWidth /
                        (constraints.maxWidth > 800 ? 3 : 2) -
                    (wrapSpacing * 1.5),
                child: card,
              ),
            )
            .toList(),
      );
    }
  }

  final NumberFormat currencyFormat = NumberFormat.currency(symbol: 'Rs. ');

  TextSpan _formatChange(double change) {
    final symbol = change > 0 ? '▲' : (change < 0 ? '▼' : '');
    final color = change > 0
        ? AppColors.success
        : (change < 0 ? AppColors.danger : AppColors.textPrimary);

    return TextSpan(
      children: [
        TextSpan(
          text: '$symbol${change.abs().toStringAsFixed(1)}%',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        const TextSpan(text: ' vs Last Period'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSectionHeader(title: 'Dashboard'),
                const SizedBox(height: 24),
                DateRangeFilterWidget(),
                Observer(
                  builder: (_) {
                    if (dashboardStore.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final cards = [
                          Expanded(
                            child: Observer(
                              builder: (_) => AppStatusBadge(
                                label:
                                    authStore.currentUser?.role.name
                                        .toUpperCase() ??
                                    'Super Admin',
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            child: AppButton(
                              label: 'Logout',
                              icon: Icons.logout,
                              onPressed: () => authStore.logout(),
                            ),
                          ),
                        ];
                        return Row(children: cards);
                      },
                    );
                  },
                ),
                SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    AppToggle(
                      label: 'Enable Attendance',
                      icon: Icons.fingerprint,
                      onChanged: (value) => () {}, value: true,
                    ),
                    AppButton(
                      label: 'Enroll Member',
                      icon: Icons.person_add,
                      onPressed: () => () {},
                      //onPressed: () => memberStore.openEnrollDialog(),
                    ),
                    AppButton(
                      label: 'Export Data',
                      icon: Icons.download,
                      onPressed: () => () {},
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
                          leading: Icon(
                            Icons.fitness_center_outlined,
                            size: 36,
                            color: AppColors.success,
                          ),
                          trailing: Text(
                            dashboardStore.data?.occupiedHours.toString() ?? "",
                            style: AppTextStyles.heading.copyWith(
                              fontSize: 16,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                        AppCard(
                          title: 'Active Check-Ins',
                          subtitle: 'Currently in Gym',
                          leading: Icon(
                            Icons.fitness_center,
                            size: 36,
                            color: AppColors.success,
                          ),
                          trailing: Text(
                            dashboardStore.data?.activeCheckIns.toString() ??
                                "",
                            style: AppTextStyles.heading.copyWith(
                              fontSize: 32,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                        // KPI 2: Today's Revenue (Financial)
                        AppCard(
                          title: 'Finance',
                          subtitle:
                              'Change: ${dashboardStore.data?.todayRevenueChange ?? 0.0}%',
                          leading: Icon(
                            Icons.attach_money,
                            size: 36,
                            color: AppColors.primary,
                          ),
                          trailing: Text(
                            NumberFormat.currency(
                              locale: 'en_PK',
                              symbol: 'PKR ',
                            ).format(dashboardStore.data?.todayRevenue),
                            style: AppTextStyles.heading.copyWith(
                              fontSize: 20,
                              color:
                                  dashboardStore.data?.todayRevenueChange
                                          as double >=
                                      0
                                  ? AppColors.success
                                  : AppColors.danger,
                            ),
                          ),
                        ),
                        // KPI 3: Active Members (Membership)
                        AppCard(
                          title: 'Active Members',
                          subtitle: 'Total Registered & Current',
                          leading: Icon(
                            Icons.group,
                            size: 36,
                            color: AppColors.textPrimary,
                          ),
                          trailing: Text(
                            dashboardStore.data?.activeMemberCount.toString() ??
                                "",
                            style: AppTextStyles.heading.copyWith(
                              fontSize: 32,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ];
                      return _buildKpiRow(
                        context: context,
                        constraints: constraints,
                        cards: cards,
                      );
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
                          subtitle:
                              'Change: ${dashboardStore.data?.todayRevenueChange ?? 0.0}%',
                          leading: Icon(
                            Icons.attach_money,
                            size: 36,
                            color: AppColors.primary,
                          ),
                          trailing: Text(
                            NumberFormat.currency(
                              locale: 'en_PK',
                              symbol: 'PKR ',
                            ).format(dashboardStore.data?.expense ?? 0.0),
                            style: AppTextStyles.heading.copyWith(
                              fontSize: 20,
                              color:
                                  dashboardStore.data?.todayRevenueChange
                                          as double >=
                                      0
                                  ? AppColors.success
                                  : AppColors.danger,
                            ),
                          ),
                        ),
                        AppCard(
                          title: 'Expiring Members',
                          subtitle: 'Contracts due in 7 days',
                          leading: const Icon(
                            Icons.person_off,
                            color: AppColors.danger,
                          ),
                          trailing: Text(
                            dashboardStore.data?.expiringMembers.toString() ??
                                "0",
                            style: AppTextStyles.subheading.copyWith(
                              color: AppColors.danger,
                            ),
                          ),
                        ),
                        // Metric 4: New Members (Growth)
                        AppCard(
                          title: 'New Members',
                          subtitle: 'Signed up this week',
                          leading: const Icon(
                            Icons.celebration,
                            color: AppColors.success,
                          ),
                          trailing: Text(
                            dashboardStore.data?.newMembersThisWeek
                                    .toString() ??
                                "0",
                            style: AppTextStyles.subheading.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ),
                        AppCard(
                          title: 'Attendance Rate',
                          subtitle: 'Last 30 Days Average',
                          leading: const Icon(
                            Icons.calendar_month,
                            color: AppColors.primary,
                          ),
                          trailing: Text(
                            '${dashboardStore.data?.attendanceRate ?? 0}%',
                            style: AppTextStyles.subheading.copyWith(
                              color:
                                  dashboardStore.data?.attendanceRate
                                          as double >=
                                      70.0
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                        ),
                      ];
                      return _buildKpiRow(
                        context: context,
                        constraints: constraints,
                        cards: cards,
                      );
                    },
                  ),
                ),
               const SizedBox(height: 32),
                 attendanceStore.reportAttendanceList.isNotEmpty? const AppSectionHeader(title: 'Attendance'): const SizedBox.shrink(),

                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: Observer(
                    builder: (context) {
                      return attendanceStore.reportAttendanceList.isNotEmpty? ListView.builder(
                        shrinkWrap: true,
                        itemCount: attendanceStore.reportAttendanceList.length,
                        itemBuilder: (context, index) {
                          // 💡 Calling the new tile builder
                          return _buildAttendanceLogTile(
                            attendanceStore.reportAttendanceList[index],
                          );
                        },
                      ): const SizedBox.shrink();
                    }
                  ),
                ),
               const AppSectionHeader(title: 'Device Status'),
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
                       const Text(
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

  String? getMemberNameById(int? id) =>
      memberStore.memberList.firstWhereOrNull((m) => m.memberId == id)?.name;

  Widget _buildAttendanceLogTile(AttendanceRecord log) {
    // Format the time using Intl package
    final timeFormatted = DateFormat('hh:mm a').format(log.checkInTime!);
    final dateFormatted = DateFormat('MMM dd').format(log.checkInTime!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AppCard(
        title: '${getMemberNameById(log.memberId)} (ID: ${log.memberId})',
        subtitle: 'Checked In at $timeFormatted',
        leading: Icon(Icons.directions_run, color: AppColors.success, size: 30),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              timeFormatted,
              style: AppTextStyles.subheading.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              dateFormatted,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
