import 'package:flutter/material.dart';
import 'package:simple_money_manager/db/category_db_functions.dart';
import 'package:simple_money_manager/db/transaction_db_functions.dart';
import 'package:simple_money_manager/models/category_model.dart';
import 'package:simple_money_manager/models/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDbFunctions.instance.refreshUi();
    CategoryDbFunctions.instance.refreshUi();
    return ValueListenableBuilder(
        valueListenable: TransactionDbFunctions().transactionsListener,
        builder:
            (BuildContext context, List<TransactionModel> newList, Widget? _) {
          return ListView.separated(
            itemBuilder: (context, index) {
              final value = newList[index];
              return Slidable(
                key: Key(value.id!),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        TransactionDbFunctions.instance.deleteTransaction(
                          value.id!,
                        );
                      },
                      icon: Icons.delete,
                      label: "Delete",
                    )
                  ],
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            value.categoryType == CategoryType.income
                                ? Colors.deepPurpleAccent
                                : Colors.deepPurple,
                        radius: 30,
                        child: Text(
                          parseDate(value.dateTime),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text('Rs ${value.amount}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(value.category.name),
                          Text(value.purpose),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(),
            itemCount: newList.length,
          );
        });
  }

  String parseDate(DateTime date) {
    final formatedDate = DateFormat.MMMd().format(date);
    final splitedDate = formatedDate.split(' ');
    return '${splitedDate.last}\n${splitedDate.first}';
  }
}
