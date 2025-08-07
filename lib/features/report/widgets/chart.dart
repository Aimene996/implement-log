// import 'package:flutter/material.dart';
// import 'package:mactest/features/services/data_service.dart';

// class ChartWidget extends StatefulWidget {
//   final String selectedMonth;
//   final String transactionType; // 'expense' or 'income'
//   final Color primaryColor;
//   final Color backgroundColor;
//   final bool showDimensions;

//   const ChartWidget({
//     super.key,
//     required this.selectedMonth,
//     required this.transactionType,
//     this.primaryColor = const Color(0xFF4A9EFF),
//     this.backgroundColor = const Color(0xFF4A6B7A),
//     this.showDimensions = true,
//   });

//   @override
//   State<ChartWidget> createState() => _ChartWidgetState();
// }

// class _ChartWidgetState extends State<ChartWidget>
//     with SingleTickerProviderStateMixin {
//   int selectedDay = 1;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   Map<int, double> _currentMonthData = {};

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _animation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );

//     _loadTransactionData();
//   }

//   @override
//   void didUpdateWidget(ChartWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.selectedMonth != widget.selectedMonth ||
//         oldWidget.transactionType != widget.transactionType) {
//       _loadTransactionData();
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _loadTransactionData() {
//     _animationController.reset();

//     final currentYear = DateTime.now().year;
//     final monthNumber = _getMonthNumber(widget.selectedMonth);

//     final startDate = DateTime(currentYear, monthNumber, 1);
//     final endDate = DateTime(currentYear, monthNumber + 1, 0);

//     final allTransactions = TransactionHelper.filterByDateRange(
//       startDate,
//       endDate,
//     );
//     final filteredTransactions = allTransactions
//         .where(
//           (t) => t.type.toLowerCase() == widget.transactionType.toLowerCase(),
//         )
//         .toList();

//     final Map<int, double> dailyData = {};
//     for (final transaction in filteredTransactions) {
//       final day = transaction.date.day;
//       dailyData[day] = (dailyData[day] ?? 0) + transaction.amount;
//     }

//     if (dailyData.isEmpty) {
//       dailyData[1] = 0;
//       dailyData[15] = 0;
//       dailyData[endDate.day] = 0;
//     }

//     setState(() {
//       _currentMonthData = dailyData;
//       selectedDay = _currentMonthData.keys.first;
//     });

//     _animationController.forward();
//   }

//   int _getMonthNumber(String monthName) {
//     const months = {
//       'January': 1,
//       'February': 2,
//       'March': 3,
//       'April': 4,
//       'May': 5,
//       'June': 6,
//       'July': 7,
//       'August': 8,
//       'September': 9,
//       'October': 10,
//       'November': 11,
//       'December': 12,
//     };
//     return months[monthName] ?? DateTime.now().month;
//   }

//   String _formatAmount(double amount) {
//     if (amount >= 1000000) {
//       return '${(amount / 1000000).toStringAsFixed(1)}M';
//     } else if (amount >= 1000) {
//       return '${(amount / 1000).toStringAsFixed(1)}K';
//     }
//     return amount.toStringAsFixed(0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Month Label
//           Padding(
//             padding: const EdgeInsets.only(top: 4, left: 12, bottom: 8),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 widget.selectedMonth,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w300,
//                   color: Color(0xFF7FB3D3),
//                   letterSpacing: 1,
//                 ),
//               ),
//             ),
//           ),

//           // Chart Area
//           Expanded(
//             child: _currentMonthData.isEmpty
//                 ? const Center(
//                     child: Text(
//                       'No data available',
//                       style: TextStyle(color: Color(0xFF7FB3D3), fontSize: 14),
//                     ),
//                   )
//                 : Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: AnimatedBuilder(
//                       animation: _animation,
//                       builder: (context, child) {
//                         return Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: _currentMonthData.keys.map((day) {
//                             return _buildDayColumn(day);
//                           }).toList(),
//                         );
//                       },
//                     ),
//                   ),
//           ),

//           // Dimensions Display (selected day + amount)
//           if (widget.showDimensions && _currentMonthData.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: widget.primaryColor,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   'Day ${selectedDay.toString().padLeft(2, '0')} - ${_formatAmount(_currentMonthData[selectedDay] ?? 0)}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDayColumn(int day) {
//     final isSelected = selectedDay == day;
//     final value = _currentMonthData[day] ?? 0.0;
//     final maxValue = _currentMonthData.values.reduce((a, b) => a > b ? a : b);

//     final normalizedHeight = maxValue > 0 ? (value / maxValue) * 0.8 : 0.1;

//     return GestureDetector(
//       onTap: () {
//         final double amount = _currentMonthData[day] ?? 0;

//         setState(() {
//           selectedDay = day; // ← this is crucial!
//         });

//         // Optional: debug output
//         print('Selected Day: $selectedDay, Amount: $amount');
//       },

//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             width: 30,
//             height: (normalizedHeight * 100 * _animation.value).clamp(
//               10.0,
//               100.0,
//             ),
//             decoration: BoxDecoration(
//               color: isSelected
//                   ? const Color(0XFF243647)
//                   : widget.backgroundColor,
//               borderRadius: BorderRadius.circular(3),
//               border: isSelected ? Border.all(width: 1) : null,
//               boxShadow: isSelected
//                   ? [
//                       BoxShadow(
//                         color: widget.primaryColor.withOpacity(0.1),
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ]
//                   : null,
//             ),
//           ),
//           const SizedBox(height: 6),
//           AnimatedDefaultTextStyle(
//             duration: const Duration(milliseconds: 300),
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//               color: isSelected
//                   ? const Color(0xFF91ADC9)
//                   : const Color(0xFF7FB3D3),
//             ),
//             child: Text(day.toString().padLeft(2, '0')),
//           ),
//         ],
//       ),
//     );
//   }
// }
