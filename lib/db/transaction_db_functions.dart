import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_money_manager/models/transaction_model.dart';

const transactionDbName = 'transaction_db';

class TransactionDbFunctions {
  TransactionDbFunctions.internal();

  static TransactionDbFunctions instance = TransactionDbFunctions.internal();

  factory TransactionDbFunctions() => instance;

  ValueNotifier<List<TransactionModel>> transactionsListener =
      ValueNotifier([]);

  Future<void> addTransaction(TransactionModel value) async {
    final transactionOpened =
        await Hive.openBox<TransactionModel>(transactionDbName);
    transactionOpened.put(value.id, value);
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final transactionOpened =
        await Hive.openBox<TransactionModel>(transactionDbName);
    return transactionOpened.values.toList();
  }

  Future<void> refreshUi() async {
    final list = await getAllTransactions();
    list.sort((first, second) => second.dateTime.compareTo(
          first.dateTime,
        ));
    transactionsListener.value.clear();
    transactionsListener.value.addAll(list);
    transactionsListener.notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    final transactionOpened =
        await Hive.openBox<TransactionModel>(transactionDbName);
    transactionOpened.delete(id);
    refreshUi();
  }
}
