// NEW: Expense List (Mock Data)
 import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/domain/entities/models/bill_payment.dart';
import 'package:finger_print_flutter/presentation/components/app_card.dart';
import 'package:finger_print_flutter/presentation/components/app_dialog.dart';
import 'package:finger_print_flutter/presentation/components/app_empty_state.dart';
import 'package:finger_print_flutter/presentation/components/app_list_tile.dart';
import 'package:finger_print_flutter/presentation/components/app_section_header.dart';
import 'package:finger_print_flutter/presentation/components/app_status_bar.dart';
import 'package:finger_print_flutter/presentation/components/background_wrapper.dart';
import 'package:finger_print_flutter/presentation/expense/store/expense_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/app_button.dart';
class GlobalState {
static List<BillExpense> expenses = [
  BillExpense(id: 2001, category: 'Rent', amount: 50000.00, date: DateTime(2024, 10, 1), description: 'Monthly facility rent'),
  BillExpense(id: 2002, category: 'Salary', amount: 35000.00, date: DateTime(2024, 10, 25), description: 'Trainer salary - October'),
  BillExpense(id: 2003, category: 'Utility', amount: 12500.00, date: DateTime(2024, 10, 15), description: 'Electricity and water bill'),
];

// NEW: Expense CRUD
static void addOrUpdateExpense(BillExpense expense) {
if (expenses.any((e) => e.id == expense.id)) {
final index = expenses.indexWhere((e) => e.id == expense.id);
expenses[index] = expense;
} else {
expenses.add(expense);
}
// Sort by date descending
expenses.sort((a, b) => b.date!.compareTo(a.date!));
}

static void deleteExpense(int id) {
expenses.removeWhere((e) => e.id == id);
}
}

class ExpenseScreen extends StatefulWidget {
  final VoidCallback onUpdate;

  const ExpenseScreen({super.key, required this.onUpdate});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {

  void _showExpenseForm({BillExpense? expense}) {
    showDialog(
      context: context,
      builder: (ctx) => ExpenseFormDialog(
        expense: expense,
        onSave: (e) {
          GlobalState.addOrUpdateExpense(e);
          widget.onUpdate();
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  void _deleteExpense(BillExpense expense) {
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Confirm Deletion',
        message: 'Are you sure you want to delete the expense: ${expense.category} (${NumberFormat.currency(symbol: 'PKR ').format(expense.amount)})?',
        type: AppDialogType.warning,
        actions: [
          AppButton(label: 'Cancel', onPressed: () => Navigator.of(ctx).pop(), variant: AppButtonVariant.secondary),
          AppButton(
            label: 'Delete',
            onPressed: () {
              GlobalState.deleteExpense(expense.id!);
              widget.onUpdate();
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
    final totalExpenses = GlobalState.expenses.fold(0.0, (sum, expense) => sum + expense.amount!);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundWrapper(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionHeader(
                title: 'Gym Expenses',
                trailingWidget: AppButton(
                  label: 'Add New Expense',
                  icon: Icons.add,
                  fullWidth: false,
                  isOutline: true,
                  onPressed: () => _showExpenseForm(),
                  variant: AppButtonVariant.primary,
                ),
              ),
              const SizedBox(height: 16),

              // Total Expenses Card
              AppCard(
                title: 'Total Recorded Expenses',
                subtitle: 'From all time records',
                statusColor: AppColors.danger,
                trailing: Text(
                  NumberFormat.currency(symbol: 'PKR ').format(totalExpenses),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.danger),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
                    ],
                  ),
                  child: GlobalState.expenses.isEmpty
                      ? const AppEmptyState(message: 'No expenses have been recorded yet.', icon: Icons.money_off)
                      : ListView.builder(
                    itemCount: GlobalState.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = GlobalState.expenses[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary),

                          ),
                          child: AppListTile(
                            title: NumberFormat.currency(symbol: 'PKR ').format(expense.amount),
                            subtitle: '${expense.category} - ${expense.description}',
                            leadingIcon: Icons.receipt_long,
                            statusColor: AppColors.primary,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        DateFormat('MMM dd, yyyy').format(expense.date!),
                                        style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)
                                    ),
                                    const SizedBox(height: 8),
                                    AppStatusBadge(label: expense.category!, color: AppColors.textPrimary),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.edit_off_outlined, color: AppColors.primary, size: 24),
                                  onPressed: () => _showExpenseForm(expense: expense),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_outlined, color: AppColors.danger, size: 24),
                                  onPressed: () => _deleteExpense(expense),
                                ),
                              ],
                            ),
                            onTap: () => _showExpenseForm(expense: expense),
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