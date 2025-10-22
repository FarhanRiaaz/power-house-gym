// Global Member List and State Management Mock
import 'package:finger_print_flutter/core/list_to_csv_converter.dart';
import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/domain/entities/models/financial_transaction.dart';
import 'package:finger_print_flutter/presentation/components/app_button.dart';
import 'package:finger_print_flutter/presentation/components/app_dialog.dart';
import 'package:finger_print_flutter/presentation/components/app_empty_state.dart';
import 'package:finger_print_flutter/presentation/components/app_list_tile.dart';
import 'package:finger_print_flutter/presentation/components/app_section_header.dart';
import 'package:finger_print_flutter/presentation/components/app_status_bar.dart';
import 'package:finger_print_flutter/presentation/components/background_wrapper.dart';
import 'package:finger_print_flutter/presentation/financial/store/financial_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../di/service_locator.dart';
import '../../domain/entities/models/member.dart';

class GlobalState {
  // Mock Members (Needed to resolve relatedMemberId)
  static List<Member> members = [
    Member(memberId: 1001, name: 'Ahmed Khan'),
    Member(memberId: 1002, name: 'Fatima Ali'),
    Member(memberId: 1003, name: 'Usman Sharif'),
  ];

  // Internal Mock FinancialTransaction Source (Ensuring at least 7 transactions)
  static final List<FinancialTransaction> _mockFinancialTransactions = [
    // Income/Fee Payments (Positive amount)
    FinancialTransaction(id: 3001, type: 'Fee Payment', amount: 5000.00, transactionDate: DateTime(2024, 10, 15), description: 'Monthly fee paid by Ahmed Khan', relatedMemberId: 1001),
    FinancialTransaction(id: 3002, type: 'Fee Payment', amount: 7500.00, transactionDate: DateTime(2024, 10, 21), description: 'Annual membership fee', relatedMemberId: 1003),
    FinancialTransaction(id: 3003, type: 'Fee Payment', amount: 55000.00, transactionDate: DateTime(2024, 9, 28), description: 'September fee - Fatima Ali', relatedMemberId: 1002),

    // Expenses (Negative amount)
    FinancialTransaction(id: 3004, type: 'Expense', amount: 50000.00, transactionDate: DateTime(2024, 10, 1), description: 'Monthly facility rent'),
    FinancialTransaction(id: 3005, type: 'Expense', amount: 35000.00, transactionDate: DateTime(2024, 10, 25), description: 'Trainer salary - October'),
    FinancialTransaction(id: 3006, type: 'Bill', amount: -12500.00, transactionDate: DateTime(2024, 10, 10), description: 'Electricity and water bill'),
    FinancialTransaction(id: 3007, type: 'Expense', amount: -5000.00, transactionDate: DateTime(2024, 10, 20), description: 'New set of weights'),
  ];

  static List<FinancialTransaction> get transactions {
    // Sort transactions by date descending before returning
    _mockFinancialTransactions.sort((a, b) => b.transactionDate!.compareTo(a.transactionDate!));
    return _mockFinancialTransactions;
  }

  static void deleteFinancialTransaction(int id) {
    _mockFinancialTransactions.removeWhere((t) => t.id == id);
  }

  static String? getMemberNameById(int? id) {
    if (id == null) return null;
    return members.firstWhereOrNull((m) => m.memberId == id)?.name;
  }
}

// -----------------------------------------------------------------------------
// TRANSACTION SCREEN IMPLEMENTATION
// -----------------------------------------------------------------------------

class FinancialTransactionScreen extends StatefulWidget {
  final VoidCallback onUpdate;

  const FinancialTransactionScreen({super.key, required this.onUpdate});

  @override
  State<FinancialTransactionScreen> createState() => _FinancialTransactionScreenState();
}

