import 'package:flutter/material.dart';
import 'package:simple_money_manager/db/category_db_functions.dart';
import 'package:simple_money_manager/models/category_model.dart';

ValueNotifier<CategoryType> selectedCategory =
    ValueNotifier(CategoryType.income);

Future<void> addCategoryPopup(BuildContext context) async {
  TextEditingController textController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: const Center(
          child: Text('Add Category'),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Category Name',
              ),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RadioButton(title: 'Income', type: CategoryType.income),
              RadioButton(title: 'Expense', type: CategoryType.expense),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                final name = textController.text.trim();
                if (name.isEmpty) {
                  return;
                }
                final value = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  type: selectedCategory.value,
                );
                CategoryDbFunctions().addCategory(value);
                Navigator.of(context).pop();
              },
              child: const Text('ADD'),
            ),
          ),
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  const RadioButton({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategory,
            builder:
                (BuildContext context, CategoryType newCategory, Widget? _) {
              return Radio(
                value: type,
                groupValue: newCategory,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  selectedCategory.value = value;
                  selectedCategory.notifyListeners();
                },
              );
            }),
        Text(title),
      ],
    );
  }
}
