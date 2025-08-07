// providers/transaction_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mactest/features/models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  late final Box<Transaction> _box;
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  TransactionProvider() {
    _box = Hive.box<Transaction>('transactions');
    _transactions = _box.values.toList();

    // Real-time listener
    _box.listenable().addListener(() {
      _transactions = _box.values.toList();
      notifyListeners();
    });
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
    // no need to call notifyListeners(), listener does it
  }

  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
    // no need to call notifyListeners(), listener does it
  }

  Future<void> updateTransaction(String id, Transaction newTransaction) async {
    await _box.put(id, newTransaction);
    // no need to call notifyListeners(), listener does it
  }

  Transaction? getTransactionById(String id) {
    return _box.get(id);
  }

  List<Transaction> getTransactionsByType(String type) {
    return _transactions.where((t) => t.type == type).toList();
  }

  List<Transaction> filterByDateRange(DateTime start, DateTime end) {
    return _transactions
        .where(
          (t) =>
              t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
              t.date.isBefore(end.add(const Duration(days: 1))),
        )
        .toList();
  }

  void refresh() {
    _transactions = _box.values.toList();
    notifyListeners();
  }
}