class _FinancialTransactionScreenState extends State<FinancialTransactionScreen> {
  // Use a local state list to trigger rebuilds on deletion
  List<FinancialTransaction> _currentFinancialTransactions = GlobalState.transactions;
  final FinancialStore financialStore = getIt<FinancialStore>();
  void _deleteFinancialTransaction(FinancialTransaction transaction) {
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Confirm Deletion',
        message: 'Are you sure you want to delete FinancialTransaction ID ${transaction.id}? This action cannot be undone.',
        actions: [
          AppButton(label: 'Cancel', onPressed: () => Navigator.of(ctx).pop(), variant: AppButtonVariant.secondary),
          AppButton(
            label: 'Delete',
            onPressed: () {
              // Perform deletion
              GlobalState.deleteFinancialTransaction(transaction.id!);
              // Update local state to force UI rebuild
              setState(() {
                _currentFinancialTransactions = GlobalState.transactions;
              });
              Navigator.of(ctx).pop();
            },
            variant: AppButtonVariant.danger,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalBalance = _currentFinancialTransactions.fold(0.0, (sum, t) => sum + t.amount!);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundWrapper(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
        
              // 1. Header and Balance Summary
              AppSectionHeader(
                title: 'Transactions',
                trailingWidget: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: totalBalance >= 0 ? AppColors.success.withOpacity(0.1) : AppColors.danger.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: totalBalance >= 0 ? AppColors.success : AppColors.danger),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('NET BALANCE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                          Text(
                            NumberFormat.currency(symbol: 'PKR ').format(totalBalance),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: totalBalance >= 0 ? AppColors.success : AppColors.warning
                            ),
                          ),
                        ],
                      ),
                    ),
                 
                       GestureDetector(
                             onTap: () async {
                      try {
                        final filePath = await SimpleCsvConverter().pickExcelFile();
                    
                        final csvData = await SimpleCsvConverter().readCsvFile(filePath);
                        await financialStore.importDataToDatabase(csvData);
                      } catch (e) {
                        print('Import failed: $e');
                        // Optionally show a dialog or snackbar here
                      }
                    }
                    ,
                    child: Row(children: [
                      Icon(Icons.import_contacts_outlined),
                      SizedBox(width: 16,),
                      Text("Import Attendance")
                    
                    ],),
                                  )
                    

                  ],
                ),
              ),
              const SizedBox(height: 16),
        
              // 2. FinancialTransaction List Container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: _currentFinancialTransactions.isEmpty
                      ? const AppEmptyState(message: 'No transactions recorded.', icon: Icons.money_off_csred)
                      : ListView.builder(
                    itemCount: _currentFinancialTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _currentFinancialTransactions[index];
                      final isIncome = transaction.amount! > 0;
                      final statusColor = isIncome ? AppColors.success : AppColors.danger;
        
                      // Determine the main detail line based on related member
                      String primarySubtitle;
                      if (transaction.relatedMemberId != null) {
                        final memberName = GlobalState.getMemberNameById(transaction.relatedMemberId);
                        primarySubtitle = 'Member: ${memberName ?? 'ID ${transaction.relatedMemberId}'}';
                      } else {
                        // For expenses/bills, use the description or category
                        primarySubtitle = '${transaction.type}: ${transaction.description}';
                      }
        
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary),
        
                          ),
                          child: AppListTile(
                            // Show the absolute amount with color coding
                            title: NumberFormat.currency(symbol: 'PKR ').format(transaction.amount!.abs()),
                            subtitle: primarySubtitle,
                            leadingIcon: isIncome ? Icons.trending_up : Icons.trending_down,
                            statusColor: statusColor,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Show the transaction date
                                    Text(
                                        DateFormat('MMM dd, yyyy').format(transaction.transactionDate!),
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)
                                    ),
                                    const SizedBox(height: 4),
                                    // Show the transaction type badge
                                    AppStatusBadge(label: transaction.type!.toUpperCase(), color: statusColor),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                // Delete Option
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 24),
                                  tooltip: 'Delete FinancialTransaction',
                                  onPressed: () => _deleteFinancialTransaction(transaction),
                                ),
                              ],
                            ),
                          ),
                        ),
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
}