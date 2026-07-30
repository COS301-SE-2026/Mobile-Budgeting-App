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
                    icon: Icons.attach_money,
                    text: 'Go to the Transaction Manager page using the money icon in the bottom navigation.',
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
                icon: Icons.add_circle_outline,
                title: 'HOW TO ADD TRANSACTION TO A BUDGET',
                steps: const [
                  _HelpStep(
                    icon: Icons.pie_chart_outline,
                    text: 'Go to the Budget Manager page using the pie chart icon in the bottom navigation.',
                  ),
                  _HelpStep(
                    icon: Icons.category_outlined,
                    text: 'Tap the budget category you want to add spending to.',
                  ),
                  _HelpStep(
                    icon: Icons.add,
                    text: 'Under Quick Actions, tap Add Transaction.',
                  ),
                  _HelpStep(
                    icon: Icons.check_circle_outline,
                    text: 'Enter the transaction details and save it to update that budget.',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _HelpDropDown(
                icon: Icons.bar_chart_outlined,
                title: 'HOW TO VIEW GRAPHICAL REPORTS',
                steps: const [
                  _HelpStep(
                    icon: Icons.pie_chart_outline,
                    text: 'Go to the Budget Manager page using the pie chart icon in the bottom navigation.',
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

  Widget _introCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: context.colours.blendedprimary,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HELP MENU',
            style: context.colours.b1.copyWith(color: context.colours.cardText),
          ),
          const SizedBox(height: 18),
          Text(
            'Need a hand?',
            style: context.colours.h2.copyWith(color: context.colours.cardText),
          ),
          const SizedBox(height: 12),
          Text(
            'Open a dropdown below to see where to find each feature and which icon to look for.',
            style: context.colours.b1.copyWith(color: context.colours.cardText),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(title, style: context.colours.h2);
  }
}

class _HelpDropDown extends StatelessWidget {
  const _HelpDropDown({
    required this.icon,
    required this.title,
    required this.steps,
  });

  final IconData icon;
  final String title;
  final List<_HelpStep> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colours.primary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.colours.secondary,
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: context.colours.cardText.withValues(alpha: 0.12),
          highlightColor: context.colours.cardText.withValues(alpha: 0.08),
        ),
        child: ExpansionTile(
          iconColor: context.colours.cardText,
          collapsedIconColor: context.colours.cardText,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: Icon(
            icon,
            color: context.colours.cardText,
          ),
          title: Text(
            title,
            style: context.colours.b1.copyWith(color: context.colours.cardText),
          ),
          children: [
            for (final step in steps) _HelpStepRow(step: step),
          ],
        ),
      ),
    );
  }
}

class _HelpStepRow extends StatelessWidget {
  const _HelpStepRow({required this.step});

  final _HelpStep step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            step.icon,
            size: 18,
            color: context.colours.cardText,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              step.text,
              style: context.colours.b2.copyWith(
                color: context.colours.cardText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpStep {
  const _HelpStep({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;
}
