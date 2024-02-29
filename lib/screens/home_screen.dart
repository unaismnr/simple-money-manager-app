import 'package:flutter/material.dart';
import 'package:simple_money_manager/bottom_navigation.dart';
import 'package:simple_money_manager/screens/add_transaction_screen.dart';
import 'package:simple_money_manager/screens/category_screen.dart';
import 'package:simple_money_manager/screens/transaction_screen.dart';
import 'package:simple_money_manager/widgets/add_category_popup.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = [const TransactionScreen(), const CategoryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Money Manager'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedIndexNotifier,
        builder: (BuildContext context, int updatedIndex, Widget? _) {
          return _pages[updatedIndex];
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            Navigator.of(context).pushNamed(AddTransactionScreen.routeName);
          } else {
            addCategoryPopup(context);
          }
        },
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
