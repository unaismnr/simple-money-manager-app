import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_money_manager/models/category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  String? id;

  @HiveField(5)
  final String purpose;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final CategoryType categoryType;

  @HiveField(4)
  final CategoryModel category;

  TransactionModel({
    required this.purpose,
    required this.amount,
    required this.dateTime,
    required this.categoryType,
    required this.category,
  }) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }
}
