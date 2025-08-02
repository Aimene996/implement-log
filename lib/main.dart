import 'package:flutter/material.dart';
import 'package:mactest/features/navigation/navigation_tab_bar.dart';
import 'package:mactest/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MacTest',
      theme: AppTheme.darkTheme, // <-- apply custom theme here
      home: const NavigationTabBar(),
    );
  }
}
