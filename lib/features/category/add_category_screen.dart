import 'package:flutter/material.dart';
import 'package:mactest/features/category/add_custom_category.dart';
import 'package:mactest/features/category/category_item.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key, required this.transactionType});
  final String transactionType; // Now required

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  CategoryItem? selectedCategory;
  late List<CategoryItem> filteredCategories;

  @override
  void initState() {
    super.initState();
    // Filter based on type (e.g., "Expense" or "Income")
    filteredCategories = allCategories.where((category) {
      return category.type.toLowerCase() ==
          widget.transactionType.toLowerCase();
    }).toList();
    print(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1D21),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Categories',
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
            Text(
              '${widget.transactionType} Category',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: filteredCategories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  final isSelected = selectedCategory!=null && selectedCategory!.title == category.title;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = isSelected ? null : category;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF374151)
                            : const Color(0xFF2A2D31),
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: const Color(0xFF3B82F6),
                                width: 2,
                              )
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              category.imagePath,
                              width: 24,
                              height: 24,
                              color: Colors.white,
                            ),
                            // Icon(category.imagePath, color: Colors.white, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                category.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Add Custom Category Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddCustomCategory(
                        transactionType: widget.transactionType,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF374151),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add Custom Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Select Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: selectedCategory != null
                    ? () => Navigator.pop(context, selectedCategory)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedCategory != null
                      ? const Color(0xFFE5E7EB)
                      : const Color(0xFF4B5563),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Select Category',
                  style: TextStyle(
                    color: selectedCategory != null
                        ? const Color(0xFF1A1D21)
                        : const Color(0xFF9CA3AF),
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
}

// Category item model stays the same
class CategoryItem {
  final String title;
  final String imagePath;
  final String type;

  CategoryItem({
    required this.title,
    required this.imagePath,
    required this.type,
  });
}
