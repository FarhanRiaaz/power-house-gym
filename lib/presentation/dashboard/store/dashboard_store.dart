import 'package:finger_print_flutter/core/enum.dart';
import 'package:finger_print_flutter/data/service/biometric/biometric_service.dart';
import 'package:finger_print_flutter/domain/entities/models/attendance_record.dart';
import 'package:finger_print_flutter/domain/entities/models/bill_payment.dart';
import 'package:finger_print_flutter/domain/entities/models/dashboard.dart';
import 'package:finger_print_flutter/domain/entities/models/financial_transaction.dart';
import 'package:finger_print_flutter/domain/usecases/attendance/log_attendance_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/bill/bill_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/financial/financial_usecase.dart';
import 'package:finger_print_flutter/domain/usecases/member/member_usecase.dart';

import 'package:mobx/mobx.dart';

import '../../../domain/entities/models/member.dart';

part 'dashboard_store.g.dart';

class DashboardStore = _DashboardStore with _$DashboardStore;

abstract class _DashboardStore with Store {
  // --- Dependencies (Use Cases) ---
  final GetBillsByDateRangeUseCase _getRangeReportUseCase;
  final GetAttendanceRecordUseCase _getAttendanceRecordUseCase;
  final GetTransactionsByDateRangeUseCase _getRangeReportFinanceUseCase;
  final GetAllMembersUseCase _getAllMembersUseCase;

  _DashboardStore(
    this._getRangeReportUseCase,
    this._getAttendanceRecordUseCase,
    this._getRangeReportFinanceUseCase,
    this._getAllMembersUseCase,
  ) {
    fetchDashboardData(range: null);
  }

  // --- Store State Variables ---
  @observable
  bool isLoading = false;

  @observable
  DashboardData? _data = DashboardData();

  @observable
  Gender gender = Gender.male;

