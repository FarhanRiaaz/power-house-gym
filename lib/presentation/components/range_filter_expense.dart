import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/presentation/expense/store/expense_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../di/service_locator.dart';

class DateRangeFilterWidget extends StatelessWidget {
  DateRangeFilterWidget({super.key});

  final ExpenseStore expenseStore = getIt<ExpenseStore>();

  // 1. Show the date picker dialog
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year - 5);
    final DateTime lastDate = DateTime(now.year + 1);

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      barrierColor: Colors.green,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: firstDate,
      lastDate: lastDate,
      // Use the current range or default to a one-month range
      initialDateRange:
          expenseStore.currentFilterRange ??
          DateTimeRange(start: DateTime(now.year, now.month, 10), end: now),
      helpText: 'Select Expense Date Range',
      fieldStartHintText: 'Start Date',
      fieldEndHintText: 'End Date',
      saveText: 'Apply Filter',
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.surface,
              primaryContainer: AppColors.backgroundDark,
              tertiary: AppColors.warning,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: Colors.transparent,
          ),
          child: child!,
        );
      },
    );

    // 2. Update store and trigger data fetch
    if (picked != null) {
      expenseStore.setFilterAndFetch(picked);
    }
  }

  // Function to reset the filter
  void _resetFilter() {
    expenseStore.setFilterAndFetch(null);
  }

  // Formats the selected range for display
  String _getRangeText(DateTimeRange? range) {
    if (range == null) {
      return '';
    }
    final start = DateFormat('MMM dd, yyyy').format(range.start);
    final end = DateFormat('MMM dd, yyyy').format(range.end);
    return 'Filtered: $start to $end';
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final range = expenseStore.currentFilterRange;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.calendar_month,
                      color: AppColors.primary,
                    ),
                    label: Text(
                      range == null ? 'Filter By Date Range' : 'Change Filter',
                      style: const TextStyle(color: AppColors.primary),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                    ),
                    onPressed: () => _selectDateRange(context),
                  ),
                ),
                if (range != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: AppColors.danger),
                      onPressed: _resetFilter,
                      tooltip: 'Clear Filter',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _getRangeText(range),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
