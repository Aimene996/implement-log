// You can later add Hive annotations here
import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final String subtitle;
  final double amount;
  final IconData icon;
  final Color iconBackground;

  Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.iconBackground,
  });
}

class TransactionGroup {
  final String month;
  final String year;
  final List<Transaction> transactions;

  TransactionGroup({
    required this.month,
    required this.year,
    required this.transactions,
  });
}
