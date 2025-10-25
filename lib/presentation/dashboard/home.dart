import 'package:finger_print_flutter/core/enum.dart';
import 'package:finger_print_flutter/core/printing/print_service.dart';
import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/core/style/app_text_styles.dart';
import 'package:finger_print_flutter/core/style/app_theme.dart';
import 'package:finger_print_flutter/data/service/biometric/biometric_service_impl.dart';
import 'package:finger_print_flutter/domain/entities/models/scan_status.dart';
import 'package:finger_print_flutter/presentation/attendance/store/attendance_store.dart';
import 'package:finger_print_flutter/presentation/auth/login_screen.dart';
import 'package:finger_print_flutter/presentation/auth/store/auth_store.dart';
import 'package:finger_print_flutter/presentation/components/app_button.dart';
import 'package:finger_print_flutter/presentation/components/app_dialog.dart';
import 'package:finger_print_flutter/presentation/dashboard/dashboard_screen.dart';
import 'package:finger_print_flutter/presentation/expense/expense_screen.dart';
import 'package:finger_print_flutter/presentation/financial/financial_transaction_screen.dart';
import 'package:finger_print_flutter/presentation/financial/store/financial_store.dart';
import 'package:finger_print_flutter/presentation/member/attendance_screen.dart';
import 'package:finger_print_flutter/presentation/member/member_screen.dart';
import 'package:finger_print_flutter/presentation/member/store/member_store.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../di/service_locator.dart';
import '../../domain/entities/models/attendance_record.dart';
import '../../domain/entities/models/financial_transaction.dart';
import '../../domain/entities/models/member.dart';

class HomeScreen extends StatefulWidget {
  static Gender currentReportFilter = Gender.male;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDialogVisible = false;
  int _selectedIndex = 0;
  final AuthStore authStore = getIt<AuthStore>();
  final ReceiptService receiptService = ReceiptService();
  final AttendanceStore attendanceStore = getIt<AttendanceStore>();
  final FinancialStore financialStore = getIt<FinancialStore>();
  final MemberStore memberStore = getIt<MemberStore>();

