import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/core/style/app_text_styles.dart';
import 'package:finger_print_flutter/core/style/app_theme.dart';
import 'package:finger_print_flutter/presentation/auth/login_screen.dart';
import 'package:finger_print_flutter/presentation/auth/route_manager.dart';
import 'package:finger_print_flutter/presentation/auth/store/auth_store.dart';
import 'package:finger_print_flutter/presentation/dashboard/dashboard_screen.dart';
import 'package:finger_print_flutter/presentation/expense/expense_screen.dart';
import 'package:finger_print_flutter/presentation/financial/financial_transaction_screen.dart';
import 'package:finger_print_flutter/presentation/member/attendance_screen.dart';
import 'package:finger_print_flutter/presentation/member/member_screen.dart';
import 'package:flutter/material.dart';

import '../../di/service_locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
 final AuthStore authStore = getIt<AuthStore>();

  final List<Widget> _screens = [
    DashboardScreen(),
    AttendanceScreen(onUpdate: () {}),
    ManageMemberScreen(),
    FinancialTransactionScreen(onUpdate: () {}),
    ExpenseScreen(onUpdate: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Power House Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: RouteManager.home,
      onGenerateRoute: RouteManager.generateRoute,
      home:
   //   authStore.isAuthenticated?
      Scaffold(
        body: Row(
          children: <Widget>[
            NavigationRail(
              backgroundColor: AppColors.backgroundDark,
              indicatorColor: Colors.white,
              elevation: 4,
              minWidth: 72,
              // The index of the selected item, driven by the state variable
              selectedIndex: _selectedIndex,
              // This is how the state updates when a destination is clicked
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },

              // We want the labels (text) to always show below the icons
              labelType: NavigationRailLabelType.all,

              // Define the items (destinations) in the rail
              destinations: <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
                  indicatorColor: AppColors.primary,
                  label: Text(
                    'Dashboard',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.how_to_reg_outlined),
                  selectedIcon: Icon(
                    Icons.how_to_reg,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    'Attendance',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.sports_martial_arts_outlined),
                  selectedIcon: Icon(
                    Icons.sports_martial_arts,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    'Members',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.monetization_on_outlined),
                  selectedIcon: Icon(
                    Icons.monetization_on,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    'Payments',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.show_chart_outlined),
                  selectedIcon: Icon(
                    Icons.show_chart,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    'Expenses',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],

              // Optional: Header content (e.g., a logo or menu button)
              leading: const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 20.0),
                child: SizedBox(
                  height: 48,
                  width: 48,
                  child: Icon(
                    Icons.fitness_center_outlined,
                    size: 48,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
                switchInCurve: Curves.easeOutCubic,
                // Display the screen widget corresponding to the selected index
                child: _screens[_selectedIndex],
              ),
            ),
          ],
        ),
      )

        //  :LoginScreen(),
    );
  }
}
