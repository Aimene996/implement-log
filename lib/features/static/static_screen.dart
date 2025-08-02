// import 'package:flutter/material.dart';

// class ReportsScreen extends StatefulWidget {
//   const ReportsScreen({super.key});

//   @override
//   State<ReportsScreen> createState() => _ReportsScreenState();
// }

// class _ReportsScreenState extends State<ReportsScreen>
//     with TickerProviderStateMixin {
//   late TabController _tabController;
//   late AnimationController _animationController;

//   String selectedPeriod = 'Last 30 days';
//   bool _isLoading = false;

//   // TODO: Replace with Hive data
//   final ReportData _mockData = ReportData();

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _loadData();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   // TODO: Replace with actual Hive data loading
//   Future<void> _loadData() async {
//     setState(() => _isLoading = true);

//     // Simulate data loading
//     await Future.delayed(const Duration(milliseconds: 500));

//     setState(() => _isLoading = false);
//     _animationController.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: _buildAppBar(),
//       body: Column(
//         children: [
//           _buildTabBar(),
//           Expanded(
//             child: _isLoading ? _buildLoadingState() : _buildTabContent(),
//           ),
//         ],
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: AppColors.background,
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Colors.white),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: const Text(
//         'Reports',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       centerTitle: true,
//     );
//   }

//   Widget _buildTabBar() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       child: TabBar(
//         controller: _tabController,
//         indicatorColor: Colors.white,
//         indicatorWeight: 2,
//         indicatorSize: TabBarIndicatorSize.label,
//         labelColor: Colors.white,
//         unselectedLabelColor: AppColors.textSecondary,
//         labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         unselectedLabelStyle: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w400,
//         ),
//         tabs: const [
//           Tab(text: 'Expenses'),
//           Tab(text: 'Income'),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingState() {
//     return const Center(
//       child: CircularProgressIndicator(
//         valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
//       ),
//     );
//   }

//   Widget _buildTabContent() {
//     return TabBarView(
//       controller: _tabController,
//       children: [_buildExpensesTab(), _buildIncomeTab()],
//     );
//   }

//   Widget _buildExpensesTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 16),
//           _buildSectionHeader(),
//           const SizedBox(height: 32),
//           _buildExpenseChart(),
//           const SizedBox(height: 48),
//           _buildCategoryBreakdown(),
//           const SizedBox(height: 32),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           'Total Expenses',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         _buildPeriodSelector(),
//       ],
//     );
//   }

//   Widget _buildPeriodSelector() {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: _showPeriodSelector,
//         borderRadius: BorderRadius.circular(8),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 selectedPeriod,
//                 style: const TextStyle(
//                   color: AppColors.textSecondary,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               const Icon(
//                 Icons.keyboard_arrow_down,
//                 color: AppColors.textSecondary,
//                 size: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildExpenseChart() {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Expenses',
//               style: TextStyle(
//                 color: AppColors.textSecondary,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 8),
//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               child: Text(
//                 '\$${_mockData.totalExpenses.toStringAsFixed(0)}',
//                 key: ValueKey(selectedPeriod),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'November',
//               style: TextStyle(
//                 color: AppColors.textSecondary,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 24),
//             _buildBarChart(),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildBarChart() {
//     final maxValue = _mockData.dailyExpenses.isNotEmpty
//         ? _mockData.dailyExpenses.reduce((a, b) => a > b ? a : b)
//         : 1.0;

//     return Container(
//       height: 200,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: List.generate(_mockData.dailyExpenses.length, (index) {
//           final value = _mockData.dailyExpenses[index];
//           final heightFactor = value / maxValue;
//           final animation = Tween<double>(begin: 0.0, end: heightFactor)
//               .animate(
//                 CurvedAnimation(
//                   parent: _animationController,
//                   curve: Interval(
//                     index * 0.1,
//                     0.6 + (index * 0.1),
//                     curve: Curves.elasticOut,
//                   ),
//                 ),
//               );

//           return AnimatedBuilder(
//             animation: animation,
//             builder: (context, child) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     width: 24,
//                     height: animation.value * 160,
//                     decoration: BoxDecoration(
//                       color: AppColors.primary,
//                       borderRadius: BorderRadius.circular(4),
//                       gradient: LinearGradient(
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                         colors: [
//                           AppColors.primary,
//                           AppColors.primary.withOpacity(0.7),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     _mockData.chartLabels[index],
//                     style: const TextStyle(
//                       color: AppColors.textSecondary,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }

//   Widget _buildCategoryBreakdown() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Expenses by Category',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 24),
//         _buildCategorySummary(),
//         const SizedBox(height: 32),
//         ..._mockData.categoryExpenses.asMap().entries.map((entry) {
//           final index = entry.key;
//           final category = entry.value;
//           return AnimatedBuilder(
//             animation: _animationController,
//             builder: (context, child) {
//               final slideAnimation =
//                   Tween<Offset>(
//                     begin: const Offset(0, 0.5),
//                     end: Offset.zero,
//                   ).animate(
//                     CurvedAnimation(
//                       parent: _animationController,
//                       curve: Interval(
//                         0.2 + (index * 0.1),
//                         0.8 + (index * 0.1),
//                         curve: Curves.easeOutCubic,
//                       ),
//                     ),
//                   );

//               return SlideTransition(
//                 position: slideAnimation,
//                 child: FadeTransition(
//                   opacity: _animationController,
//                   child: _buildCategoryItem(category, index),
//                 ),
//               );
//             },
//           );
//         }).toList(),
//       ],
//     );
//   }

//   Widget _buildCategorySummary() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Expenses',
//           style: TextStyle(
//             color: AppColors.textSecondary,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           '\$${_mockData.totalExpenses.toStringAsFixed(0)}',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         const Text(
//           'November',
//           style: TextStyle(
//             color: AppColors.textSecondary,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCategoryItem(CategoryExpense category, int index) {
//     final percentage = category.amount / _mockData.totalExpenses;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 category.name,
//                 style: const TextStyle(
//                   color: AppColors.textSecondary,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 category.amount.toString(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _buildProgressBar(percentage, category.color),
//         ],
//       ),
//     );
//   }

//   Widget _buildProgressBar(double percentage, Color color) {
//     return Container(
//       height: 8,
//       decoration: BoxDecoration(
//         color: AppColors.cardBackground,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: AnimatedBuilder(
//         animation: _animationController,
//         builder: (context, child) {
//           final progressAnimation = Tween<double>(begin: 0.0, end: percentage)
//               .animate(
//                 CurvedAnimation(
//                   parent: _animationController,
//                   curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
//                 ),
//               );

//           return FractionallySizedBox(
//             alignment: Alignment.centerLeft,
//             widthFactor: progressAnimation.value,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: color,
//                 borderRadius: BorderRadius.circular(4),
//                 boxShadow: [
//                   BoxShadow(
//                     color: color.withOpacity(0.3),
//                     blurRadius: 4,
//                     offset: const Offset(0, 1),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildIncomeTab() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.trending_up,
//             size: 64,
//             color: Colors.green.withOpacity(0.5),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Income Reports',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Coming soon with Hive integration',
//             style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showPeriodSelector() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: AppColors.cardBackground,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) => PeriodSelectorSheet(
//         selectedPeriod: selectedPeriod,
//         onPeriodSelected: (period) {
//           setState(() => selectedPeriod = period);
//           _loadData(); // TODO: Reload data from Hive based on new period
//         },
//       ),
//     );
//   }
// }

// // Separate widget for period selector
// class PeriodSelectorSheet extends StatelessWidget {
//   final String selectedPeriod;
//   final Function(String) onPeriodSelected;

//   const PeriodSelectorSheet({
//     super.key,
//     required this.selectedPeriod,
//     required this.onPeriodSelected,
//   });

//   static const List<String> periods = [
//     'Last 7 days',
//     'Last 30 days',
//     'Last 3 months',
//     'Last year',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: AppColors.textSecondary,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Select Period',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 16),
//           ...periods.map((period) => _buildPeriodItem(context, period)),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   Widget _buildPeriodItem(BuildContext context, String period) {
//     final isSelected = selectedPeriod == period;

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () {
//           onPeriodSelected(period);
//           Navigator.pop(context);
//         },
//         borderRadius: BorderRadius.circular(8),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   period,
//                   style: TextStyle(
//                     color: isSelected ? AppColors.primary : Colors.white,
//                     fontSize: 16,
//                     fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//                   ),
//                 ),
//               ),
//               if (isSelected)
//                 const Icon(Icons.check, color: AppColors.primary, size: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // TODO: Replace with actual Hive model
// class ReportData {
//   final double totalExpenses = 1234;
//   final List<double> dailyExpenses = [220, 280, 250, 290, 240];
//   final List<String> chartLabels = ['01', '02', '03', '05', '07'];
//   final List<CategoryExpense> categoryExpenses = [
//     CategoryExpense(name: 'Groceries', amount: 248, color: AppColors.primary),
//     CategoryExpense(
//       name: 'Transportation',
//       amount: 201,
//       color: AppColors.secondary,
//     ),
//     CategoryExpense(name: 'Housing', amount: 180, color: AppColors.success),
//     CategoryExpense(
//       name: 'Entertainment',
//       amount: 251,
//       color: AppColors.purple,
//     ),
//   ];
// }

// class CategoryExpense {
//   final String name;
//   final int amount;
//   final Color color;

//   CategoryExpense({
//     required this.name,
//     required this.amount,
//     required this.color,
//   });
// }

// // Design system colors
// class AppColors {
//   static const Color background = Color(0xFF1A1D21);
//   static const Color cardBackground = Color(0xFF2A2D31);
//   static const Color textSecondary = Color(0xFF9CA3AF);
//   static const Color primary = Color(0xFF4F46E5);
//   static const Color secondary = Color(0xFF06B6D4);
//   static const Color success = Color(0xFF10B981);
//   static const Color purple = Color(0xFF8B5CF6);
// }
