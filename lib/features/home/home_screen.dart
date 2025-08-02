import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 24, left: 16),
        child: SizedBox(
          width: 112,
          height: 56,
          child: FloatingActionButton.extended(
            onPressed: () {
              // Add action here
            },
            icon: const Icon(Icons.add, size: 24),
            label: const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Add',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            backgroundColor: Colors.blue, // Change as needed
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Overview Header
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Overview',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Overview Section
            Container(
              height: 268,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard('\$12,500', 'Income', context),
                      _buildStatCard('\$8,750', 'Expenses', context),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 358,
                    height: 110,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Savings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '\$8,750',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Latest Header
            Container(
              height: 60,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 12),
                child: Text(
                  'Latest Activity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Latest Flow Items
            _buildTransactionRow(
              'Freelance',
              'UI Design',
              '\$240.00',
              Icons.design_services,
              context,
            ),
            _buildTransactionRow(
              'Groceries',
              'Supermarket',
              '\$85.50',
              Icons.shopping_cart,
              context,
            ),
            _buildTransactionRow(
              'Subscription',
              'Netflix',
              '\$15.99',
              Icons.subscriptions,
              context,
            ),
            _buildTransactionRow(
              'Utilities',
              'Electricity Bill',
              '\$120.00',
              Icons.bolt,
              context,
            ),
          ],
        ),
      ),
    );
  }

  // Stat Card
  Widget _buildStatCard(String title, String value, BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 171,
      height: 110,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 14, color: theme.hintColor)),
        ],
      ),
    );
  }

  // Transaction Row
  Widget _buildTransactionRow(
    String title,
    String subtitle,
    String price,
    IconData icon,
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 72,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon + Text
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: theme.iconTheme.color),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: theme.hintColor),
                  ),
                ],
              ),
            ],
          ),
          Text(
            price,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
