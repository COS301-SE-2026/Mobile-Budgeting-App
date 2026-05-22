import 'package:budgetit/shared/widgets/searchbox.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/shared/widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/fab.dart';
import 'package:budgetit/shared/widgets/box.dart';

class TransactionManager extends StatelessWidget {
  const TransactionManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColours().background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Divider(color: Colors.transparent),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBox(
                        hintText: 'Search for Transaction',
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.transparent),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: Row(
                  children: [
                    MyBadge(text: 'All'),
                    const Divider(color: Colors.transparent, indent: 8),
                    MyBadge(text: 'Income'),
                    const Divider(color: Colors.transparent, indent: 8),
                    MyBadge(text: 'Expenses'),
                  ],
                ),
              ),
              const Divider(color: Colors.transparent),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: MyColours().headingFontSize2,
                        color: MyColours().textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monday',
                      style: TextStyle(
                        fontSize: MyColours().headingFontSize3,
                        color: MyColours().textPrimary,
                      ),
                    ),
                    Text(
                      '18 May 2026',
                      style: TextStyle(
                        fontSize: MyColours().bodyFontSize,
                        color: MyColours().textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Divider(color: Colors.transparent),
                  MyBox(
                     text: 'Water',
  amount: 200,
  icon: Icons.water,
  category: 'Utilities',
  categories: const ['Utilities', 'Food & Dining', 'Transport',],
  onEdited: (name, amount, icon, category) {},
  onDelete: () {},
                  ),
                  const Divider(color: Colors.transparent),
                  MyBox(
                    text: 'Electricity',
  amount: 300,
  icon: Icons.lightbulb,
  category: 'Utilities',
  categories: const ['Utilities', 'Housing'],
  onEdited: (name, amount, icon, category) {},
  onDelete: () {},
                  ),
                  const Divider(color: Colors.transparent),
                  MyBox(
                    text: 'Groceries',
  amount: 1000,
  icon: Icons.shopping_bag_rounded,
  category: 'Lifestyle',
  categories: const ['Utilities', 'Food & Dining', ],
  onEdited: (name, amount, icon, category) {},
  onDelete: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const FAB(),
    );
  }
}
