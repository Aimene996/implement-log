import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mactest/features/models/custom_category.dart';
import 'package:mactest/features/models/transaction.dart';
import 'package:mactest/features/providers/currency_provider.dart';
import 'package:mactest/features/providers/transaction_provider.dart';
import 'package:mactest/features/services/custom_category_helper.dart';
import 'package:mactest/features/transactions/add_new_transaction.dart';
import 'package:provider/provider.dart';

const double horizontalPadding = 16.0;

final sectionTitleStyle = GoogleFonts.inter(
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

final cardTitleStyle = GoogleFonts.inter(fontSize: 16, color: Colors.white);

final cardValueStyle = GoogleFonts.inter(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

final subtitleStyle = GoogleFonts.inter(
  fontSize: 14,
  color: const Color(0xFF9EABBA),
);

final amountTextStyle = GoogleFonts.inter(fontSize: 16);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() async {
      final customCategories =
          await CustomCategoryHelper.getAllCustomCategories();
      for (CustomCategory category in customCategories) {
        debugPrint('Category: ${category.name}, Type: ${category.type}');
      }
    });

    final currency = Provider.of<CurrencyProvider>(context).currency;
    final symbol = currency.symbol;
    final transactions = context.watch<TransactionProvider>().transactions;

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - (horizontalPadding * 3)) / 2;

    double income = 0;
    double expense = 0;

    for (var t in transactions) {
      if (t.type == 'income') {
        income += t.amount;
      } else if (t.type == 'expense') {
        expense += t.amount;
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'inter',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Overview'),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '$symbol${income.toStringAsFixed(0)}',
                          'Income',
                          cardWidth,
                        ),
                      ),
                      const SizedBox(width: horizontalPadding),
                      Expanded(
                        child: _buildStatCard(
                          '$symbol${expense.toStringAsFixed(0)}',
                          'Expenses',
                          cardWidth,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    (income - expense) == 0
                        ? "\$0"
                        : (income - expense) > 0
                        ? '$symbol${(income - expense).toStringAsFixed(0)}'
                        : '-$symbol${(income - expense).toStringAsFixed(0).substring(1)}',
                    'Savings',
                    cardWidth,
                  ),
                ],
              ),
            ),
            _sectionHeader('Latest'),
            ..._buildLatestTransactions(transactions, symbol, context),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 112,
        height: 56,
        child: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddNewTransaction(),
              ),
            );
          },
          icon: const Icon(Icons.add, size: 24, color: Colors.white),
          label: const Text(
            'Add',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF0F70CF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 8,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      height: 60,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 12,
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      child: Text(title, style: sectionTitleStyle),
    );
  }

  Widget _buildStatCard(String value, String title, double cardWidth) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF293038),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: cardTitleStyle),
          const SizedBox(height: 8),
          Text(value, style: cardValueStyle),
        ],
      ),
    );
  }

  List<Widget> _buildLatestTransactions(
    List<Transaction> allTransactions,
    String symbol,
    BuildContext context,
  ) {
    final latest = List<Transaction>.from(allTransactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    final latestThree = latest.take(allTransactions.length).toList();

    return latestThree.map((transaction) {
      return Dismissible(
        key: Key(transaction.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (_) async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Delete Transaction"),
              content: const Text(
                "Are you sure you want to delete this transaction?",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
          return confirm ?? false;
        },
        onDismissed: (_) {
          Provider.of<TransactionProvider>(
            context,
            listen: false,
          ).deleteTransaction(transaction.id);
        },
        child: _buildTransactionRow(
          transaction.category,
          transaction.note,
          '${transaction.type == 'expense' ? '-' : '+'}$symbol${transaction.amount.toStringAsFixed(0)}',
        ),
      );
    }).toList();
  }

  Widget _buildTransactionRow(String title, String subtitle, String price) {
    return Container(
      width: double.infinity,
      height: 72,
      padding: const EdgeInsets.fromLTRB(
        horizontalPadding,
        8,
        horizontalPadding,
        8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF293038),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Image.asset(
                      _getCategoryImage(title),
                      height: 28, // adjust to desired size
                      width: 28,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.category, color: Colors.white);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subtitle,
                        style: subtitleStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(price, style: amountTextStyle),
        ],
      ),
    );
  }

  String _getCategoryImage(String category) {
    final categoryLower = category.toLowerCase().trim();

    switch (categoryLower) {
      case 'freelance':
        return 'assets/Freelance.png';
      case 'salary':
        return 'assets/Salary.png';
      case 'bonuses':
        return 'assets/Bonuses.png';
      case 'gifts':
        return 'assets/Gifts.png';
      case 'home':
        return 'assets/Home.png';
      case 'business expenses':
        return 'assets/Business Expenses.png';
      case 'charity':
        return 'assets/Charity.png';
      case 'children':
        return 'assets/Children.png';
      case 'clothing & shoes':
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
      case 'mobile and internet':
        return 'assets/Mobile & Internet.png';
      case 'pets':
        return 'assets/Pets.png';
      case 'sports & fitness':
      case 'sports and fitness':
        return 'assets/Sports & Fitness.png';
      case 'taxes & fines':
      case 'taxes and fines':
        return 'assets/Taxes & Fines.png';
      case 'travel':
        return 'assets/Travel.png';
      case 'transportation':
        return 'assets/Transportation.png';
      case 'utilities':
        return 'assets/Utilities.png';
      case 'other':
        return 'assets/Salary.png';
      default:
        return 'assets/Other.png';
    }
  }
}
