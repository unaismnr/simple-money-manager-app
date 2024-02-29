import 'package:flutter/material.dart';
import 'package:simple_money_manager/db/category_db_functions.dart';
import 'package:simple_money_manager/models/category_model.dart';

class ExpenseCategoryLIst extends StatelessWidget {
  const ExpenseCategoryLIst({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDbFunctions().expenseCategoryListner,
        builder:
            (BuildContext context, List<CategoryModel> newList, Widget? _) {
          return ListView.separated(
            itemBuilder: (context, index) {
              final category = newList[index];
              return Card(
                child: ListTile(
                  title: Text(category.name),
                  trailing: IconButton(
                    onPressed: () {
                      CategoryDbFunctions().deleteCategory(category.id);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox();
            },
            itemCount: newList.length,
          );
        });
  }
}
