import 'package:finger_print_flutter/core/enum.dart';
import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/core/style/app_text_styles.dart';
import 'package:finger_print_flutter/data/service/biometric/biometric_service_impl.dart';
import 'package:finger_print_flutter/domain/entities/models/attendance_record.dart';
import 'package:finger_print_flutter/domain/entities/models/financial_transaction.dart';
import 'package:finger_print_flutter/presentation/attendance/store/attendance_store.dart';
import 'package:finger_print_flutter/presentation/auth/login_screen.dart';
import 'package:finger_print_flutter/presentation/auth/store/auth_store.dart';
import 'package:finger_print_flutter/presentation/components/app_button.dart';
import 'package:finger_print_flutter/presentation/components/app_card.dart';
import 'package:finger_print_flutter/presentation/components/app_empty_state.dart';
import 'package:finger_print_flutter/presentation/components/app_section_header.dart';
import 'package:finger_print_flutter/presentation/components/app_status_bar.dart';
import 'package:finger_print_flutter/presentation/components/app_toggle.dart';
import 'package:finger_print_flutter/presentation/components/background_wrapper.dart';
import 'package:finger_print_flutter/presentation/dashboard/home.dart';
import 'package:finger_print_flutter/presentation/dashboard/store/dashboard_store.dart';
import 'package:finger_print_flutter/presentation/expense/store/expense_store.dart';
import 'package:finger_print_flutter/presentation/financial/store/financial_store.dart';
import 'package:finger_print_flutter/presentation/member/store/member_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../di/service_locator.dart';
import '../components/metric_card.dart';
import 'dashboard_range_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


  @override
  void initState() {
    HomeScreen.currentReportFilter = authStore.currentUser!.role.toString().contains("female")?Gender.female:Gender.male;
    super.initState();
    _initBiometricTempFile();
  }

  @override
  void didChangeDependencies() {
    _initBiometricTempFile();
    super.didChangeDependencies();
  }

  Future<void> _initBiometricTempFile() async {
    await dashboardStore. fetchDashboardData(range: null);
    await memberStore.getAllStoredFMDID(HomeScreen.currentReportFilter);
    await biometricServiceImpl.getTempFile(memberStore.storedFMDS);}


  // Assume stores are accessible via getIt
  final AuthStore authStore = getIt<AuthStore>();

  final MemberStore memberStore = getIt<MemberStore>();

  final AttendanceStore attendanceStore = getIt<AttendanceStore>();

  final FinancialStore financeStore = getIt<FinancialStore>();

  final ExpenseStore expenseStore = getIt<ExpenseStore>();

  final DashboardStore dashboardStore = getIt<DashboardStore>();

  final BiometricServiceImpl biometricServiceImpl =
      getIt<BiometricServiceImpl>();

  /// Builds a KPI card with responsiveness based on constraints.
  Widget _buildKpiRow({
    required BuildContext context,
    required BoxConstraints constraints,
    required List<Widget> cards,
  }) {
    final isWide = constraints.maxWidth > 1000;
    final wrapSpacing = isWide ? 16.0 : 12.0;
    // Use Wrap for standard desktop/tablet width (2-3 cards wrapping)
    return Wrap(
      spacing: wrapSpacing,
      runSpacing: wrapSpacing,
      children: cards
          .map(
            (card) => SizedBox(
              width:
                  constraints.maxWidth / (constraints.maxWidth > 800 ? 3 : 2) -
                  (wrapSpacing * 1.5),
              child: card,
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSectionHeader(title: 'Dashboard'),
                const SizedBox(height: 24),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: DateRangeFilterWidget(),
                ),
                Observer(
                  builder: (_) {
                    if (dashboardStore.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final cards = [
                          Observer(
                            builder: (_) => AppStatusBadge(
                              label:
                                  authStore.currentUser?.role.name
                                      .toUpperCase() ??
                                  'Super Admin',
                              color: AppColors.primary,
                            ),
                          ),
                          Spacer(),
                          AppButton(
                            fullWidth: false,
                            label: 'Logout',
                            icon: Icons.logout,
                            onPressed: () {
                              authStore.logout();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) =>  LoginScreen()),
                                    (Route<dynamic> route) => false,
                              );

                              },
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
                    Observer(
                      builder: (context) {
                        biometricServiceImpl.isScanning.value;
                        return AppToggle(
                          label: !biometricServiceImpl.isScanning.value
                              ? 'Start Attendance'
                              : 'Stop Attendance',
                          icon: Icons.fingerprint,
                          onChanged: (value) async => {
                            await biometricServiceImpl.getTempFile(memberStore.storedFMDS),
                            biometricServiceImpl.toggleScanning(value),
                          },
                          activeColor: AppColors.success,
                          value: biometricServiceImpl.isScanning.value,
                        );
                      },
                    ),
                    authStore.currentUser?.role==UserRole.superAdmin?
                    AppButton(
                      label: 'Export Data',
                      icon: Icons.download,
                      isOutline: true,
                      fullWidth: false,
                      onPressed: ()async {
                        await dashboardStore.exportData();
                      },
                    ):SizedBox.shrink(),


                  ],
                ),

                const SizedBox(height: 32),
                Observer(
                  builder: (_) {
                    final currency = NumberFormat.currency(
                      locale: 'en_PK',
                      symbol: 'PKR ',
                    );
                    final data = dashboardStore.data;
                    return dashboardStore.data != null
                        ? LayoutBuilder(
                            builder: (context, constraints) {
                              final cards = <Widget>[
                                // KPI 1: Active Check-Ins (Operational)
                                if (hasValue(data?.occupiedHours))
                                  MetricCard(
                                    title: 'Hot Time 🔥',
                                    subtitle: 'Occupied Hours',
                                    icon: Icons.fitness_center_outlined,
                                    iconColor: AppColors.success,
                                    trailingText: data!.occupiedHours!,
                                    trailingColor: AppColors.success,
                                    fontSize: 16,
                                  ),

                                // Active Check-Ins
                                if (hasValue(data?.activeCheckIns))
                                  MetricCard(
                                    title: 'Active Check-Ins',
                                    subtitle: 'Currently in Gym',
                                    icon: Icons.fitness_center,
                                    iconColor: AppColors.success,
                                    trailingText: '${data?.activeCheckIns}',
                                    trailingColor: AppColors.success,
                                    fontSize: 32,
                                  ),

                                // Finance (Today’s Revenue)
                                if (hasValue(data?.todayRevenue) &&  authStore.currentUser?.role==UserRole.superAdmin)
                                  MetricCard(
                                    title: 'Finance',
                                    subtitle:
                                        'Change: ${data?.todayRevenueChange?.toStringAsFixed(2)}%',
                                    icon: Icons.attach_money,
                                    iconColor: AppColors.primary,
                                    trailingText: currency.format(
                                      data?.todayRevenue,
                                    ),
                                    trailingColor:
                                        (data?.todayRevenueChange ?? 0) >= 0
                                        ? AppColors.success
                                        : AppColors.danger,
                                    fontSize: 20,
                                  ),

                                if (hasValue(data?.expense) &&          authStore.currentUser?.role==UserRole.superAdmin)
                                  MetricCard(
                                    title: 'Expense',
                                    subtitle: 'Amount',
                                    icon: Icons.attach_money,
                                    iconColor: AppColors.danger,
                                    trailingText: currency.format(
                                      data?.expense,
                                    ),
                                    trailingColor: (data?.expense ?? 0) >= 0
                                        ? AppColors.success
                                        : AppColors.danger,
                                  ),
                              ];
                              return _buildKpiRow(
                                context: context,
                                constraints: constraints,
                                cards: cards,
                              );
                            },
                          )
                        : AppEmptyState(message: 'No data to show here');
                  },
                ),

                const SizedBox(height: 32),

                // 4. SECONDARY METRICS (Monthly Health & Alerts)
                const AppSectionHeader(title: 'Health & Alerts'),
                const SizedBox(height: 16),

                Observer(
                  builder: (_) {
                    final currency = NumberFormat.currency(
                      locale: 'en_PK',
                      symbol: 'PKR ',
                    );
                    final data = dashboardStore.data;
                    return dashboardStore.data != null
                        ? LayoutBuilder(
                            builder: (context, constraints) {
                              final cards = <Widget>[
                                if (hasValue(data?.newMembersThisWeek))
                                  MetricCard(
                                    title: 'New Members',
                                    subtitle: 'Signed up this week',
                                    icon: Icons.celebration,
                                    iconColor: AppColors.success,
                                    trailingText: '${data?.newMembersThisWeek}',
                                    trailingColor: AppColors.success,
                                  ),

                                // Active Members
                                if (hasValue(data?.activeMemberCount))
                                  MetricCard(
                                    title: 'Active Members',
                                    subtitle: 'Total Registered & Current',
                                    icon: Icons.group,
                                    iconColor: AppColors.textPrimary,
                                    trailingText: '${data?.activeMemberCount}',
                                    trailingColor: AppColors.textSecondary,
                                    fontSize: 32,
                                  ),

                                if (hasValue(data?.attendanceRate))
                                  MetricCard(
                                    title: 'Attendance Rate',
                                    subtitle: 'Last 30 Days Average',
                                    icon: Icons.calendar_month,
                                    iconColor: AppColors.primary,
                                    trailingText:
                                        '${data?.attendanceRate?.toStringAsFixed(1)}%',
                                    trailingColor:
                                        (data?.attendanceRate ?? 0) >= 70
                                        ? AppColors.success
                                        : AppColors.warning,
                                  ),
                                if (hasValue(data?.expiringMembers))
                                  MetricCard(
                                    title: 'Expiring Members',
                                    subtitle: 'Contracts due in 7 days',
                                    icon: Icons.person_off,
                                    iconColor: AppColors.danger,
                                    trailingText: '${data?.expiringMembers}',
                                    trailingColor: AppColors.danger,
                                  ),

                                if (hasValue(data?.lastReceiptId))
                                  MetricCard(
                                    title: 'Overdue',
                                    subtitle: 'Inactive in last 30 days',
                                    icon: Icons.remove_circle_outline_outlined,
                                    iconColor: AppColors.danger,
                                    trailingText: '${data?.lastReceiptId}',
                                    trailingColor: AppColors.danger,
                                  ),
                              ];
                              return _buildKpiRow(
                                context: context,
                                constraints: constraints,
                                cards: cards,
                              );
                            },
                          )
                        : AppEmptyState(message: 'No data to show here');
                  },
                ),
                const SizedBox(height: 32),
                const AppSectionHeader(title: 'Attendance'),

                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: Observer(
                    builder: (context) {
                      return attendanceStore.reportAttendanceList.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  attendanceStore.reportAttendanceList.length,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                // 💡 Calling the new tile builder
                                return _buildAttendanceLogTile(
                                  attendanceStore.reportAttendanceList[index],
                                );
                              },
                            )
                          : AppEmptyState(
                              message: "No attendance records found",
                            );
                    },
                  ),
                ),
                const AppSectionHeader(title: 'Device Status'),
                const SizedBox(height: 16),
                AppCard(
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

  bool hasValue(dynamic value) {
    if (value == null) return false;
    if (value is num) return true; // Numbers are always considered valid
    if (value is String) return value.trim().isNotEmpty;
    return false;
  }
}
