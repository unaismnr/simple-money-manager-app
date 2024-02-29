import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_money_manager/models/category_model.dart';

const categoryDbName = 'categoryDatabase';

class CategoryDbFunctions {
  CategoryDbFunctions.internal();

  static CategoryDbFunctions instance = CategoryDbFunctions.internal();

  factory CategoryDbFunctions() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryListner = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListner = ValueNotifier([]);

  Future<void> addCategory(CategoryModel value) async {
    final categoryOpened = await Hive.openBox<CategoryModel>(categoryDbName);
    categoryOpened.put(value.id, value);
    refreshUi();
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final categoryOpened = await Hive.openBox<CategoryModel>(categoryDbName);
    return categoryOpened.values.toList();
  }

  Future<void> refreshUi() async {
    final getAll = await getAllCategories();
    incomeCategoryListner.value.clear();
    expenseCategoryListner.value.clear();
    Future.forEach(getAll, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategoryListner.value.add(category);
      } else {
        expenseCategoryListner.value.add(category);
      }
      incomeCategoryListner.notifyListeners();
      expenseCategoryListner.notifyListeners();
    });
  }

  Future<void> deleteCategory(String category) async {
    final categoryOpened = await Hive.openBox<CategoryModel>(categoryDbName);
    categoryOpened.delete(category);
    refreshUi();
  }
}