  @observable
  DateRangeParams? _currentFilterRange = DateRangeParams(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @observable
  ObservableList<Member> memberList = ObservableList();
  @observable
  ObservableList<AttendanceRecord> singleAttendanceList = ObservableList();

  @observable
  ObservableList<FinancialTransaction> allTransactionsList = ObservableList();

  @observable
  ObservableList<BillExpense> allExpensesList = ObservableList();

  @computed
  DashboardData? get data => _data;

  @computed
  DateRangeParams? get currentFilterRange => _currentFilterRange;

  // --- Actions ---

  void setFilterAndFetch(DateRangeParams? range) {
    _currentFilterRange = range;
    fetchDashboardData(range: range);
  }

  Future<List<T>> select<T>(T table, DateRangeParams? range) async {
    if (table is Member) {
      return await _getAllMembersUseCase.call(params: gender) as List<T>;
    } else if (table is FinancialTransaction) {
      final filteredTransactions = await (_getRangeReportFinanceUseCase.call(
        params:
            range ??
            DateRangeParams(start: DateTime.now(), end: DateTime.now()),
      ));
      filteredTransactions.where((t) {
        if (range == null) return true;
        final tTime = t.transactionDate;
        return tTime!.isAfter(range.start.subtract(const Duration(days: 1))) &&
            tTime.isBefore(range.end.add(const Duration(days: 1)));
      }).toList();
      return filteredTransactions as List<T>;
    } else if (table is BillExpense) {
      final filteredExpenses = await _getRangeReportUseCase.call(
        params:
            range ??
            DateRangeParams(start: DateTime.now(), end: DateTime.now()),
      );

      filteredExpenses.where((e) {
        if (range == null) return true;
        final eTime = e.date;
        return eTime!.isAfter(range.start.subtract(const Duration(days: 1))) &&
            eTime.isBefore(range.end.add(const Duration(days: 1)));
      }).toList();
      return filteredExpenses as List<T>;
    } else if (table is AttendanceRecord) {
      final filteredRecords = await _getAttendanceRecordUseCase.call(
        params: null,
      );
      filteredRecords.where((a) {
        if (range == null) return true;
        final aTime = a.checkInTime;
        return aTime!.isAfter(range.start.subtract(const Duration(days: 1))) &&
            aTime.isBefore(range.end.add(const Duration(days: 1)));
      }).toList();
      return filteredRecords as List<T>;
    }
    return [] as List<T>;
  }

  // --- CORE DATA FETCHING ACTION using Drift Logic ---
  @action
  Future<void> fetchDashboardData({DateRangeParams? range}) async {
    isLoading = true;
    try {
      // --- 1. DEFINE DATE CONSTRAINTS ---
      // Use the provided range for filtering transactions and check-ins
      final start = range?.start;
      final endInclusive = range?.end.endOfDay();

      // Calculate previous period for change metrics (defaulting to 30 days)
      final periodDuration = (endInclusive ?? DateTime.now()).difference(
        start ?? DateTime.now().subtract(const Duration(days: 30)),
      );
      final previousEnd =
          start ?? DateTime.now().subtract(const Duration(days: 30));
      final previousStart = previousEnd.subtract(periodDuration);

      // Function to calculate sum for a given range (current and previous)
      Future<double> calculateRevenue(DateTime? s, DateTime? e) async {
        // This simulates a DRIFT query:
        // final revenueQuery = select(_db.financialTransactions).where((t) => t.transactionDate.isBetween(s, e) & t.type.equals('Fee Payment'));
        // return await revenueQuery.get().then((list) => list.fold(0.0, (sum, row) => sum + row.amount));

        final transactions = await select<FinancialTransaction>(
          FinancialTransaction(),
          range,
        );
        final filtered = transactions.where((t) {
          final tTime = t.transactionDate;
          return t.type == 'Fee Payment' &&
              (s == null || tTime!.isAfter(s)) &&
              (e == null || tTime!.isBefore(e));
        });
        return filtered.fold<double>(0.0, (double sum, t) => sum + t.amount!);
      }

      Future<double> calculateExpense(DateTime? s, DateTime? e) async {
        // This simulates a DRIFT query:
        // final expenseQuery = select(_db.billExpenses).where((e) => e.date.isBetween(s, e));
        // return await expenseQuery.get().then((list) => list.fold(0.0, (sum, row) => sum + row.amount));

        final expenses = await select<BillExpense>(BillExpense(), range);
        final filtered = expenses.where((exp) {
          final eTime = exp.date;
          return (s == null || eTime!.isAfter(s)) &&
              (e == null || eTime!.isBefore(e));
        });
        return filtered.fold<double>(0.0, (double sum, t) => sum + t.amount!);
      }

      // Fetch Current Period Data
      final monthlyRevenue = await calculateRevenue(start, endInclusive);
      final totalExpense = await calculateExpense(start, endInclusive);

      // Fetch Previous Period Data for Change Calculation
      final prevMonthlyRevenue = await calculateRevenue(
        previousStart,
        previousEnd,
      );

      // Calculate daily revenue and previous day revenue (simplified by using the current range for all)
      final todayRevenue = await calculateRevenue(
        DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0),
        DateTime.now().endOfDay(),
      );
      final prevTodayRevenue = await calculateRevenue(
        DateTime.now().subtract(const Duration(days: 1)).copyWith(hour: 0),
        DateTime.now().subtract(const Duration(days: 1)).endOfDay(),
      );

      // Helper function for percentage change
      double getChange(double current, double previous) {
        if (previous == 0) return current > 0 ? 100.0 : 0.0;
        return ((current - previous) / previous) * 100.0;
      }

      final todayRevenueChange = getChange(todayRevenue, prevTodayRevenue);
      final monthlyRevenueChange = getChange(
        monthlyRevenue,
        prevMonthlyRevenue,
      );

      // Operational detail mock
      final lastReceiptId =
          'T-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

      // --- 3. MEMBERSHIP & ENGAGEMENT METRICS (Drift Query Logic) ---

      final allMembers = await select<Member>(Member(), null);
      final totalMemberCount = allMembers.length;

      final now = DateTime.now();

      // Active members: checked in the last 30 days
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));
      final allAttendance = await select<AttendanceRecord>(
        AttendanceRecord(),
        null,
      );
      final activeMemberIds = allAttendance
          .where((a) => a.checkInTime!.isAfter(thirtyDaysAgo))
          .map((a) => a.memberId)
          .toSet();
      final activeMemberCount = activeMemberIds.length;

