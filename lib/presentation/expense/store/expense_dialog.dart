import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/presentation/components/app_button.dart';
import 'package:finger_print_flutter/presentation/components/app_date_picker.dart';
import 'package:finger_print_flutter/presentation/components/app_text_field.dart';
import 'package:finger_print_flutter/presentation/expense/expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/entities/models/bill_payment.dart';

class ExpenseFormDialog extends StatefulWidget {
  final BillExpense? expense;
  final ValueChanged<BillExpense> onSave;

  const ExpenseFormDialog({super.key, required this.onSave, this.expense});

  @override
  State<ExpenseFormDialog> createState() => ExpenseFormDialogState();
}

class ExpenseFormDialogState extends State<ExpenseFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late BillExpense _currentExpense;
  late DateTime _tempDate;

  late TextEditingController _categoryController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;

  // Simple list of common categories for a simple app
  final List<String> _categories = [
    'Rent',
    'Salary',
    'Utility',
    'Equipment',
    'Maintenance',
    'Other',
  ];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();

    if (widget.expense != null) {
      _currentExpense = widget.expense!;
    } else {
      _currentExpense = BillExpense(
        id: 0,
        // Simple new ID logic
        category: '',
        amount: 0.0,
        date: DateTime.now(),
        description: '',
      );
    }

    _tempDate = _currentExpense.date!;
    _selectedCategory = _currentExpense.category!.isNotEmpty
        ? _currentExpense.category
        : null;

    _categoryController = TextEditingController(text: _currentExpense.category);
    // Convert double amount to string for controller, fixing to 2 decimal places
    _amountController = TextEditingController(
      text: _currentExpense.amount! > 0
          ? _currentExpense.amount!.toStringAsFixed(2)
          : '',
    );
    _descriptionController = TextEditingController(
      text: _currentExpense.description,
    );
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _currentExpense.category = _selectedCategory ?? 'Other';
      _currentExpense.amount = double.tryParse(_amountController.text) ?? 0.0;
      _currentExpense.description = _descriptionController.text;
      _currentExpense.date = _tempDate;

      widget.onSave(_currentExpense);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.expense == null
            ? 'Add New Expense'
            : 'Edit Expense (ID: ${_currentExpense.id})',
      ),
      backgroundColor: AppColors.backgroundDark,
      content: SingleChildScrollView(
        child: SizedBox(
          width: 600,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Category Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  dropdownColor: AppColors.backgroundDark,
                  decoration: const InputDecoration(
                    labelText: 'Category *',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a category' : null,
                ),
                SizedBox(height: 12,),
                // Amount Field
                AppTextField(
                  label: 'Amount (PKR) *',
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.money,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Amount is required';
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0)
                      return 'Enter a valid amount';
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                ),
                SizedBox(height: 12,),
                // Date Picker
                AppDatePicker(
                  label: 'Expense Date',
                  initialDate: _tempDate,
                  onDateSelected: (newDate) {
                    setState(() {
                      _tempDate = newDate;
                    });
                  },
                ),
                SizedBox(height: 12,),
                // Description Field
                AppTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  maxLines: 3,
                  prefixIcon: Icons.notes,
                  hint: 'Brief note on what the expense was for.',
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        AppButton(
          label: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
          variant: AppButtonVariant.secondary,
        ),
        SizedBox(height: 12,),
        AppButton(
          label: widget.expense == null ? 'Add Expense' : 'Save Changes',
          onPressed: _saveForm,
          variant: AppButtonVariant.primary,
        ),
      ],
    );
  }
}
