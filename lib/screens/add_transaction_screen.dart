import 'package:flutter/material.dart';
import 'package:simple_money_manager/db/category_db_functions.dart';
import 'package:simple_money_manager/db/transaction_db_functions.dart';
import 'package:simple_money_manager/models/category_model.dart';
import 'package:simple_money_manager/models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  static const routeName = 'add_transaction';

  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  DateTime? selectedDate;
  CategoryType? selectedCategoryType;
  String? displayCategory;
  CategoryModel? selectedCategory;

  final purposeTextController = TextEditingController();
  final amountTextController = TextEditingController();

  @override
  void initState() {
    selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              //Purpose
              TextFormField(
                controller: purposeTextController,
                decoration: const InputDecoration(
                  hintText: 'Enter Purpose',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              //Amount
              TextFormField(
                controller: amountTextController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 5),
              //Date and Time
              TextButton.icon(
                onPressed: () async {
                  final selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 30),
                    ),
                    lastDate: DateTime.now(),
                  );

                  if (selectedDateTemp == null) {
                    return;
                  } else {
                    setState(() {
                      selectedDate = selectedDateTemp;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  selectedDate == null
                      ? 'Select Date'
                      : selectedDate.toString(),
                ),
              ),
              //Income or Expense
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.income,
                        groupValue: selectedCategoryType,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategoryType = newValue;
                          });
                        },
                      ),
                      const Text('Income'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expense,
                        groupValue: selectedCategoryType,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategoryType = newValue;
                            displayCategory = null;
                          });
                        },
                      ),
                      const Text('Expense'),
                    ],
                  ),
                ],
              ),
              //CategoryType
              DropdownButton(
                hint: const Text('Select Category'),
                value: displayCategory,
                items: (selectedCategoryType == CategoryType.income
                        ? CategoryDbFunctions().incomeCategoryListner
                        : CategoryDbFunctions().expenseCategoryListner)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                    onTap: () {
                      selectedCategory = e;
                    },
                  );
                }).toList(),
                onChanged: (selectedValue) {
                  setState(() {
                    displayCategory = selectedValue;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  addTransaction();
                },
                child: const Text(
                  'Submit',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final purpose = purposeTextController.text.trim();
    final amount = amountTextController.text.trim();
    if (purpose.isEmpty) {
      return;
    }
    if (amount.isEmpty) {
      return;
    }

    if (selectedDate == null) {
      return;
    }

    if (displayCategory == null) {
      return;
    }

    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null) {
      return;
    }

    if (selectedCategory == null) {
      return;
    }
    final model = TransactionModel(
      purpose: purpose,
      amount: parsedAmount,
      dateTime: selectedDate!,
      categoryType: selectedCategoryType!,
      category: selectedCategory!,
    );

    TransactionDbFunctions.instance.addTransaction(model);
    Navigator.of(context).pop();
    TransactionDbFunctions.instance.refreshUi();
  }
}
