import 'package:flutter/material.dart';

class TransactionsDisplayScreen extends StatelessWidget {
  const TransactionsDisplayScreen({super.key});

  // Sample transaction data based on your input
  final List<Map<String, dynamic>> transactionData = const [
    // March 2025
    {
      'month': 'March 2025',
      'transactions': [
        {
          'category': 'Groceries',
          'amount': -120.0,
          'description': 'Grocery shopping',
          'type': 'expense',
        },
        {
          'category': 'Rent',
          'amount': -800.0,
          'description': 'Rent payment',
          'type': 'expense',
        },
        {
          'category': 'Clothing',
          'amount': -250.0,
          'description': 'Clothing purchase',
          'type': 'expense',
        },
        {
          'category': 'Salary',
          'amount': 2500.0,
          'description': 'Salary received',
          'type': 'income',
        },
      ],
    },
    // February 2025
    {
      'month': 'February 2025',
      'transactions': [
        {
          'category': 'Groceries',
          'amount': -120.0,
          'description': 'Grocery shopping',
          'type': 'expense',
        },
        {
          'category': 'Rent',
          'amount': -800.0,
          'description': 'Rent payment',
          'type': 'expense',
        },
        {
          'category': 'Clothing',
          'amount': -250.0,
          'description': 'Clothing purchase',
          'type': 'expense',
        },
        {
          'category': 'Salary',
          'amount': 2500.0,
          'description': 'Salary received',
          'type': 'income',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1D21),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Transactions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 24),
            onPressed: () {
              // Add new transaction functionality
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: transactionData.length,
        itemBuilder: (context, index) {
          final monthData = transactionData[index];
          final month = monthData['month'] as String;
          final transactions =
              monthData['transactions'] as List<Map<String, dynamic>>;

          // Calculate monthly total
          double monthlyTotal = 0;
          for (var transaction in transactions) {
            monthlyTotal += transaction['amount'] as double;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      month,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${monthlyTotal >= 0 ? '+' : ''}\$${monthlyTotal.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: monthlyTotal >= 0
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Transactions for this month
              ...transactions.asMap().entries.map((entry) {
                final transactionIndex = entry.key;
                final transaction = entry.value;
                final isLast = transactionIndex == transactions.length - 1;

                return Column(
                  children: [
                    _buildTransactionItem(transaction),
                    if (!isLast) const SizedBox(height: 16),
                  ],
                );
              }),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final isIncome = transaction['type'] == 'income';
    final amount = transaction['amount'] as double;
    final category = transaction['category'] as String;
    final description = transaction['description'] as String;
    final prefix = amount >= 0 ? '+' : '';

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isIncome
                  ? const Color(0xFF10B981).withOpacity(0.2)
                  : const Color(0xFFEF4444).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(category),
              color: isIncome
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Title + Description
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '$prefix\$${amount.abs().toStringAsFixed(0)}',
            style: TextStyle(
              color: isIncome ? const Color(0xFF10B981) : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'groceries':
        return Icons.shopping_cart_outlined;
      case 'rent':
        return Icons.home_outlined;
      case 'clothing':
        return Icons.checkroom_outlined;
      case 'salary':
        return Icons.account_balance_wallet_outlined;
      case 'food':
        return Icons.restaurant_outlined;
      case 'transport':
      case 'transportation':
        return Icons.directions_car_outlined;
      case 'entertainment':
        return Icons.movie_outlined;
      case 'health':
        return Icons.local_hospital_outlined;
      case 'utilities':
        return Icons.bolt_outlined;
      default:
        return Icons.receipt_outlined;
    }
  }
}
