import 'package:hive/hive.dart';

part 'custom_category.g.dart';

@HiveType(typeId: 1)
class CustomCategory extends HiveObject {
  @HiveField(0)
  final String name; // User-defined name

  // @HiveField(1)
  // final int iconCodePoint; // e.g., Icons.shopping_bag.codePoint

  // @HiveField(2)
  // final String? iconFontFamily; // e.g., Icons.shopping_bag.fontFamily

  @HiveField(3)
  final String type; // 'Expense' or 'Income'

  CustomCategory({
    required this.name,
    // required this.iconCodePoint,
    // required this.iconFontFamily,
    required this.type,
  });
}
