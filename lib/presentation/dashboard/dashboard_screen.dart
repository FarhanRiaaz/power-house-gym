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

import '../../di/service_locator.dart';


class DashboardScreen extends StatelessWidget {
  final store = getIt<AuthStore>();
      final authStore =getIt<AuthStore>();
    final memberStore =getIt<MemberStore>();
    final attendanceStore =getIt<AttendanceStore>();
    final financeStore =getIt<FinancialStore>();
    final expenseStore =getIt<ExpenseStore>();

   DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundWrapper(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔸 Section Header
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppSectionHeader(
                      title: 'Dashboard',),
                      Row(
                        children: [
                          Observer(
                            builder: (_) => AppStatusBadge(
                              label: authStore.currentUser?.role.name.toUpperCase() ?? 'UNKNOWN',
                              color: AppColors.success,
                            ),
                          ),
                          const SizedBox(width: 12),
                          AppButton(
                            label: 'Logout',
                            icon: Icons.logout,
                            onPressed: () => authStore.logout(),
                            ),
                        ],
                      ),
                  ],
                ),

                const SizedBox(height: 24),

                // 🔸 Quick Actions
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

                // 🔸 Summary Cards
                Observer(
                  builder: (_) => LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 800;
                      final cards = [
                        Expanded(
                          child: AppCard(
                            title: 'Members',
                            subtitle: 'Total Registered',
                            leading: Icon(Icons.group, color: AppColors.primary),
                            trailing:Text("432", style: AppTextStyles.heading) ,
                          ),
                        ),
                        SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 16),
                        Expanded(
                          child: AppCard(
                            title: 'Attendance',
                            subtitle: 'Today\'s Check-ins',
                            trailing: Text("124"),
                            leading: Icon(Icons.access_time),
                          ),
                        ),
                        SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 16),
                        Expanded(
                          child: AppCard(
                            title: 'Finance',
                            subtitle: 'Fees Collected',
                            trailing: Text('Rs. 5200/-'),
                            leading: Icon(Icons.attach_money),
                          ),
                        ),
                      ];
                      return isWide ? Row(children: cards) : Column(children: cards);
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // 🔸 Fingerprint Status
                Observer(
                  builder: (_) => AppCard(
                    title: 'Fingerprint Status',
                    subtitle: 'Last scan result',
                    leading: Icon(Icons.fingerprint),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppStatusBadge(
                          label: "fingerprintStore.lastMatch" ?? 'No match',
                          color: "fingerprintStore.isMatched"=="" ? AppColors.success : AppColors.warning,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Last scanned at Today',
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 🔸 Recent Logs
                const AppSectionHeader(title: 'Recent Activity'),
                const SizedBox(height: 12),
                // Observer(
                //   builder: (_) => Column(
                //     children: attendanceStore.recentLogs.map((log) {
                //       return AppListTile(
                //         title: log.title,
                //         subtitle: log.time,
                //         icon: log.icon,
                //       );
                //     }).toList(),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
