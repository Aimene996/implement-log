import 'package:flutter/material.dart';
import 'package:mactest/features/models/custom_category.dart';
import 'package:mactest/features/providers/currency_provider.dart';
import 'package:mactest/features/services/custom_category_helper.dart';
import 'package:mactest/features/services/settings_helper.dart';
import 'package:mactest/features/settings/widgets/reset_dialog.dart';
import 'package:mactest/features/models/currency.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<CustomCategory> incomeCategories = [];
  List<CustomCategory> expensesCategories = [];

  void fetchCustomCategories() async {
    final customCategories =
        await CustomCategoryHelper.getAllCustomCategories();

    final List<CustomCategory> incomeList = [];
    final List<CustomCategory> expenseList = [];

    for (CustomCategory category in customCategories) {
      if (category.type.toLowerCase() == 'income') {
        incomeList.add(category);
      } else if (category.type.toLowerCase() == 'expense') {
        expenseList.add(category);
      }
      debugPrint('Category: ${category.name}, Type: ${category.type}');
    }

    setState(() {
      incomeCategories = incomeList;
      expensesCategories = expenseList;
    });
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
    _loadCategories();
    fetchCustomCategories();
  }

  Future<void> _loadCurrency() async {
    final currency = await CurrencyService.getCurrency();
    setState(() {
      selectedCurrencyCode = currency.code;
    });
  }

  Future<void> _loadCategories() async {
    final income = await CustomCategoryHelper.getCustomCategoriesByType(
      'Income',
    );
    final expense = await CustomCategoryHelper.getCustomCategoriesByType(
      'Expense',
    );
    setState(() {
      incomeCategories = income;
      expensesCategories = expense;
    });
  }

  Future<void> _deleteCategory(CustomCategory category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await category.delete();
      await _loadCategories();
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

                    _buildSectionTitle('Custom Categories'),
                    _buildSubTitle('Income'),
                    _buildCategoryWrap(incomeCategories),

                    _buildSubTitle('Expenses'),
                    _buildCategoryWrap(expensesCategories),

                    const Spacer(),

                    // Reset button
                    GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => ConfirmResetDialog(
                          onConfirm: () => Navigator.of(context).pop(),
                          onCancel: () => Navigator.of(context).pop(),
                        ),
                      ),
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

                Provider.of<CurrencyProvider>(
                  context,
                  listen: false,
                ).updateCurrency(selected);
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
      width: 390,
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
