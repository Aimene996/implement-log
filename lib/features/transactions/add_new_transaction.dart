import 'package:flutter/material.dart';
import 'package:mactest/features/category/add_category_screen.dart';

class AddNewTransaction extends StatefulWidget {
  const AddNewTransaction({super.key});

  @override
  State<AddNewTransaction> createState() => _AddNewTransactionState();
}

class _AddNewTransactionState extends State<AddNewTransaction> {
  String selectedType = 'expense';
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1D21),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Transaction',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Type Selector
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2D31),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Expense Container
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedType = 'expense';
                        });
                      },
                      child: Container(
                        height: 32,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: selectedType == 'expense'
                              ? const Color(0xFF121417)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: selectedType == 'expense'
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF000000,
                                    ).withOpacity(0.1),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 0),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Expense',
                            style: TextStyle(
                              color: selectedType == 'expense'
                                  ? Colors.white
                                  : const Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Income Container
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedType = 'income';
                        });
                      },
                      child: Container(
                        height: 32,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: selectedType == 'income'
                              ? const Color(0xFF121417)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: selectedType == 'income'
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF000000,
                                    ).withOpacity(0.1),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 0),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Income',
                            style: TextStyle(
                              color: selectedType == 'income'
                                  ? Colors.white
                                  : const Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Category Section
            const Text(
              'Category',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Add Category Button
            GestureDetector(
              onTap: () {
                // Handle add category
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddCategoryScreen(),
                  ),
                );
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2D31),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        Icons.add,
                        color: Color(0xFF9CA3AF),
                        size: 20,
                      ),
                    ),
                    Text(
                      'Add a category',
                      style: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Amount Section
            const Text(
              'Amount',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Amount Input
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2D31),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: amountController,
                style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                decoration: const InputDecoration(
                  hintText: r'$0.00',
                  hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),

            const SizedBox(height: 32),

            // Date Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Date',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: Color(0xFF121417),
                              surface: Color(0xFF2A2D31),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Note Section
            const Text(
              'Note',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Note Input
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2D31),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: noteController,
                style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Add a note',
                  hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Save Button
            Container(
              width: double.infinity,
              height: 52,
              margin: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Handle save transaction
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5E7EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Color(0xFF1A1D21),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
