// NEW: Expense List (Mock Data)
 import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/data/di/data_layer_injection.dart';
import 'package:finger_print_flutter/domain/entities/models/bill_payment.dart';
import 'package:finger_print_flutter/presentation/components/app_card.dart';
import 'package:finger_print_flutter/presentation/components/app_dialog.dart';
import 'package:finger_print_flutter/presentation/components/app_empty_state.dart';
import 'package:finger_print_flutter/presentation/components/app_list_tile.dart';
import 'package:finger_print_flutter/presentation/components/app_section_header.dart';
import 'package:finger_print_flutter/presentation/components/app_status_bar.dart';
import 'package:finger_print_flutter/presentation/components/background_wrapper.dart';
import 'package:finger_print_flutter/presentation/expense/store/expense_dialog.dart';
import 'package:finger_print_flutter/presentation/expense/store/expense_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../components/app_button.dart';

class ExpenseScreen extends StatefulWidget {
  final VoidCallback onUpdate;

  const ExpenseScreen({super.key, required this.onUpdate});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final ExpenseStore expenseStore = getIt<ExpenseStore>();

  void _showExpenseForm({BillExpense? expense}) {
    showDialog(
      context: context,
      builder: (ctx) => ExpenseFormDialog(
        expense: expense,
        onSave: (e) async {
          await addOrUpdateExpense(e);
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
              expenseStore.deleteExpense(expense.id!);
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
                trailing: Observer(
                  builder: (context) {
                    final totalExpenses = expenseStore.reportExpensesList.fold(0.0, (sum, expense) => sum + expense.amount!);

                    return Text(
                      NumberFormat.currency(symbol: 'PKR ').format(totalExpenses),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.danger),
                    );
                  }
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
                    ],
                  ),
                  child: Observer(
                    builder: (context) {
                      return expenseStore.reportExpensesList.isEmpty
                          ? const AppEmptyState(message: 'No expenses have been recorded yet.', icon: Icons.money_off)
                          : ListView.builder(
                        itemCount: expenseStore.reportExpensesList.length,
                        itemBuilder: (context, index) {
                          final expense = expenseStore.reportExpensesList[index];

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
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   Future<void> addOrUpdateExpense(BillExpense expense) async {
    if (expenseStore.reportExpensesList.any((e) => e.id == expense.id)) {
      final index = expenseStore.reportExpensesList.indexWhere((e) => e.id == expense.id);
      expenseStore.reportExpensesList[index] = expense;
       await expenseStore.updateExpense(expense);
    } else {
     await expenseStore.recordExpense(expense);
    }
// Sort by date descending
     expenseStore.reportExpensesList.sort((a, b) => b.date!.compareTo(a.date!));
  }

}