import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class HelpMenuPage extends StatelessWidget {
  const HelpMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colours.background,
      appBar: AppBar(
        backgroundColor: context.colours.background,
        elevation: 0,
        iconTheme: IconThemeData(color: context.colours.secondary),
        title: Text(
          'Help Menu',
          style: context.colours.title,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _introCard(context),
              const SizedBox(height: 18),
              _sectionTitle(context, 'QUICK HELP'),
              const SizedBox(height: 12),
              _HelpDropDown(
                icon: Icons.add,
                title: 'HOW TO ADD NEW TRANSACTION',
                steps: const [
                  _HelpStep(
                    icon: Icons.receipt_long_rounded,
                    text: 'Go to the Transaction Manager page using the receipt icon in the bottom navigation.',
                  ),
                  _HelpStep(
                    icon: Icons.add,
                    text: 'Tap the plus button at the bottom of the screen.',
                  ),
                  _HelpStep(
                    icon: Icons.edit_note_outlined,
                    text: 'Choose Add Transaction, then enter the description, amount, type and date.',
                  ),
                  _HelpStep(
                    icon: Icons.check_circle_outline,
                    text: 'Tap Add to save the transaction.',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _HelpDropDown(
                icon: Icons.category_outlined,
                title: 'HOW TO ADD NEW CATEGORY',
                steps: const [
                  _HelpStep(
                    icon: Icons.account_balance_wallet_outlined,
                    text: 'Go to the Budget Manager page using the budgets icon in the bottom navigation.',
                  ),
                  _HelpStep(
                    icon: Icons.add,
                    text: 'Tap Create New Budget.',
                  ),
                  _HelpStep(
                    icon: Icons.arrow_drop_down_circle_outlined,
                    text: 'Open the Budget category dropdown to find the available categories.',
                  ),
                  _HelpStep(
                    icon: Icons.category_outlined,
                    text: 'Select the category you want to use, then enter the budget limit and period.',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _HelpDropDown(
                icon: Icons.bar_chart_outlined,
                title: 'HOW TO VIEW GRAPHICAL REPORTS',
                steps: const [
                  _HelpStep(
                    icon: Icons.account_balance_wallet_outlined,
                    text: 'Go to the Budget Manager page using the budgets icon in the bottom navigation.',
                  ),
                  _HelpStep(
                    icon: Icons.bar_chart_outlined,
                    text: 'Tap View Graphical Reports.',
                  ),
                  _HelpStep(
                    icon: Icons.calendar_month_outlined,
                    text: 'Use the Weekly, Monthly or Yearly chips to change the reporting period.',
                  ),
                  _HelpStep(
                    icon: Icons.show_chart,
                    text: 'Scroll through the report cards to view income, expenses, categories, budgets and spending trends.',
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  'Use the icons on each page to find the feature you need.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colours.textPrimary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