  final BiometricServiceImpl biometricServiceImpl =
      getIt<BiometricServiceImpl>();

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
      home: authStore.isAuthenticated
          ? Scaffold(
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
                        selectedIcon: Icon(
                          Icons.dashboard,
                          color: AppColors.primary,
                        ),
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
                      if (authStore.currentUser?.role == UserRole.superAdmin)
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
                      if (authStore.currentUser?.role == UserRole.superAdmin)
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
          : LoginScreen(),
    );
  }

  void _handleScanResult(Map<String, dynamic> result) {
    if (_isDialogVisible) return; // Avoid multiple popups

    String title = "";
    String message = "";
    AppDialogType type = AppDialogType.info;
    bool keepOpen = false;
    bool showRegister = false;
    Function? onConfirm;

    switch (result['status']) {
      case ScanStatus.matchSuccess:
        title = "Attendance Marked";
        message = "Welcome back, ${result['name']}! Your attendance has been successfully recorded.";
        type = AppDialogType.success;
        break;

      case ScanStatus.matchFeeOverdue:
        title = "Fee Overdue";
        message = "Hello ${result['name']}, your membership fee is overdue.\nPlease clear the dues to continue.";
        type = AppDialogType.warning;
        final memberId = result['data'] as int;
        keepOpen = true; // Don’t close automatically
        break;

      case ScanStatus.notRecognized:
        title = "Unrecognized Fingerprint";
        message = "This fingerprint doesn’t match any registered member.\nWould you like to register this user?";
        type = AppDialogType.info;
        showRegister = true;

        final fmdBase64 = result['data'] as String;
        onConfirm = () {
         setState(() {
           _selectedIndex=2;
         });
        };
        break;

      case ScanStatus.errorIntegrity:
        title = "Data Integrity Issue";
        message = "Fingerprint ID matched on the device but not in the database.\nPlease verify your records.";
        type = AppDialogType.error;
        break;

      default:
        return; // Ignore non-critical statuses like NO_FINGER
    }

    _isDialogVisible = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AppDialog(
          title: title,
          message: message,
          type: type,
          actions: [
            if (showRegister)
              AppButton(
                label: 'Register User',
                icon: Icons.person_add,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  setState(() => _isDialogVisible = false);
                  onConfirm?.call();
                },
                variant: AppButtonVariant.primary,
              ),
            AppButton(
              label: keepOpen ? 'Pay Fee' : 'OK',
              icon: keepOpen ? Icons.payment : Icons.check_circle,
              variant: keepOpen
                  ? AppButtonVariant.danger
                  : AppButtonVariant.primary,
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                if (!keepOpen) {
                  // Close dialog automatically only for successful scan
                  setState(() => _isDialogVisible = false);
                }else{
                  final memberId = result['data'] as int;
                final member= await memberStore.findMemberById(memberId);
                 await _payFee(member??Member());

                }

                // For fee overdue, you can trigger your pay function here later
              },
            ),
          ],
        );
      },
    ).then((_) {
      if (_isDialogVisible && !keepOpen) {
        setState(() => _isDialogVisible = false);
      }
    });
  }


  @override
  void initState() {
    super.initState();
    reaction((_) => biometricServiceImpl.lastScanResult.value, (result) {
      if (result != null && result['status'] != ScanStatus.noFinger) {
        _handleScanResult(result);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // MobX Reaction: This runs every time lastScanResult changes and is not null.
    // This is the ideal place to trigger UI changes based on service results.
    reaction((_) => biometricServiceImpl.lastScanResult.value, (result) {
      if (result != null && result['status'] != ScanStatus.noFinger) {
        _handleScanResult(result);
      }
    });
  }

  Future<void> _payFee(Member member) async {
    memberStore.selectedMember!.copyWith(
      name: member.name,
      phoneNumber: member.phoneNumber,
      fatherName: member.fatherName,
      gender: member.gender,
      lastFeePaymentDate: DateTime.now(),
      membershipType: member.membershipType,
      fingerprintTemplate: member.fingerprintTemplate,
      notes: member.notes,
    );
    financialStore.newTransaction.copyWith(
      type: "Fee Payment",
      amount:
      member.membershipType!.name.contains("cardio") ||
          member.membershipType!.name.contains("CARDIO")
          ? 2500.0
          : 1000.0,
      transactionDate: DateTime.now(),
      relatedMemberId: member.memberId,
    );

    await processFeePayment(member);
  }

  /// Executes the fee payment process, updates the database, and shows a success dialog.
  Future<void> processFeePayment(Member member) async {
    if (member.memberId == null) {
      _showAppDialog(
        context,
        'Error',
        'Cannot process payment: Member ID is missing.',
        AppDialogType.error,
        member,
      );
      return;
    }

    try {
      // 1. Database/API Call: Execute the transaction record operation.
      // This is the line you provided:
      memberStore.selectedMember!.copyWith(lastFeePaymentDate: DateTime.now());
      await memberStore.updateMember(member);
      await financialStore.recordTransaction(
        FinancialTransaction(
          type: "Fee Payment",
          amount:
          member.membershipType!.name.contains("cardio") ||
              member.membershipType!.name.contains("CARDIO")
              ? 2500.0
              : 1000.0,
          transactionDate: DateTime.now(),
          description: "Fee Payment",
          relatedMemberId: member.memberId,
        ),
      );
      // 2. UI Notification: Show the success dialog after the database call completes.
      // This is the line you provided:
      _showAppDialog(
        context,
        'Payment Successful',
        'Fee payment for ${member.name ?? 'a member'} has been processed.',
        AppDialogType.success,
        member,
      );
    } catch (e) {
      // Handle potential errors during the database transaction
      _showAppDialog(
        context,
        'Payment Failed',
        'An error occurred while processing the payment for ${member.name}. Error: $e',
        AppDialogType.error,
        member,
      );
    }
  }
  void _showAppDialog(
      BuildContext context,
      String title,
      String content,
      AppDialogType type,
      Member member,
      ) {
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: title,
        message: content,
        type: type,
        actions: [
          AppButton(
            label: title == "Payment Successful" ? 'Print Receipt' : 'Close',
            onPressed: () async {
              if (title == "Payment Successful") {
                await receiptService.generateAndPrintReceipt(
                  params: FinancialTransaction(
                    type: member.membershipType!.name,
                    amount:
                    member.membershipType!.name.contains('cardio') ||
                        member.membershipType!.name.contains("CARDIO")
                        ? 2500.0
                        : 1000.0,
                    transactionDate: DateTime.now(),
                    description: "Membership renewal",
                    relatedMemberId: member.memberId,
                  ),
                  percentage:
                  AttendanceRecord.calculateMonthlyAttendancePercentage(
                    attendanceStore.singleAttendanceList,
                    member.memberId!,
                  ),
                  userName: member.name,
                );
                Navigator.of(ctx).pop();
              } else {
                Navigator.of(ctx).pop();
              }
            },
            isOutline: true,
            variant: title == "Payment Successful"
                ? AppButtonVariant.danger
                : AppButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
