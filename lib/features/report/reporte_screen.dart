import 'package:flutter/material.dart';
import 'package:mactest/features/models/transaction.dart';
import 'package:mactest/features/services/transaction_helper.dart';
import 'package:mactest/features/providers/currency_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mactest/features/providers/transaction_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  List<Transaction> allTransactions = [];
  List<Transaction> filteredTransactions = [];
  double totalIncome = 0;
  double totalExpense = 0;
  TransactionProvider? _txProviderRef;
  VoidCallback? _txListener;

  DateTime? _customStartDate;
  DateTime? _customEndDate;

  late TabController _tabController;

  final List<String> _filterOptions = [
    'All',
    'Last 7 Days',
    'Last 30 Days',
    'This Month',
    'Last Month',
    'Custom',
  ];
  String _selectedFilter = 'This Month';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTransactions();
    // Refresh when transactions change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _txProviderRef = context.read<TransactionProvider>();
      _txListener = () {
        if (!mounted) return;
        _loadTransactions();
      };
      _txProviderRef!.addListener(_txListener!);
    });
  }

  @override
  void dispose() {
    try {
      if (_txProviderRef != null && _txListener != null) {
        _txProviderRef!.removeListener(_txListener!);
      }
    } catch (_) {}
    _tabController.dispose();
    super.dispose();
  }

  void _loadTransactions() {
    final transactions = TransactionHelper.getAllTransactions();
    if (!mounted) return;
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
      case 'All':
        return allTransactions;
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

  List<Transaction> _getTransactionsForType(bool isExpense) {
    final list = filteredTransactions
        .where((tx) => tx.type == (isExpense ? 'expense' : 'income'))
        .toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
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
        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            backgroundColor: const Color(0xFF121212),
            elevation: 0,
            toolbarHeight: 120,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                width: double.infinity,
                color: const Color(0xFF334D66),
              ),
            ),
            title: Text(
              'Reports',
              style: TextStyle(
                fontFamily: 'Inter',
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 250, // Fixed width to contain both tabs
                    child: TabBar(
                      controller: _tabController,
                      indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(color: Colors.white, width: 3),
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white54,
                      labelStyle: TextStyle(
                        fontFamily: 'Inter',
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
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
                transactionsForChart: _getTransactionsForType(true),
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
                transactionsForChart: _getTransactionsForType(false),
                transactionMonth: dateRangeText,
              ),
            ],
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
  final List<Transaction> transactionsForChart;

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
    required this.transactionsForChart,
  });

  // _buildFullMonthBars removed; replaced by _buildBarsFromTransactions

  List<Widget> _buildBarsFromTransactions(List<Transaction> txs) {
    if (txs.isEmpty) return [];
    // Group by day
    final Map<DateTime, double> perDay = {};
    for (final tx in txs) {
      final key = DateTime(tx.date.year, tx.date.month, tx.date.day);
      perDay[key] = (perDay[key] ?? 0) + tx.amount;
    }
    final entries = perDay.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final maxVal = entries
        .map((e) => e.value)
        .fold<double>(0.0, (p, v) => v > p ? v : p);
    return entries.map((e) {
      final barHeight = maxVal > 0 ? (e.value / maxVal) * 150 : 0.0;
      final label = DateFormat('d').format(e.key);
      return Container(
        width: 30,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: barHeight,
              color: const Color(0xFF243647),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF9EABBA),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final rate = context.watch<CurrencyProvider>().rateFromBase;
    final convertedTotal = (totalAmount * rate).toStringAsFixed(0);
    final isExpense = type == 'expense';

    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxAmount = sortedCategories.isNotEmpty
        ? sortedCategories.first.value
        : 1.0;

    // Build bars directly from transactionsForChart; no need to sort dailyTotals here

    // maxDailyTotal not needed after switching to _buildFullMonthBars

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
                  style: TextStyle(
                    fontFamily: 'Inter',
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
                          style: TextStyle(
                            fontFamily: 'Inter',
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
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$currencySymbol$convertedTotal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              transactionMonth,
              style: TextStyle(
                fontFamily: 'Inter',
                color: const Color(0xFF9EABBA),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            // Horizontally scrollable daily totals chart (one bar per day with transactions)
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _buildBarsFromTransactions(transactionsForChart),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              isExpense ? 'Expenses by Category' : 'Income by Category',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isExpense ? 'Expenses' : 'Income',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$currencySymbol$convertedTotal',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              transactionMonth,
              style: TextStyle(
                fontFamily: 'Inter',
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
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: const Color(0xFF9EABBA),
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else
              ...sortedCategories.map(
                (entry) =>
                    _buildCategoryBar(entry.key, entry.value, maxAmount, rate),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBar(
    String title,
    double amount,
    double maxAmount,
    double rate,
  ) {
    double percentage = maxAmount > 0 ? amount / maxAmount : 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
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
                      (amount * rate).toStringAsFixed(0),
                      style: TextStyle(
                        fontFamily: 'Inter',
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
