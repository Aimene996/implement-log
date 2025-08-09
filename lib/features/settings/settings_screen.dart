import 'package:flutter/material.dart';
import 'package:mactest/features/models/custom_category.dart';
import 'package:mactest/features/providers/currency_provider.dart';
import 'package:mactest/features/providers/custom_category.dart'; // Add this import
import 'package:mactest/features/services/settings_helper.dart';
import 'package:mactest/features/settings/widgets/reset_dialog.dart';
import 'package:mactest/features/models/currency.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:mactest/features/models/transaction.dart';
import 'package:mactest/features/providers/transaction_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<CustomCategory> incomeCategories = [];
  List<CustomCategory> expensesCategories = [];
  bool isLoading = false;

  // Updated method using provider
  Future<void> fetchCustomCategories() async {
    setState(() => isLoading = true);

    final provider = Provider.of<CustomCategoryProvider>(
      context,
      listen: false,
    );

    try {
      // Load income categories
      await provider.loadCategories(type: 'income');
      final List<CustomCategory> incomeList = List.from(provider.categories);

      // Load expense categories
      await provider.loadCategories(type: 'expense');
      final List<CustomCategory> expenseList = List.from(provider.categories);

      setState(() {
        incomeCategories = incomeList;
        expensesCategories = expenseList;
      });

      // Debug prints
      for (CustomCategory category in [...incomeList, ...expenseList]) {
        debugPrint('Category: ${category.name}, Type: ${category.type}');
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  String selectedCurrencyCode = 'USD';

  final List<String> currencies = [
    'USD – \$ – US Dollar',
    'EUR – € – Euro',
    'JPY – ¥ – Japanese Yen',
    'GBP – £ – British Pound',
    'AUD – A\$ – Australian Dollar',
    'CAD – C\$ – Canadian Dollar',
    'CHF – CHF – Swiss Franc',
    'CNY – ¥ – Chinese Yuan',
    'HKD – HK\$ – Hong Kong Dollar',
    'RUB – ₽ – Russian Ruble',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrency();
    fetchCustomCategories(); // Use the updated method
  }

  Future<void> _loadCurrency() async {
    final currency = await CurrencyService.getCurrency();
    setState(() {
      selectedCurrencyCode = currency.code;
    });
  }

  // Updated delete method using provider
  Future<void> _deleteCategory(CustomCategory category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2B3036), // Match your theme
        title: const Text(
          'Delete Category',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${category.name}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final provider = Provider.of<CustomCategoryProvider>(
          context,
          listen: false,
        );
        await provider.deleteCategory(category.key!, category.type);

        // Refresh the categories
        await fetchCustomCategories();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category deleted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting category: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // Old deleteAllCategories kept for reference; replaced by _resetAllData

  // Function to show the Delete All confirmation dialog (for Delete All button)
  // Future<void> _showDeleteAllDialog() async {
  //   final confirmed = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: const Color(0xFF2B3036),
  //       title: const Text(
  //         'Delete All Categories',
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       content: const Text(
  //         'Are you sure you want to delete all custom categories? This action cannot be undone.',
  //         style: TextStyle(color: Colors.white70),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(false),
  //           child: const Text(
  //             'Cancel',
  //             style: TextStyle(color: Colors.white70),
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(true),
  //           child: const Text(
  //             'Delete All',
  //             style: TextStyle(color: Colors.red),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (confirmed == true) {
  //     await _deleteAllCategories();
  //   }
  // }

  // Function to show the Reset confirmation dialog (for Reset button)
  void _showResetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmResetDialog(
        onConfirm: () {
          Navigator.of(context).pop(); // Close the dialog first
          _resetAllData();
        },
        onCancel: () {
          Navigator.of(context).pop(); // Just close the dialog
        },
      ),
    );
  }

  Future<void> _resetAllData() async {
    setState(() => isLoading = true);
    try {
      // Clear Hive boxes
      final transactionsBox = Hive.box<Transaction>('transactions');
      final customCategoriesBox = Hive.box<CustomCategory>('custom_categories');
      final currencyBox = Hive.box<Currency>('currencyBox');

      await Future.wait([
        transactionsBox.clear(),
        customCategoriesBox.clear(),
        currencyBox.clear(),
      ]);

      // Reset providers/state
      if (!mounted) return;
      final currencyProvider = context.read<CurrencyProvider>();
      await currencyProvider.updateCurrency(
        Currency(code: 'USD', symbol: '\$', name: 'US Dollar'),
      );

      await context.read<CustomCategoryProvider>().loadCategories();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      context.read<TransactionProvider>().refresh();
      setState(() {
        incomeCategories = [];
        expensesCategories = [];
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data has been reset.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reset data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', textAlign: TextAlign.center),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildCurrencyDropdown(),

                    // Custom Categories Section with Delete All button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_buildSectionTitle('Custom Categories')],
                    ),

                    _buildSubTitle('Income'),
                    isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : incomeCategories.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 26,
                              vertical: 8,
                            ),
                            child: Text(
                              'There is no custom category',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : _buildCategoryWrap(incomeCategories),

                    _buildSubTitle('Expenses'),
                    isLoading
                        ? const SizedBox.shrink() // Don't show loading twice
                        : expensesCategories.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 26,
                              vertical: 8,
                            ),
                            child: Text(
                              'There is no custom category',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : _buildCategoryWrap(expensesCategories),

                    const Spacer(),

                    // Reset button - UPDATED
                    GestureDetector(
                      onTap:
                          _showResetDialog, // Now properly calls the reset dialog function
                      child: Container(
                        width: 358,
                        height: 40,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFF2B3036),
                        ),
                        child: const Center(
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
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

  Widget _buildCurrencyDropdown() {
    return Container(
      width: 390,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Currency',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          DropdownButton<String>(
            value: selectedCurrencyCode,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            onChanged: (String? newValue) async {
              if (newValue != null) {
                setState(() {
                  selectedCurrencyCode = newValue;
                });

                final match = currencies.firstWhere(
                  (c) => c.startsWith(newValue),
                );
                final parts = match.split(' – ');
                final selected = Currency(
                  code: parts[0],
                  symbol: parts[1],
                  name: parts[2],
                );

                await Provider.of<CurrencyProvider>(
                  context,
                  listen: false,
                ).updateCurrency(selected);

                if (mounted) {
                  final rate = context.read<CurrencyProvider>().rateFromBase;
                  final rateMsg = selected.code == 'USD'
                      ? '1 USD = 1 USD'
                      : '1 USD ≈ ${rate.toStringAsFixed(2)} ${selected.code}';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Currency updated to ${selected.code}. $rateMsg',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            items: currencies.map((String value) {
              final code = value.split(' – ')[0];
              return DropdownMenuItem<String>(value: code, child: Text(code));
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      height: 47,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildSubTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 26, top: 12, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildCategoryWrap(List<CustomCategory> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children: categories
            .map((category) => _buildCategoryCard(context, category))
            .toList(),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CustomCategory category) {
    return Container(
      width: 173,
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF2B3036),
      ),
      child: Row(
        children: [
          const Icon(Icons.help_outline, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              category.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => _deleteCategory(category),
            child: const Icon(Icons.delete, size: 20),
          ),
        ],
      ),
    );
  }
}
