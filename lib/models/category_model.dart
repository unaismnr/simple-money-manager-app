import 'package:hive_flutter/hive_flutter.dart';
part 'category_model.g.dart';

@HiveType(typeId: 1)
enum CategoryType {
  @HiveField(0)
  income,

  @HiveField(1)
  expense,
}

@HiveType(typeId: 2)
class CategoryModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  CategoryType type;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
  });

  @override
  String toString() {
    return '{$name $type}';
  }
}
