import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mactest/features/models/category_item.dart';
import 'package:mactest/features/models/custom_category.dart';
import 'package:mactest/features/providers/custom_category.dart';
// import 'package:mactest/features/providers/custom_category.dart';
import 'package:mactest/features/providers/transaction_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// Models
import 'package:mactest/features/models/transaction.dart';
import 'package:mactest/features/models/currency.dart';

// Providers
import 'package:mactest/features/providers/currency_provider.dart';
import 'package:mactest/features/providers/report_provider.dart'; // ⬅️ Make sure you have this file

// Screens
import 'package:mactest/features/Feed/navigation_tab_bar.dart';

// Theme
import 'package:mactest/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  Directory appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  // Register Hive Adapters
  Hive.registerAdapter(CategoryItemAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CurrencyAdapter());
  Hive.registerAdapter(CustomCategoryAdapter());

  // Open Hive Boxes
  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<Currency>('currencyBox');
  await Hive.openBox<CustomCategory>('custom_categories');
  //await TransactionHelper.initCategoryBox();

  // Run App with Providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => CustomCategoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MacTest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: NavigationTabBar(),
    );
  }
}
