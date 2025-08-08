import 'package:flutter/material.dart';
import 'package:mactest/features/models/transaction.dart';
import 'package:mactest/features/services/transaction_helper.dart';
import 'package:mactest/features/providers/currency_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<Transaction> allTransactions = [];
  List<Transaction> filteredTransactions = [];
  double totalIncome = 0;
  double totalExpense = 0;

  DateTime? _customStartDate;
  DateTime? _customEndDate;

  final List<String> _filterOptions = [
    'Last 7 Days',
    'Last 30 Days',
    'This Month',
    'Last Month',
    'Custom',
  ];
  String _selectedFilter = 'Last 30 Days';

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    final transactions = TransactionHelper.getAllTransactions();
    setState(() {
      allTransactions = transactions;
      filteredTransactions = _applyDateFilter(_selectedFilter);
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    double income = 0;
    double expense = 0;

    for (var t in filteredTransactions) {
      if (t.type == 'income') {
        income += t.amount;
      } else if (t.type == 'expense') {
        expense += t.amount;
      }
    }

    setState(() {
      totalIncome = income;
      totalExpense = expense;
    });
  }

  Future<void> _selectCustomDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _customStartDate != null && _customEndDate != null
          ? DateTimeRange(start: _customStartDate!, end: _customEndDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _customStartDate = picked.start;
        _customEndDate = picked.end;
        _selectedFilter = 'Custom';
        filteredTransactions = _applyDateFilter(_selectedFilter);
        _calculateTotals();
      });
    } else {
      setState(() {
        _selectedFilter = 'Last 30 Days';
        filteredTransactions = _applyDateFilter(_selectedFilter);
        _calculateTotals();
      });
    }
  }

  void _onFilterChanged(String? newFilter) {
    if (newFilter != null) {
      if (newFilter == 'Custom') {
        _selectCustomDateRange();
      } else {
        setState(() {
          _selectedFilter = newFilter;
          filteredTransactions = _applyDateFilter(_selectedFilter);
          _calculateTotals();
        });
      }
    }
  }

  List<Transaction> _applyDateFilter(String filter) {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;

    switch (filter) {
      case 'Last 7 Days':
        startDate = now.subtract(const Duration(days: 6));
        break;
      case 'Last 30 Days':
        startDate = now.subtract(const Duration(days: 29));
        break;
      case 'This Month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Last Month':
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        startDate = lastMonth;
        endDate = DateTime(now.year, now.month, 0);
        break;
      case 'Custom':
        if (_customStartDate != null && _customEndDate != null) {
          startDate = _customStartDate!;
          endDate = _customEndDate!;
        } else {
          return allTransactions;
        }
        break;
      default:
        return allTransactions;
    }

    return allTransactions.where((tx) {
      return tx.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          tx.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  Map<String, double> _getCategoryTotals(bool isExpenseTab) {
    final Map<String, double> categoryTotals = {};
    final transactionsForTab = filteredTransactions
        .where((tx) => tx.type == (isExpenseTab ? 'expense' : 'income'))
        .toList();

    for (var transaction in transactionsForTab) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }
    return categoryTotals;
  }

  // Updated to return a Map of dates and their totals
  Map<DateTime, double> _getDailyTotals(bool isExpense) {
    final Map<DateTime, double> dailyTotals = {};

    final transactionsForType = filteredTransactions
        .where((tx) => tx.type == (isExpense ? 'expense' : 'income'))
        .toList();

    for (var transaction in transactionsForType) {
      // Use only the date part as the key to group by day
      final dateKey = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0) + transaction.amount;
    }

    return dailyTotals;
  }

  String _getMonthOrDateRange() {
    if (filteredTransactions.isEmpty) {
      return 'No Transactions';
    }

    // Sort transactions by date to find the start and end dates
    filteredTransactions.sort((a, b) => a.date.compareTo(b.date));
    final startDate = filteredTransactions.first.date;
    final endDate = filteredTransactions.last.date;

    // If all transactions are in the same month, show just the month name
    if (startDate.year == endDate.year && startDate.month == endDate.month) {
      return DateFormat('MMMM y').format(startDate);
    }
    // If the range is within the same year, show the month-to-month range
    else if (startDate.year == endDate.year) {
      return '${DateFormat('MMM').format(startDate)} - ${DateFormat('MMM y').format(endDate)}';
    }
    // For ranges spanning multiple years, show the full date range
    else {
      return '${DateFormat('MMM y').format(startDate)} - ${DateFormat('MMM y').format(endDate)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String dateRangeText = _getMonthOrDateRange();

    return Consumer<CurrencyProvider>(
      builder: (context, currencyProvider, child) {
        return DefaultTabController(
          length: 2, // Corrected: Set length to 2 to match the number of tabs
          child: Scaffold(
            backgroundColor: const Color(0xFF121212),
            appBar: AppBar(
              backgroundColor: const Color(0xFF121212),
              elevation: 0,
              toolbarHeight: 120,

              title: Text(
                'Reports',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              centerTitle: true,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 100),
                  TabBar(
                    indicator: const BoxDecoration(
                      // color: Color(0xFF1D2833),
                      border: Border(
                        bottom: BorderSide(color: Colors.white, width: 3),
                      ),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white54,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    tabs: const [
                      Tab(
                        child: SizedBox(
                          height: 53,
                          child: Center(child: Text('Expenses')),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          height: 53,
                          child: Center(child: Text('Income')),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          height: 53,
                          child: Center(child: Text('')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                TransactionTab(
                  type: 'expense',
                  totalAmount: totalExpense,
                  categoryTotals: _getCategoryTotals(true),
                  currencySymbol: currencyProvider.currency.symbol,
                  filterOptions: _filterOptions,
                  selectedFilter: _selectedFilter,
                  onFilterChanged: _onFilterChanged,
                  dailyTotals: _getDailyTotals(true),
                  transactionMonth: dateRangeText,
                ),
                TransactionTab(
                  type: 'income',
                  totalAmount: totalIncome,
                  categoryTotals: _getCategoryTotals(false),
                  currencySymbol: currencyProvider.currency.symbol,
                  filterOptions: _filterOptions,
                  selectedFilter: _selectedFilter,
                  onFilterChanged: _onFilterChanged,
                  dailyTotals: _getDailyTotals(false),
                  transactionMonth: dateRangeText,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TransactionTab extends StatelessWidget {
  final String type;
  final double totalAmount;
  final Map<String, double> categoryTotals;
  final String currencySymbol;
  final List<String> filterOptions;
  final String selectedFilter;
  final Function(String?) onFilterChanged;
  final Map<DateTime, double> dailyTotals;
  final String transactionMonth;

  const TransactionTab({
    super.key,
    required this.type,
    required this.totalAmount,
    required this.categoryTotals,
    required this.currencySymbol,
    required this.filterOptions,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.dailyTotals,
    required this.transactionMonth,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = type == 'expense';

    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxAmount = sortedCategories.isNotEmpty
        ? sortedCategories.first.value
        : 1.0;

    // Sort dailyTotals by date to display them in chronological order
    final sortedDailyTotals = dailyTotals.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final maxDailyTotal = dailyTotals.values.isNotEmpty
        ? dailyTotals.values.reduce((curr, next) => curr > next ? curr : next)
        : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExpense ? 'Total Expenses' : 'Total Income',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    // color: const Color(0xFF243647),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedFilter,
                    dropdownColor: const Color(0xFF1D2833),
                    underline: const SizedBox(),
                    onChanged: onFilterChanged,
                    items: filterOptions.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              isExpense ? 'Expenses' : 'Income',
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text(
              '$currencySymbol${totalAmount.toStringAsFixed(0)}',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              transactionMonth,
              style: GoogleFonts.inter(
                color: const Color(0xFF9EABBA),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            // Corrected Row to align chart columns to the bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.end, // Align items to the bottom
              children: sortedDailyTotals.map((entry) {
                final date = entry.key;
                final amount = entry.value;
                final barHeight = maxDailyTotal > 0
                    ? (amount / maxDailyTotal) * 150
                    : 0.0;
                final dateLabel = DateFormat('d').format(date);

                return Container(
                  width: 30, // Use a fixed width for consistent spacing
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // Ensure the column takes up minimal space
                    children: [
                      Container(
                        width: 16,
                        height: barHeight,
                        color: const Color(0xFF243647),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateLabel,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF9EABBA),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Text(
              isExpense ? 'Expenses by Category' : 'Income by Category',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isExpense ? 'Expenses' : 'Income',
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text(
              '$currencySymbol${totalAmount.toStringAsFixed(0)}',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              transactionMonth,
              style: GoogleFonts.inter(
                color: const Color(0xFF9EABBA),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            if (sortedCategories.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    isExpense
                        ? 'No expense data available'
                        : 'No income data available',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9EABBA),
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else
              ...sortedCategories.map(
                (entry) => _buildCategoryBar(entry.key, entry.value, maxAmount),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBar(String title, double amount, double maxAmount) {
    double percentage = maxAmount > 0 ? amount / maxAmount : 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: const Color(0xFF9EABBA),
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
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 21, 32, 43),
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
                      amount.toStringAsFixed(0),
                      style: GoogleFonts.inter(
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
