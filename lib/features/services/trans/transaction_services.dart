import 'package:hive/hive.dart';
import 'package:mactest/features/models/transaction.dart';

class TransactionService {
  final Box<Transaction> _transactionBox = Hive.box<Transaction>(
    'transactions',
  );

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  List<Transaction> getAllTransactions() {
    return _transactionBox.values.toList();
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  Transaction? getTransactionById(String id) {
    return _transactionBox.get(id);
  }
}
