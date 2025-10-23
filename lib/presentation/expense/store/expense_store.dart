import 'package:finger_print_flutter/domain/usecases/bill/bill_usecase.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../domain/entities/models/bill_payment.dart';
import '../../../domain/usecases/financial/financial_usecase.dart';

part 'expense_store.g.dart';

class ExpenseStore = _ExpenseStore with _$ExpenseStore;

abstract class _ExpenseStore with Store {
  // --- Dependencies (Use Cases) ---
  final InsertBillExpenseUseCase _insertBillExpenseUseCase;
  final WatchAllExpensesUseCase _watchAllExpensesUseCase;
  final GetBillsByDateRangeUseCase _getRangeReportUseCase;
  final DeleteBillExpenseUseCase _deleteBillExpenseUseCase;
  final UpdateExpenseUseCase _updateExpenseUseCase;

  _ExpenseStore(
      this._insertBillExpenseUseCase,
      this._watchAllExpensesUseCase,
      this._getRangeReportUseCase,
      this._deleteBillExpenseUseCase,
      this._updateExpenseUseCase
      );

  // --- Store State Variables ---

  // Reactive list for a central dashboard view
  @observable
  Stream<List<BillExpense>> allExpensesStream = Stream.value(const []);

  @observable
  ObservableList<BillExpense> allExpensesList = ObservableList();

  // For report generation
  @observable
  ObservableList<BillExpense> reportExpensesList = ObservableList();


  @observable
  DateTime reportStartDate = DateTime.now().subtract(const Duration(days: 30));


  @observable
  DateTime reportEndDate = DateTime.now();

  List<BillExpense> _filteredExpenses = [];

  void setFilterAndFetch(DateTimeRange? range) async {
    _currentFilterRange = range;
    reportStartDate = range?.start?? DateTime.now();
    reportEndDate = range?.end?? DateTime.now();

   await generateRangeReport();
  }

  // MobX Observable for the filter range (important for UI update)
  DateTimeRange? _currentFilterRange;
  DateTimeRange? get currentFilterRange => _currentFilterRange;
  // For form input
  @observable
  BillExpense newExpense = BillExpense(
    category: 'Rent',
    amount: 0.0,
    date: DateTime.now(),
    description: '',
  );

  @observable
  bool isLoadingReport = false;

  // --- Computed Values ---

  @computed
  bool get isLoading => isLoadingReport;

  @computed
  double get totalExpensesInReport {
    return reportExpensesList.fold(
      0.0,
          (sum, expense) => sum + expense.amount!,
    );
  }

  // --- Actions (Mutations and Data Fetching) ---

  /// Subscribes to all bill expenses for real-time updates.
  @action
  void watchAllExpenses() {
    // Set up the stream subscription
    _watchAllExpensesUseCase.call(params: null).then((stream) {
      allExpensesStream = stream;

      allExpensesStream.listen((list) {
        runInAction(() {
          allExpensesList = ObservableList.of(list);
        });
      });
    }).catchError((error) {
      runInAction(() {
        print("Error setting up expense stream: $error");
      });
    });
  }

  /// Records a new bill or expense.
  @action
  Future<BillExpense?> recordExpense(BillExpense newExpense) async {
    if (newExpense.amount! <= 0.0 || newExpense.category!.isEmpty) {
      print("Expense amount or category is invalid.");
      return null;
    }

    try {
      final expense = await _insertBillExpenseUseCase.call(params: newExpense);

      // Clear the form model after successful insertion
      runInAction(() {
        newExpense = BillExpense(
          category: 'Rent',
          amount: 0.0,
          date: DateTime.now(),
          description: '',
        );
      });

      // The allExpensesList is automatically refreshed by the stream listener.
      await generateRangeReport();

      return expense;
    } catch (error) {
      print("Error recording expense: $error");
      throw error;
    }
  }

  /// Fetches a one-time report of bills for the currently selected date range.
  @action
  Future<void> generateRangeReport() async {
    isLoadingReport = true;
    try {
      // Reuse the DateRangeParams structure from the financial module
      final params = DateRangeParams(
        start: reportStartDate,
        end: reportEndDate,
      );

      final records = await _getRangeReportUseCase.call(params: params);

      runInAction(() {
        reportExpensesList = ObservableList.of(records);
        print("Fetched");
      });
    } catch (e) {
      print("Error generating expense range report: $e");
      reportExpensesList = ObservableList();
    } finally {
      isLoadingReport = false;
    }
  }

  @action
  Future<void> updateExpense(BillExpense? expense) async {
    if (expense == null || expense!.id == null) return;

    try {
      await _updateExpenseUseCase.call(params: expense);
      // Refresh the list to reflect changes
     await generateRangeReport();
      print("Expense ${expense!.id} updated.");
    } catch (error) {
      print("Error updating member: $error");
      rethrow;
    }
  }


  /// Deletes a bill expense record.
  @action
  Future<void> deleteExpense(int billId) async {
    try {
      await _deleteBillExpenseUseCase.call(params: billId);
      // The deletion will automatically update the allExpensesList stream.
      print("Bill expense $billId deleted.");
      await   generateRangeReport();
    } catch (e) {
      print("Error deleting bill expense: $e");
      throw e;
    }
  }
}
