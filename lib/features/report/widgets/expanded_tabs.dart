import 'package:flutter/material.dart';
import 'package:mactest/features/models/transaction.dart';

class ExpensesTab extends StatelessWidget {
  final List<Transaction> allTransactions;
  final double totalAmount;
  final bool isExpenseTab;

  const ExpensesTab({
    super.key,
    required this.allTransactions,
    required this.totalAmount,
    required this.isExpenseTab,
  });

  Map<String, double> _getCategoryTotals() {
    final Map<String, double> categoryTotals = {};
    final filteredTransactions = allTransactions
        .where((tx) => tx.type == (isExpenseTab ? 'expense' : 'income'))
        .toList();

    for (var tx in filteredTransactions) {
      categoryTotals[tx.category] =
          (categoryTotals[tx.category] ?? 0) + tx.amount;
    }

    return categoryTotals;
  }

  @override
  Widget build(BuildContext context) {
    final categoryTotals = _getCategoryTotals();
    final maxAmount = categoryTotals.values.isEmpty
        ? 0
        : categoryTotals.values.reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              isExpenseTab ? 'Total Expenses' : 'Total Income',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Text(
                  'Last 30 days',
                  style: TextStyle(color: Color(0xFF9EABBA)),
                ),
                Icon(Icons.arrow_drop_down, color: Color(0xFF9EABBA)),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              isExpenseTab ? 'Expenses' : 'Income',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${totalAmount.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'August',
              style: TextStyle(color: Color(0xFF9EABBA), fontSize: 14),
            ),
            const SizedBox(height: 32),
            Text(
              isExpenseTab ? 'Expenses by Category' : 'Income by Category',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 🟩 Dynamic Category Bars
            ...categoryTotals.entries.map((entry) {
              final percentage = maxAmount > 0 ? entry.value / maxAmount : 0;
              return _buildCategoryBar(
                entry.key,
                entry.value,
                percentage.toDouble(),
              );
            }).toList(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBar(String title, double amount, double percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF9EABBA),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 21,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2A38),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 21,
                    decoration: BoxDecoration(
                      color: const Color(0xFF243647),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      '\$${amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
