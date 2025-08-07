// import 'package:flutter/material.dart';
// import 'package:mactest/features/models/transaction.dart';
// import 'package:mactest/features/providers/currency_provider.dart';
// import 'package:mactest/features/services/data_service.dart';
// import 'package:mactest/features/report/widgets/chart.dart';
// import 'package:mactest/features/report/widgets/drop_down_button.dart';
// import 'package:provider/provider.dart';

// class ReportScreen extends StatefulWidget {
//   const ReportScreen({super.key});

//   @override
//   State<ReportScreen> createState() => _ReportScreenState();
// }

// class _ReportScreenState extends State<ReportScreen> {
//   List<Transaction> allTransactions = [];
//   double totalIncome = 0;
//   double totalExpense = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadTransactions();
//   }

//   void _loadTransactions() {
//     final transactions = TransactionHelper.getAllTransactions();
//     double income = 0;
//     double expense = 0;

//     for (var t in transactions) {
//       if (t.type == 'income') {
//         income += t.amount;
//       } else if (t.type == 'expense') {
//         expense += t.amount;
//       }
//     }

//     setState(() {
//       allTransactions = transactions;
//       totalIncome = income;
//       totalExpense = expense;
//     });
//   }

//   static const double _verticalSpacing = 16.0;

//   // Helper method to get category totals
//   Map<String, double> _getCategoryTotals(bool isExpenseTab) {
//     final Map<String, double> categoryTotals = {};
//     final filteredTransactions = allTransactions
//         .where((tx) => tx.type == (isExpenseTab ? 'expense' : 'income'))
//         .toList();

//     for (var transaction in filteredTransactions) {
//       categoryTotals[transaction.category] =
//           (categoryTotals[transaction.category] ?? 0) + transaction.amount;
//     }

//     return categoryTotals;
//   }

//   // Category bar widget
//   Widget _buildCategoryBar(
//     String category,
//     double amount,
//     double maxAmount,
//     String currencySymbol,
//   ) {
//     final percentage = maxAmount > 0 ? amount / maxAmount : 0.0;

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           // Category label
//           SizedBox(
//             width: 100,
//             child: Text(
//               category,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Inter',
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           const SizedBox(width: 12),

//           // Progress bar
//           Expanded(
//             child: Stack(
//               alignment: Alignment.centerLeft,
//               children: [
//                 // Bar background
//                 Container(
//                   height: 22,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF243647), // Background color
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),

//                 // Filled part of the bar (with actual percentage)
//                 FractionallySizedBox(
//                   widthFactor: percentage.clamp(0.0, 1.0),
//                   child: Container(
//                     height: 22,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF3B8ED4), // Fill color (blue)
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                 ),

