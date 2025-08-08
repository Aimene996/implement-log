// transaction_model.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mactest/features/category/add_category_screen.dart';
import 'package:mactest/features/models/custom_category.dart';
import 'package:mactest/features/models/transaction.dart';

enum DateFilterType {
  last30Days,
  thisMonth,
  lastMonth,
  thisWeek,
  lastWeek,
  custom,
}

// helper: transaction_helper.dart
class TransactionHelper {
  static const _categoryBoxName = 'categories';

  static final List<CategoryItem> _predefinedCategories = [
    CategoryItem(title: 'Utilities', imagePath: 'assets/Groceries.png', type: 'Expense'),
    CategoryItem(title: 'Mobile & Internet', imagePath: 'assets/Transportation.png', type: 'Expense'),
    CategoryItem(title: 'Utilities', imagePath: 'assets/Utilities.png', type: 'Expense'),
    CategoryItem(title: 'Mobile & Internet', imagePath: 'assets/Mobile & Internet.png', type: 'Expense'),
    CategoryItem(title: 'Rent/Mortgage', imagePath: 'assets/Home.png', type: 'Expense'),
    CategoryItem(title: 'Healthcare', imagePath: 'assets/Healthcare.png', type: 'Expense'),
    CategoryItem(title: 'Clothing & Shoes', imagePath: 'assets/Clothing & Shoes.png', type: 'Expense'),
    CategoryItem(title: 'Entertainment', imagePath: 'assets/Entertainment.png', type: 'Expense'),
    CategoryItem(title: 'Education', imagePath: 'assets/Education.png', type: 'Expense'),
    CategoryItem(title: 'Home', imagePath: 'assets/Home.png', type: 'Expense'),
    CategoryItem(title: 'Gifts', imagePath: 'assets/Gifts.png', type: 'Expense'),
    CategoryItem(title: 'Pets', imagePath: 'assets/Pets.png', type: 'Expense'),
    CategoryItem(title: 'Sports & Fitness', imagePath: 'assets/Sports & Fitness.png', type: 'Expense'),
    CategoryItem(title: 'Children', imagePath: 'assets/Children.png', type: 'Expense'),
    CategoryItem(title: 'Insurances', imagePath: 'assets/Insurances.png', type: 'Expense'),
    CategoryItem(title: 'Taxes & Fines', imagePath: 'assets/Taxes & Fines.png', type: 'Expense'),
    CategoryItem(title: 'Travel', imagePath: 'assets/Travel.png', type: 'Expense'),
    CategoryItem(title: 'Business Expenses', imagePath: 'assets/Business Expenses.png', type: 'Expense'),
    CategoryItem(title: 'Charity', imagePath: 'assets/Charity.png', type: 'Expense'),
    CategoryItem(title: 'Salary', imagePath: 'assets/Salary.png', type: 'Income'),
    CategoryItem(title: 'Bonuses', imagePath: 'assets/Bonuses.png', type: 'Income'),
    CategoryItem(title: 'Freelance', imagePath: 'assets/Freelance.png', type: 'Income'),
    CategoryItem(title: 'Gifts', imagePath: 'assets/Gifts.png', type: 'Income'),
  ];

  static final _box = Hive.box<Transaction>('transactions');

  static Future<void> addTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  static List<Transaction> getAllTransactions() {
    return _box.values.toList();
  }

  static List<Transaction> getTransactionsByType(String type) {
    return _box.values.where((t) => t.type == type).toList();
  }

  static Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }
  static Future<void> initCategoryBox() async {
    final box = await Hive.openBox<CategoryItem>(_categoryBoxName);
    if (box.isEmpty) {
      await box.addAll(_predefinedCategories);
    }
  }


  static Future<void> updateTransaction(
    String id,
    Transaction newTransaction,
  ) async {
    await _box.put(id, newTransaction);
  }

  static List<Transaction> filterByDateRange(DateTime start, DateTime end) {
    return _box.values
        .where(
          (t) =>
              t.date.isAfter(start.subtract(const Duration(days: 1))) &&
              t.date.isBefore(end.add(const Duration(days: 1))),
        )
        .toList();
  }

  static List<Transaction> getFilteredTransactions(
    DateFilterType filter, {
    DateTimeRange? customRange,
  }) {
    final allTransactions = getAllTransactions();
    final now = DateTime.now();

    DateTime start;
    DateTime end = now;

    switch (filter) {
      case DateFilterType.last30Days:
        start = now.subtract(const Duration(days: 30));
        break;
      case DateFilterType.thisMonth:
        start = DateTime(now.year, now.month, 1);
        break;
      case DateFilterType.lastMonth:
        final prevMonth = DateTime(now.year, now.month - 1, 1);
        start = prevMonth;
        end = DateTime(
          now.year,
          now.month,
          1,
        ).subtract(const Duration(days: 1));
        break;
      case DateFilterType.thisWeek:
        final weekday = now.weekday;
        start = now.subtract(Duration(days: weekday - 1));
        break;
      case DateFilterType.lastWeek:
        final weekday = now.weekday;
        end = now.subtract(Duration(days: weekday));
        start = end.subtract(const Duration(days: 6));
        break;
      case DateFilterType.custom:
        if (customRange == null) return [];
        start = customRange.start;
        end = customRange.end;
        break;
    }

    return allTransactions.where((tx) {
      return tx.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
          tx.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // ✅ Save a custom category
  static Future<void> saveCustomCategory(CustomCategory category) async {
    final box = await Hive.openBox<CustomCategory>('custom_categories');
    await box.add(category);
  }

  // ✅ Get all custom categories
  static Future<List<CustomCategory>> getAllCustomCategories() async {
    final box = await Hive.openBox<CustomCategory>('custom_categories');
    return box.values.toList();
  }

  // // currency_settings.dart
  // @HiveType(typeId: 1)
  // class CurrencySettings extends HiveObject {
  //   @HiveField(0)
  //   final String symbol;

  //   CurrencySettings({required this.symbol});
  // }

  // To generate adapters:
  // flutter pub run build_runner build --delete-conflicting-outputs
}
