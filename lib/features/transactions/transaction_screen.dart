import 'package:flutter/material.dart';
import 'package:mactest/features/transactions/add_new_transaction.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final List<TransactionGroup> transactionGroups = [
    TransactionGroup(
      month: 'March',
      year: '2025',
      transactions: [
        Transaction(
          title: 'Groceries',
          subtitle: 'Grocery shopping',
          amount: -120,
          icon: Icons.shopping_cart,
          iconBackground: const Color(0xFF374151),
        ),
        Transaction(
          title: 'Rent',
          subtitle: 'Rent payment',
          amount: -800,
          icon: Icons.home,
          iconBackground: const Color(0xFF374151),
        ),
        Transaction(
          title: 'Salary',
          subtitle: 'Salary received',
          amount: 2500,
          icon: Icons.work,
          iconBackground: const Color(0xFF374151),
        ),
      ],
    ),
    TransactionGroup(
      month: 'February',
      year: '2025',
      transactions: [
        Transaction(
          title: 'Groceries',
          subtitle: 'Grocery shopping',
          amount: -120,
          icon: Icons.shopping_cart,
          iconBackground: const Color(0xFF374151),
        ),
        Transaction(
          title: 'Rent',
          subtitle: 'Rent payment',
          amount: -800,
          icon: Icons.home,
          iconBackground: const Color(0xFF374151),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1D21),
        elevation: 0,
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddNewTransaction(),
                ),
              );
              // Navigate to Add Transaction screen
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: transactionGroups.length,
        itemBuilder: (context, groupIndex) {
          final group = transactionGroups[groupIndex];
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
                      group.month,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      group.year,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Transactions List
              ...group.transactions.asMap().entries.map((entry) {
                final index = entry.key;
                final transaction = entry.value;
                final isLast = index == group.transactions.length - 1;

                return Column(
                  children: [
                    Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          group.transactions.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${transaction.title} deleted'),
                          ),
                        );
                      },
                      child: _buildTransactionItem(transaction),
                    ),
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

  Widget _buildTransactionItem(Transaction transaction) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: transaction.iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(transaction.icon, color: Colors.white, size: 24),
          ),

          const SizedBox(width: 16),

          // Transaction Details
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            transaction.amount > 0
                ? '+\$${transaction.amount.abs()}'
                : '-\$${transaction.amount.abs()}',
            style: TextStyle(
              color: transaction.amount > 0
                  ? const Color(0xFF10B981)
                  : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Data Models
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
