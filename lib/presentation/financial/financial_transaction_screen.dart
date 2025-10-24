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
import 'package:finger_print_flutter/presentation/financial/date_range_widget.dart';
import 'package:finger_print_flutter/presentation/financial/store/financial_store.dart';
import 'package:finger_print_flutter/presentation/member/store/member_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../di/service_locator.dart';
import '../../domain/entities/models/member.dart';
class FinancialTransactionScreen extends StatefulWidget {
  final VoidCallback onUpdate;

  const FinancialTransactionScreen({super.key, required this.onUpdate});

  @override
  State<FinancialTransactionScreen> createState() => _FinancialTransactionScreenState();
}

class _FinancialTransactionScreenState extends State<FinancialTransactionScreen> {

  @override
  void initState() {
    super.initState();
    financialStore.generateRangeReport();
  }

  // Use a local state list to trigger rebuilds on deletion
  final FinancialStore financialStore = getIt<FinancialStore>();
  final MemberStore memberStore = getIt<MemberStore>();

  void _deleteFinancialTransaction(FinancialTransaction transaction) {
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Confirm Deletion',
        message: 'Are you sure you want to delete Transaction ID ${transaction.id}? This action cannot be undone.',
        actions: [
          AppButton(label: 'Cancel', onPressed: () => Navigator.of(ctx).pop(), variant: AppButtonVariant.secondary),
          AppButton(
            label: 'Delete',
            onPressed: () {
              // Perform deletion
              financialStore.deleteTransaction(transaction.id!);
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
          child: Observer(
            builder: (context) {
              final totalBalance = financialStore.reportTransactionsList.fold(0.0, (sum, t) => sum + t.amount!);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  // 1. Header and Balance Summary
                  AppSectionHeader(
                    title: 'Transactions',
                    trailingWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          Text("Import Finance")

                        ],),
                                      )


                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  SizedBox(width: MediaQuery.of(context).size.width*0.35,child:
                  FinanceDateRangeFilterWidget(),),
                  const SizedBox(height: 16),

                  // 2. FinancialTransaction List Container
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Observer(
                        builder: (context) {
                          return financialStore.reportTransactionsList.isEmpty
                              ? const AppEmptyState(message: 'No transactions recorded.', icon: Icons.money_off_csred)
                              : ListView.builder(
                            itemCount: financialStore.reportTransactionsList.length,
                            itemBuilder: (context, index) {
                              final transaction = financialStore.reportTransactionsList[index];
                              final isIncome = transaction.amount! > 0;
                              final statusColor = isIncome ? AppColors.success : AppColors.danger;

                              // Determine the main detail line based on related member
                              String primarySubtitle;
                              if (transaction.relatedMemberId != null) {
                                final memberName = getMemberNameById(transaction.relatedMemberId);
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
                          );
                        }
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
   List<FinancialTransaction> get transactions {
    // Sort transactions by date descending before returning
    financialStore.reportTransactionsList.sort((a, b) => b.transactionDate!.compareTo(a.transactionDate!));
    return financialStore.reportTransactionsList;
  }

   String? getMemberNameById(int? id) {
    if (id == null) return null;
    return memberStore.memberList.firstWhereOrNull((m) => m.memberId == id)?.name;
  }
}