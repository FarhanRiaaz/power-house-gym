import 'package:finger_print_flutter/core/base_usecase.dart';
import 'package:finger_print_flutter/domain/repository/expense/expense_repository.dart';
import 'package:finger_print_flutter/domain/usecases/financial/financial_usecase.dart';

import '../../entities/models/bill_payment.dart';

/// Records a new bill or operating expense.
///
/// Type: BillExpense (The inserted record)
/// Params: BillExpense (The expense object)
class InsertBillExpenseUseCase extends UseCase<BillExpense, BillExpense> {
  final ExpenseRepository _expenseRepository;

  InsertBillExpenseUseCase(this._expenseRepository);

  @override
  Future<BillExpense> call({required BillExpense params}) {
    return _expenseRepository.insertExpense(params);
  }
}

class UpdateExpenseUseCase extends UseCase<void, BillExpense> {
  final ExpenseRepository _expenseRepository;

  UpdateExpenseUseCase(this._expenseRepository);

  @override
  Future<void> call({required BillExpense params}) {
    return _expenseRepository.update(params);
  }
}

/// Fetches a one-time list of bills and expenses within a date range.
///
/// Type: List<BillExpense>
/// Params: DateRangeParams (Start and end dates)
class GetBillsByDateRangeUseCase
    extends UseCase<List<BillExpense>, DateRangeParams> {
  final ExpenseRepository _expenseRepository;

  GetBillsByDateRangeUseCase(this._expenseRepository);

  @override
  Future<List<BillExpense>> call({required DateRangeParams params}) {
    return _expenseRepository.getExpensesByDateRange(
      params.start,
      params.end,
    );
  }
}

/// Provides a real-time stream of all bill expenses, ordered by date.
///
/// Type: Stream<List<BillExpense>>
/// Params: void (no parameters needed)
class WatchAllExpensesUseCase
    extends UseCase<Stream<List<BillExpense>>, void> {
  final ExpenseRepository _expenseRepository;

  WatchAllExpensesUseCase(this._expenseRepository);

  @override
  Future<Stream<List<BillExpense>>> call({void params}) async {
    return _expenseRepository.watchAllExpenses();
  }
}

/// Deletes a specific expense record by its ID.
///
/// Type: void
/// Params: int (The ID of the bill expense record)
class DeleteBillExpenseUseCase extends UseCase<void, int> {
  final ExpenseRepository _expenseRepository;

  DeleteBillExpenseUseCase(this._expenseRepository);

  @override
  Future<void> call({required int params}) {
    return _expenseRepository.deleteExpense(params);
  }
}