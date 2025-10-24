import 'package:finger_print_flutter/data/di/data_layer_injection.dart';
import 'package:finger_print_flutter/domain/usecases/financial/financial_usecase.dart';
import 'package:finger_print_flutter/presentation/dashboard/store/dashboard_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../core/style/app_colors.dart';

class DateRangeFilterWidget extends StatelessWidget {
  final DashboardStore dashboardStore = getIt<DashboardStore>();

   DateRangeFilterWidget({super.key});

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year - 5);
    final DateTime lastDate = DateTime(now.year + 1);

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: DateTimeRange(start: dashboardStore.currentFilterRange!.start, end: dashboardStore.currentFilterRange!.end),
      helpText: 'Select Data Range',
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
            ), dialogTheme: DialogThemeData(backgroundColor: Colors.transparent),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dashboardStore.setFilterAndFetch(DateRangeParams(start: picked.start, end: picked.end));
    }
  }

  void _resetFilter() {
    dashboardStore.setFilterAndFetch(null);
  }

  String _getRangeText(DateTimeRange? range) {
    if (range == null) {
      return 'Showing All Records (No date filter applied)';
    }
    final start = DateFormat('MMM dd, yyyy').format(range.start);
    final end = DateFormat('MMM dd, yyyy').format(range.end);
    return 'Filtered: $start to $end';
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final range = dashboardStore.currentFilterRange;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_month, color: AppColors.primary),
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
              _getRangeText(DateTimeRange(start: range!.start, end: range.end)),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}