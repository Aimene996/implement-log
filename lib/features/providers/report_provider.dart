import 'package:flutter/material.dart';
import 'package:mactest/features/models/transaction.dart';
import 'package:mactest/features/services/data_service.dart';

enum DateFilterType {
  all,
  last30Days,
  thisMonth,
  lastMonth,
  thisWeek,
  lastWeek,
  custom,
}

class ReportProvider extends ChangeNotifier {
  List<Transaction> _allTransactions = [];
  List<Transaction> _filteredTransactions = [];

  String _selectedCategory = 'All';
  String _selectedType = 'All';

  DateFilterType _dateFilterType = DateFilterType.all;
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  // Getters
  List<Transaction> get allTransactions => _allTransactions;
  List<Transaction> get filteredTransactions => _filteredTransactions;
  String get selectedCategory => _selectedCategory;
  String get selectedType => _selectedType;
  DateFilterType get dateFilterType => _dateFilterType;
  DateTime? get customStartDate => _customStartDate;
  DateTime? get customEndDate => _customEndDate;

  // Computed values
  double get totalIncome => _filteredTransactions
      .where((tx) => tx.type == 'income')
      .fold(0.0, (sum, tx) => sum + tx.amount);

  double get totalExpense => _filteredTransactions
      .where((tx) => tx.type == 'expense')
      .fold(0.0, (sum, tx) => sum + tx.amount);

  List<Transaction> get incomeTransactions =>
      _filteredTransactions.where((tx) => tx.type == 'income').toList();

  List<Transaction> get expenseTransactions =>
      _filteredTransactions.where((tx) => tx.type == 'expense').toList();

  List<String> get availableCategories {
    final categories = _allTransactions
        .map((tx) => tx.category)
        .toSet()
        .toList();
    categories.insert(0, 'All');
    return categories;
  }

  Map<String, List<Transaction>> get transactionsByCategory {
    final Map<String, List<Transaction>> grouped = {};
    for (var transaction in _filteredTransactions) {
      if (!grouped.containsKey(transaction.category)) {
        grouped[transaction.category] = [];
      }
      grouped[transaction.category]!.add(transaction);
    }
    return grouped;
  }

  Map<String, double> get categoryTotals {
    final Map<String, double> totals = {};
    for (var transaction in _filteredTransactions) {
      totals[transaction.category] =
          (totals[transaction.category] ?? 0) + transaction.amount;
    }
    return totals;
  }

  // Initialization
  Future<void> loadTransactions() async {
    try {
      _allTransactions = TransactionHelper.getAllTransactions();
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    }
  }

  Future<void> refreshTransactions() async {
    await loadTransactions();
  }

  // Setters
  void setCategoryFilter(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      _applyFilters();
      notifyListeners();
    }
  }

  void setTypeFilter(String type) {
    if (_selectedType != type) {
      _selectedType = type;
      _applyFilters();
      notifyListeners();
    }
  }

  void setDateFilterType(DateFilterType type) {
    _dateFilterType = type;
    _applyFilters();
    notifyListeners();
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    _customStartDate = start;
    _customEndDate = end;
    _dateFilterType = DateFilterType.custom;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = 'All';
    _selectedType = 'All';
    _dateFilterType = DateFilterType.all;
    _customStartDate = null;
    _customEndDate = null;
    _applyFilters();
    notifyListeners();
  }

  // Core filter logic
  void _applyFilters() {
    final now = DateTime.now();
    DateTime? startDate;
    DateTime? endDate;

    switch (_dateFilterType) {
      case DateFilterType.last30Days:
        startDate = now.subtract(const Duration(days: 30));
        endDate = now;
        break;
      case DateFilterType.thisMonth:
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        break;
      case DateFilterType.lastMonth:
        startDate = DateTime(now.year, now.month - 1, 1);
        endDate = DateTime(now.year, now.month, 0);
        break;
      case DateFilterType.thisWeek:
        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = now;
        break;
      case DateFilterType.lastWeek:
        startDate = now.subtract(Duration(days: now.weekday + 6));
        endDate = startDate.add(const Duration(days: 6));
        break;
      case DateFilterType.custom:
        startDate = _customStartDate;
        endDate = _customEndDate;
        break;
      case DateFilterType.all:
      default:
        startDate = null;
        endDate = null;
        break;
    }

    _filteredTransactions = _allTransactions.where((transaction) {
      final txDate = transaction.date;

      // Date
      bool dateMatch = true;
      if (startDate != null && endDate != null) {
        dateMatch =
            txDate.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
            txDate.isBefore(endDate.add(const Duration(days: 1)));
      }

      // Category
      bool categoryMatch =
          _selectedCategory == 'All' ||
          transaction.category == _selectedCategory;

      // Type
      bool typeMatch =
          _selectedType == 'All' || transaction.type == _selectedType;

      return dateMatch && categoryMatch && typeMatch;
    }).toList();

    _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
  }

  // Helpers
  List<Transaction> getFilteredTransactionsByType(String type) {
    return _filteredTransactions.where((tx) => tx.type == type).toList();
  }

  double getTotalForType(String type) {
    return _filteredTransactions
        .where((tx) => tx.type == type)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  Map<String, double> getCategoryTotalsForType(String type) {
    final Map<String, double> totals = {};
    final typeTransactions = _filteredTransactions.where(
      (tx) => tx.type == type,
    );
    for (var transaction in typeTransactions) {
      totals[transaction.category] =
          (totals[transaction.category] ?? 0) + transaction.amount;
    }
    return totals;
  }

  String get currentDateFilterLabel {
    switch (_dateFilterType) {
      case DateFilterType.last30Days:
        return "Last 30 Days";
      case DateFilterType.thisMonth:
        return "This Month";
      case DateFilterType.lastMonth:
        return "Last Month";
      case DateFilterType.thisWeek:
        return "This Week";
      case DateFilterType.lastWeek:
        return "Last Week";
      case DateFilterType.custom:
        return "Custom";
      default:
        return "All";
    }
  }
}
