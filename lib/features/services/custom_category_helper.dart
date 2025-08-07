import 'package:hive/hive.dart';
import 'package:mactest/features/models/custom_category.dart';

class CustomCategoryHelper {
  static const String _boxName = 'custom_categories';

  static Future<List<CustomCategory>> getAllCustomCategories() async {
    final box = await Hive.openBox<CustomCategory>(_boxName);
    return box.values.toList();
  }

  static Future<void> addCustomCategory(CustomCategory category) async {
    final box = await Hive.openBox<CustomCategory>(_boxName);
    await box.add(category);
  }

  /// 🆕 Add category with fixed image path (e.g., Transportation icon)
  static Future<CustomCategory?> addCategoryWithName(
    String name,
    String type,
  ) async {
    final box = await Hive.openBox<CustomCategory>(_boxName);
    final newCategory = CustomCategory(
      name: name,
      type: type,
      // imagepath: 'assets/Transportation.png', // ✅ use fixed image path here
    );
    final key = await box.add(newCategory);
    return box.get(key);
  }

  static Future<void> deleteCategory(int key) async {
    final box = await Hive.openBox<CustomCategory>(_boxName);
    await box.delete(key);
  }

  static Future<void> updateCategory(int key, CustomCategory category) async {
    final box = await Hive.openBox<CustomCategory>(_boxName);
    await box.put(key, category);
  }

  static Future<void> clearAll() async {
    final box = await Hive.openBox<CustomCategory>(_boxName);
    await box.clear();
  }

  static Future<List<CustomCategory>> getCustomCategoriesByType(
    String type,
  ) async {
    final box = await Hive.openBox<CustomCategory>(_boxName);
    return box.values.where((cat) => cat.type == type).toList();
  }
}
