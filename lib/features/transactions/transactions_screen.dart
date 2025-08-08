import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mactest/features/providers/currency_provider.dart';
import 'package:provider/provider.dart';

import 'package:mactest/features/models/transaction.dart';
import 'package:mactest/features/services/transaction_helper.dart';
import 'package:mactest/features/transactions/add_new_transaction.dart';

class FakeTransaction extends StatefulWidget {
  const FakeTransaction({super.key});

  @override
  State<FakeTransaction> createState() => _FakeTransactionState();
}

class _FakeTransactionState extends State<FakeTransaction> {
  Map<String, List<Transaction>> groupedTransactions = {};
  Set<String> deletingTransactions = {};

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  // Add this method to get the appropriate image for each category
  String _getCategoryImage(String category) {
    // Convert category to lowercase and handle spaces for consistent matching
    final categoryLower = category.toLowerCase().trim();

    switch (categoryLower) {
      // Income categories
      case 'freelance':
        return 'assets/Freelance.png';
      case 'salary':
        return 'assets/Salary.png';
      case 'bonuses':
        return 'assets/Bonuses.png';
      case 'gifts':
        return 'assets/Gifts.png';

      // Expense categories
      case 'home':
        return 'assets/Home.png';
      case 'business expenses':
        return 'assets/Business Expenses.png';
      case 'charity':
        return 'assets/Charity.png';
      case 'children':
        return 'assets/Children.png';
      case 'clothing & shoes':
        return 'assets/Clothing & Shoes.png';
      case 'clothing and shoes':
        return 'assets/Clothing & Shoes.png';
      case 'education':
        return 'assets/Education.png';
      case 'entertainment':
        return 'assets/Entertainment.png';
      case 'groceries':
        return 'assets/Groceries.png';
      case 'healthcare':
        return 'assets/Healthcare.png';
      case 'insurances':
        return 'assets/Insurances.png';
      case 'mobile & internet':
        return 'assets/Mobile & Internet.png';
      case 'mobile and internet':
        return 'assets/Mobile & Internet.png';
      case 'pets':
        return 'assets/Pets.png';
      case 'sports & fitness':
        return 'assets/Sports & Fitness.png';
      case 'sports and fitness':
        return 'assets/Sports & Fitness.png';
      case 'taxes & fines':
        return 'assets/Taxes & Fines.png';
      case 'taxes and fines':
        return 'assets/Taxes & Fines.png';
      case 'travel':
        return 'assets/Travel.png';
      case 'transportation':
        return 'assets/Transportation.png';
      case 'utilities':
        return 'assets/Utilities.png';
      case 'other':
        return 'assets/Other.png';

      // Default fallback
      default:
        return 'assets/Other.png'; // Use 'Other' as default instead of a non-existent file
    }
  }

  void _loadTransactions() {
    final all = TransactionHelper.getAllTransactions();

    final Map<String, List<Transaction>> grouped = {};
    for (var tx in all) {
      final key = DateFormat('MMMM yyyy').format(tx.date);
      grouped.putIfAbsent(key, () => []).add(tx);
    }

    setState(() {
      groupedTransactions = grouped;
    });
  }

  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    Transaction tx,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF293038),
              title: const Text(
                'Delete Transaction',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                'Are you sure you want to delete this ${tx.category} transaction?',
                style: const TextStyle(color: Color(0xFF9EABBA)),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFF9EABBA)),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<bool> _deleteTransaction(String id, Transaction tx) async {
    if (deletingTransactions.contains(id)) return false;

    final shouldDelete = await _showDeleteConfirmation(context, tx);
    if (!shouldDelete) return false;

    setState(() {
      deletingTransactions.add(id);

      // Remove the transaction locally from groupedTransactions
      final key = DateFormat('MMMM yyyy').format(tx.date);
      final list = groupedTransactions[key];
      if (list != null) {
        list.removeWhere((t) => t.id == id);
        if (list.isEmpty) {
          groupedTransactions.remove(key); // remove group if empty
        }
      }
    });

    try {
      await TransactionHelper.deleteTransaction(id);
      if (mounted) {
        setState(() {
          deletingTransactions.remove(id);
        });
        // Optionally reload full list here if needed
        // _loadTransactions();
      }
      return true;
    } catch (e) {
      if (mounted) {
        setState(() {
          deletingTransactions.remove(id);
        });
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    const titleStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    const subtitleStyle = TextStyle(
      color: Color(0xFF9EABBA),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );

    const amountStyle = TextStyle(
      fontFamily: 'Inter',
      color: Colors.white54,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );

    return Consumer<CurrencyProvider>(
      builder: (context, currencyProvider, child) {
        final symbol = currencyProvider.currency.symbol;

        return Scaffold(
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
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddNewTransaction(),
                    ),
                  );
                  _loadTransactions();
                },
              ),
            ],
          ),
          backgroundColor: const Color(0xFF121212),
          body: SingleChildScrollView(
            child: Column(
              children: groupedTransactions.entries.map((entry) {
                final header = entry.key;
                final transactions = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group header
                    Container(
                      height: 84,
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 44,
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            header.split(' ')[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            header.split(' ')[1],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Transaction list
                    ListView.builder(
                      itemCount: transactions.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        final prefix = tx.type == 'expense' ? '-' : '+';

                        // Skip rendering transactions that are being deleted
                        if (deletingTransactions.contains(tx.id)) {
                          return const SizedBox.shrink();
                        }

                        return Dismissible(
                          key: ValueKey(tx.id),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await _deleteTransaction(tx.id, tx);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 48, // or try 32
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFF293038),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    _getCategoryImage(tx.category),
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        tx.type == 'expense'
                                            ? Icons.arrow_downward
                                            : Icons.arrow_upward,
                                        color: Colors.white,
                                        size: 28,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            title: Text(tx.category, style: titleStyle),
                            subtitle: Text(tx.note, style: subtitleStyle),
                            trailing: Text(
                              '$prefix$symbol${tx.amount}',
                              style: amountStyle,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
