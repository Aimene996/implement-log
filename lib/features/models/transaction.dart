import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart'; // ✅ Required for Hive to generate the adapter

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String note;

  Transaction({
    required this.id, // ✅ Now passed manually
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    required this.note,
  });

  // Optional helper to create new transaction with UUID
  factory Transaction.create({
    required String type,
    required String category,
    required double amount,
    required DateTime date,
    required String note,
  }) {
    return Transaction(
      id: const Uuid().v4(),
      type: type,
      category: category,
      amount: amount,
      date: date,
      note: note,
    );
  }
}
