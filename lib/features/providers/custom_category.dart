import 'package:flutter/material.dart';
import 'package:mactest/features/models/custom_category.dart';
import 'package:mactest/features/services/custom_category_helper.dart';

class CustomCategoryProvider with ChangeNotifier {
  List<CustomCategory> _categories = [];

  List<CustomCategory> get categories => _categories;

  Future<void> loadCategories({String? type}) async {
    if (type != null) {
      _categories = await CustomCategoryHelper.getCustomCategoriesByType(type);
    } else {
      _categories = await CustomCategoryHelper.getAllCustomCategories();
    }
    notifyListeners();
  }

  Future<void> addCategory(String name, String type) async {
    await CustomCategoryHelper.addCategoryWithName(name, type);
    await loadCategories(type: type);
  }

  Future<void> deleteCategory(int key, String type) async {
    await CustomCategoryHelper.deleteCategory(key);
    await loadCategories(type: type);
  }

  Future<void> clearAll() async {
    await CustomCategoryHelper.clearAll();
    await loadCategories();
  }
}