//                 // Amount text inside
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Text(
//                     '$currencySymbol${amount.toStringAsFixed(0)}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabContent({
//     required bool isExpenseTab,
//     required double horizontalPadding,
//     required double dropdownHeight,
//     required double chartHeight,
//     required double screenHeight,
//     required String currencySymbol,
//   }) {
//     final filteredTransactions = allTransactions
//         .where((tx) => tx.type == (isExpenseTab ? 'expense' : 'income'))
//         .toList();

//     // Get category totals for the progress bars
//     final categoryTotals = _getCategoryTotals(isExpenseTab);
//     final maxAmount = categoryTotals.values.isEmpty
//         ? 0.0
//         : categoryTotals.values.reduce((a, b) => a > b ? a : b);

//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: _verticalSpacing),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//             child: Text(
//               isExpenseTab ? "Total Expenses" : "Income View",
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 fontFamily: 'Inter',
//               ),
//             ),
//           ),
//           const SizedBox(height: _verticalSpacing),
//           Container(
//             height: dropdownHeight.clamp(50.0, 80.0),
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//             child: const DropdownButtonExample(),
//           ),
//           const SizedBox(height: _verticalSpacing),
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(horizontalPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   isExpenseTab ? 'Expense' : 'Income',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   isExpenseTab
//                       ? '$currencySymbol${totalExpense.toStringAsFixed(0)}'
//                       : '$currencySymbol${totalIncome.toStringAsFixed(0)}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 32,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'Inter',
//                   ),
//                 ),
//                 const SizedBox(height: _verticalSpacing),
//                 SizedBox(
//                   height: chartHeight.clamp(180.0, 250.0),
//                   width: double.infinity,
//                   child: ChartWidget(
//                     selectedMonth: 'August',
//                     showDimensions: true,
//                     transactionType: isExpenseTab ? 'Expense' : 'Income',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: _verticalSpacing),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//             child: Text(
//               isExpenseTab ? "Expenses By Category" : "Income By Category",
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 fontFamily: 'Inter',
//               ),
//             ),
//           ),
//           const SizedBox(height: _verticalSpacing),
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(horizontalPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   isExpenseTab ? 'Expense' : 'Income',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   isExpenseTab
//                       ? '$currencySymbol${totalExpense.toStringAsFixed(0)}'
//                       : '$currencySymbol${totalIncome.toStringAsFixed(0)}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 32,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'Inter',
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'August',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//                 const SizedBox(height: _verticalSpacing),

//                 // REPLACED LISTVIEW WITH CATEGORY BARS SECTION
//                 categoryTotals.isEmpty
//                     ? Container(
//                         height: 100,
//                         alignment: Alignment.center,
//                         child: Text(
//                           'No ${isExpenseTab ? 'expenses' : 'income'} found',
//                           style: const TextStyle(
//                             color: Colors.white54,
//                             fontSize: 16,
//                             fontFamily: 'Inter',
//                           ),
//                         ),
//                       )
//                     : Column(
//                         children: categoryTotals.entries.map((entry) {
//                           return _buildCategoryBar(
//                             entry.key,
//                             entry.value,
//                             maxAmount,
//                             currencySymbol,
//                           );
//                         }).toList(),
//                       ),
//               ],
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.05),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currencySymbol = Provider.of<CurrencyProvider>(
//       context,
//     ).currency.symbol;

//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     final chartHeight = screenHeight * 0.25;
//     final dropdownHeight = screenHeight * 0.08;
//     final horizontalPadding = screenWidth * 0.04;

//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         backgroundColor: const Color(0xFF121417),
//         appBar: AppBar(
//           backgroundColor: const Color(0xFF121417),
//           elevation: 0,
//           centerTitle: true,
//           title: const Text(
//             'Reports',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 20,
//               fontFamily: 'Inter',
//             ),
//           ),
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(54),
//             child: Container(
//               color: const Color(0xFF121417),
//               padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//               child: TabBar(
//                 indicator: BoxDecoration(
//                   color: const Color(0xFF1D2833),
//                   border: const Border(
//                     bottom: BorderSide(color: Colors.white, width: 3),
//                   ),
//                 ),
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 labelColor: Colors.white,
//                 unselectedLabelColor: Colors.white54,
//                 labelStyle: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   fontFamily: 'Inter',
//                 ),
//                 tabs: const [
//                   Tab(
//                     child: SizedBox(
//                       height: 53,
//                       child: Center(child: Text('Expenses')),
//                     ),
//                   ),
//                   Tab(
//                     child: SizedBox(
//                       height: 53,
//                       child: Center(child: Text('Income')),
//                     ),
//                   ),
//                   Tab(child: SizedBox(height: 53)), // Optional third tab
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _buildTabContent(
//               isExpenseTab: true,
//               horizontalPadding: horizontalPadding,
//               dropdownHeight: dropdownHeight,
//               chartHeight: chartHeight,
//               screenHeight: screenHeight,
//               currencySymbol: currencySymbol,
//             ),
//             _buildTabContent(
//               isExpenseTab: false,
//               horizontalPadding: horizontalPadding,
//               dropdownHeight: dropdownHeight,
//               chartHeight: chartHeight,
//               screenHeight: screenHeight,
//               currencySymbol: currencySymbol,
//             ),
//             const SizedBox.shrink(),
//           ],
//         ),
//       ),
//     );
//   }
// }
