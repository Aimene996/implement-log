// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:mactest/features/models/transaction.dart';
// import 'package:mactest/features/services/data_service.dart';
// import 'package:mactest/features/transactions/add_new_transaction.dart';

// class TransactionsScreen extends StatefulWidget {
//   const TransactionsScreen({super.key});

//   @override
//   State<TransactionsScreen> createState() => _TransactionsScreenState();
// }

// class _TransactionsScreenState extends State<TransactionsScreen> {
//   Map<String, List<Transaction>> groupedTransactions = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadTransactions();
//   }

//   Future<void> _loadTransactions() async {
//     final allTransactions = TransactionHelper.getAllTransactions();
//     final Map<String, List<Transaction>> tempGrouped = {};

//     for (var tx in allTransactions) {
//       final key = DateFormat.yMMMM().format(tx.date); // e.g., "March 2025"
//       tempGrouped.putIfAbsent(key, () => []).add(tx);
//     }

//     setState(() {
//       groupedTransactions = tempGrouped;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1D21),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1A1D21),
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'Transactions',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add, color: Colors.white),
//             onPressed: () async {
//               await Navigator.of(context).push(
//                 MaterialPageRoute(builder: (_) => const AddNewTransaction()),
//               );
//               _loadTransactions(); // Refresh after adding
//             },
//           ),
//         ],
//       ),
//       body: groupedTransactions.isEmpty
//           ? const Center(
//               child: Text(
//                 "No transactions",
//                 style: TextStyle(color: Colors.white),
//               ),
//             )
//           : ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               children: groupedTransactions.entries.map((entry) {
//                 final dateKey = entry.key;
//                 final txs = entry.value;

//                 return _buildTransactionGroup(dateKey, txs);
//               }).toList(),
//             ),
//     );
//   }

//   Widget _buildTransactionGroup(String dateKey, List<Transaction> txs) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Header: Month Year
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: Row(
//             children: [
//               Text(
//                 dateKey,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const Spacer(),
//               Text(
//                 DateFormat.y().format(txs.first.date), // dynamic year
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//         ),

//         ...txs.asMap().entries.map((entry) {
//           final index = entry.key;
//           final transaction = entry.value;
//           final isLast = index == txs.length - 1;

//           return Column(
//             children: [
//               Dismissible(
//                 key: ValueKey(transaction.id),
//                 direction: DismissDirection.endToStart,
//                 background: Container(
//                   alignment: Alignment.centerRight,
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(Icons.delete, color: Colors.white),
//                 ),
//                 onDismissed: (_) async {
//                   await TransactionHelper.deleteTransaction(transaction.id);
//                   _loadTransactions();
//                 },
//                 child: _buildTransactionItem(transaction),
//               ),
//               if (!isLast) const SizedBox(height: 16),
//             ],
//           );
//         }),

//         const SizedBox(height: 32),
//       ],
//     );
//   }

//   Widget _buildTransactionItem(Transaction transaction) {
//     final isIncome = transaction.type == 'income';
//     final prefix = isIncome ? '+' : '-';

//     return Container(
//       height: 64,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           // Icon container
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
//             child: const Icon(
//               Icons.add_ic_call_outlined,
//               color: Colors.white,
//               size: 24,
//             ),
//           ),
//           const SizedBox(width: 16),

//           // Title + Note
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   groupedTransactions.entries.first.value.toString(),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   transaction.note,
//                   style: const TextStyle(
//                     color: Color(0xFF9CA3AF),
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Amount
//           Text(
//             '$prefix\$${transaction.amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               color: isIncome ? const Color(0xFF10B981) : Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
