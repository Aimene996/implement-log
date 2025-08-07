import 'package:hive/hive.dart';

part 'category_item.g.dart';

@HiveType(typeId: 4)
class CategoryItem extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String imagePath;

  @HiveField(2)
  final String type;

  CategoryItem({
    required this.title,
    required this.imagePath,
    required this.type,
  });
}