      final inactiveMemberCount = allMembers.where((m) {
        // Check if the member's ID is NOT contained in the set of recently active IDs.
        // This effectively finds everyone who hasn't shown up in 30 days.
        return !activeMemberIds.contains(m.memberId);
      }).length;

      // New members this week: registered in last 7 days
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      // Drift Query: select(db.members).where((m) => m.registrationDate.isAfter(sevenDaysAgo));
      final newMembersThisWeek = allMembers
          .where((m) => m.registrationDate!.isAfter(sevenDaysAgo))
          .length;

      // Expiring members: lastFeePaymentDate + 30 days is near today (1 day left for completing month)
      final tomorrow = now.add(const Duration(days: 1));
      // Drift Query: select(db.members).where((m) => m.lastFeePaymentDate.date.plus(30).isBetween(today, tomorrow));
      final expiringMembers = allMembers.where((m) {
        final expiryDate = m.lastFeePaymentDate!.add(const Duration(days: 30));
        return expiryDate.isBetween(now, tomorrow);
      }).length;


      // Attendance Rate: (Active Members / Total Members) * 100
      final attendanceRate = totalMemberCount > 0
          ? (activeMemberCount / totalMemberCount) * 100.0
          : 0.0;

      // --- 4. OPERATIONAL METRICS (Drift Query Logic) ---

      // Active Check-Ins (Currently checked in)
      // Drift Query: select(db.attendanceRecords).where((a) => a.checkOutTime.isNull() & a.checkInTime.isAfter(3.hours.ago));
      final activeCheckIns = allAttendance
          .where(
            (a) =>
                a.checkInTime!.isAfter(now.subtract(const Duration(hours: 3))),
          )
          .length;

      // Occupied Hours (Most busy hours)
      // This is a complex GROUP BY query (SQL: SELECT strftime('%H', checkInTime) AS hour, COUNT(id) FROM AttendanceRecords GROUP BY hour ORDER BY COUNT(id) DESC LIMIT 1)
      final hourCounts = <int, int>{};
      for (var record in allAttendance) {
        final hour = record.checkInTime!.hour;
        hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
      }
      final mostBusyHour = hourCounts.entries.fold(
        -1,
        (prev, e) => e.value > (hourCounts[prev] ?? 0) ? e.key : prev,
      );
      final occupiedHours = mostBusyHour != -1
          ? '${mostBusyHour.toString().padLeft(2, '0')}:00 - ${(mostBusyHour + 1).toString().padLeft(2, '0')}:00'
          : 'N/A';

      // --- 5. AGGREGATE AND UPDATE DATA ---

      _data = DashboardData(
        // Operational
        activeCheckIns: activeCheckIns,
        lastReceiptId: inactiveMemberCount.toString(),
        occupiedHours: occupiedHours,

        // Financial
        expense: totalExpense,
        todayRevenue: todayRevenue,
        todayRevenueChange: todayRevenueChange,
        monthlyRevenue: monthlyRevenue,
        monthlyRevenueChange: monthlyRevenueChange,

        // Membership/Engagement
        totalMemberCount: totalMemberCount,
        activeMemberCount: activeMemberCount,
        attendanceRate: attendanceRate,
        newMembersThisWeek: newMembersThisWeek,
        expiringMembers: expiringMembers,
      );
    } catch (e) {
      print('Error fetching dashboard data: $e');
      _data = DashboardData();
    } finally {
      isLoading = false;
    }
  }
}
