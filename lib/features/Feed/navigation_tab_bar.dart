import 'package:flutter/material.dart';
import 'package:mactest/features/home/home_screen.dart';
import 'package:mactest/features/report/reporte_screen.dart';
import 'package:mactest/features/settings/settings_screen.dart';
import 'package:mactest/features/transactions/transactions_screen.dart';

class NavigationTabBar extends StatefulWidget {
  const NavigationTabBar({super.key});

  @override
  State<NavigationTabBar> createState() => _NavigationTabBarState();
}

class _NavigationTabBarState extends State<NavigationTabBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const FakeTransaction(),
    ReportsScreen(),
    const SettingsScreen(),
  ];

  final List<String> _iconPaths = [
    'assets/four.png',
    'assets/one.png',
    'assets/two.png',
    'assets/three.png',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_iconPaths.length, (index) {
            final isSelected = _selectedIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => _onItemTapped(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      _iconPaths[index],
                      width: 24,
                      height: 32,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 3,
                      width: isSelected ? 24 : 0,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
