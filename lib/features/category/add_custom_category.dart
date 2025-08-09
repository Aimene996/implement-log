import 'package:flutter/material.dart';
import 'package:mactest/features/providers/custom_category.dart';
import 'package:provider/provider.dart';
import 'package:mactest/features/services/custom_category_helper.dart';

class AddCustomCategory extends StatefulWidget {
  const AddCustomCategory({super.key, required this.transactionType});
  final String transactionType;

  @override
  State<AddCustomCategory> createState() => _AddCustomCategoryState();
}

class _AddCustomCategoryState extends State<AddCustomCategory> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveCustomCategory() async {
    final String name = _controller.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a category name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create and get the new category instance directly
      final created = await CustomCategoryHelper.addCategoryWithName(
        name,
        widget.transactionType,
      );

      // Refresh provider state
      final provider = Provider.of<CustomCategoryProvider>(
        context,
        listen: false,
      );
      await provider.loadCategories(type: widget.transactionType);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Return the created custom category to the previous screen
        Navigator.of(context).pop(created);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving category: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121417),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'New Category',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 319),
                      child: SizedBox(
                        height: 47,
                        width: 390,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Name the custom Categories',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B3036),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _controller,
                          enabled: !_isLoading,
                          decoration: const InputDecoration(
                            hintText: 'Category Name',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 16,
                      ),
                      child: GestureDetector(
                        onTap: _isLoading ? null : _saveCustomCategory,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Container(
                            height: 50,
                            width: 390,
                            decoration: BoxDecoration(
                              color: _isLoading
                                  ? const Color(0xFFCFDEED).withOpacity(0.5)
                                  : const Color(0xFFCFDEED),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: _isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      'Save',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
