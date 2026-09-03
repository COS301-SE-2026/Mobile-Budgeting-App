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
              const SizedBox(height: 24),
              _sectionTitle(context, 'IMPORTING STATEMENTS'),
              const SizedBox(height: 12),
              _HelpDropDown(
                icon: Icons.upload_file,
                title: 'HOW TO IMPORT A BANK STATEMENT',
                steps: const [
                  _HelpStep(
                    icon: Icons.download_outlined,
                    text: 'Download a statement from your banking app or online banking. CSV works best, PDF also works.',
                  ),
                  _HelpStep(
                    icon: Icons.attach_money,
                    text: 'Go to the Transaction Manager page and tap the plus button.',
                  ),
                  _HelpStep(
                    icon: Icons.folder_open,
                    text: 'Choose Import Statement, then pick the file from your device.',
                  ),
                  _HelpStep(
                    icon: Icons.preview_outlined,
                    text: 'Review the preview screen. Nothing is saved until you confirm.',
                  ),
                  _HelpStep(
                    icon: Icons.check_circle_outline,
                    text: 'Tap Confirm to add the transactions to your account.',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _HelpDropDown(
                icon: Icons.help_outline,
                title: 'WHAT THE CONFIRMATION QUESTION MEANS',
                steps: const [
                  _HelpStep(
                    icon: Icons.account_balance_outlined,
                    text: 'Every bank marks money in and money out differently. Some use a Cr label, some a minus sign, some separate columns.',
                  ),
                  _HelpStep(
                    icon: Icons.rule,
                    text: 'BudgetIT works out which rule your bank uses so it can label every transaction correctly.',
                  ),
                  _HelpStep(
                    icon: Icons.quiz_outlined,
                    text: 'If the statement is unclear, you are asked to pick the rule once. It then applies to the whole file.',
                  ),
                  _HelpStep(
                    icon: Icons.visibility_outlined,
                    text: 'The preview under each option shows how your transactions would be labelled, so you can see which looks right.',
                  ),
                  _HelpStep(
                    icon: Icons.bookmark_added_outlined,
                    text: 'Your answer is remembered, so future statements from the same bank import without asking again.',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _HelpDropDown(
                icon: Icons.swap_vert,
                title: 'IF A TRANSACTION IS THE WRONG WAY ROUND',
                steps: const [
                  _HelpStep(
                    icon: Icons.cancel_outlined,
                    text: 'On the preview screen, tap Cancel Import and try again with a different option in the confirmation question.',
                  ),
                  _HelpStep(
                    icon: Icons.edit_outlined,
                    text: 'If you have already imported, open the Transaction Manager, tap the transaction, and change its type.',
                  ),
                  _HelpStep(
                    icon: Icons.tune,
                    text: 'Changing a transaction by hand does not affect the rest of the import.',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _HelpDropDown(
                icon: Icons.filter_alt_outlined,
                title: 'WHY SOME ROWS WERE NOT IMPORTED',
                steps: const [
                  _HelpStep(
                    icon: Icons.content_copy_outlined,
                    text: 'Transactions you have already imported are flagged as duplicates and skipped, so nothing is counted twice.',
                  ),
                  _HelpStep(
                    icon: Icons.summarize_outlined,
                    text: 'Summary lines such as totals, opening balance and closing balance are ignored because they are not transactions.',
                  ),
                  _HelpStep(
                    icon: Icons.report_gmailerrorred_outlined,
                    text: 'Rows with no readable date or amount are skipped. The rest of the file still imports normally.',
                  ),
                  _HelpStep(
                    icon: Icons.checklist,
                    text: 'The preview screen shows exactly what will be added before you confirm.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _sectionTitle(context, 'YOUR DATA'),
              const SizedBox(height: 12),
              _HelpDropDown(
                icon: Icons.lock_outline,
                title: 'WHERE YOUR DATA IS STORED',
                steps: const [
                  _HelpStep(
                    icon: Icons.phone_android,
                    text: 'All your transactions, budgets and categories are stored on this device.',
                  ),
                  _HelpStep(
                    icon: Icons.wifi_off,
                    text: 'Statements are read on your device. Your financial data is not uploaded anywhere.',
                  ),
                  _HelpStep(
                    icon: Icons.airplanemode_active,
                    text: 'Everything works without an internet connection, including importing and reports.',
                  ),
                  _HelpStep(
                    icon: Icons.logout,
                    text: 'Signing out clears your session but keeps your financial data on the device.',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _HelpDropDown(
                icon: Icons.repeat,
                title: 'HOW RECURRING TRANSACTIONS WORK',
                steps: const [
                  _HelpStep(
                    icon: Icons.event_repeat,
                    text: 'Set an amount, a start date and how often it repeats. BudgetIT creates each occurrence for you.',
                  ),
                  _HelpStep(
                    icon: Icons.update,
                    text: 'If the app was closed when one was due, it is created the next time you open the app.',
                  ),
                  _HelpStep(
                    icon: Icons.calendar_today,
                    text: 'A monthly item set for the 31st falls on the last day of shorter months, then returns to the 31st.',
                  ),
                  _HelpStep(
                    icon: Icons.pause_circle_outline,
                    text: 'Deleting a recurring template stops future occurrences. Ones already created stay in your history.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _sectionTitle(context, 'TERMS EXPLAINED'),
              const SizedBox(height: 12),
              _HelpDropDown(
                icon: Icons.menu_book_outlined,
                title: 'WHAT THE TERMS MEAN',
                steps: const [
                  _HelpStep(
                    icon: Icons.pie_chart_outline,
                    text: 'Budget: a spending limit for one category over a period, such as R2000 on groceries each month.',
                  ),
                  _HelpStep(
                    icon: Icons.category_outlined,
                    text: 'Category: a label grouping similar transactions, such as Groceries, Rent or Salary.',
                  ),
                  _HelpStep(
                    icon: Icons.trending_up,
                    text: 'Income and expense: money coming in and money going out. Every transaction is one or the other.',
                  ),
                  _HelpStep(
                    icon: Icons.favorite_outline,
                    text: 'Financial health score: a 0 to 100 summary of this month based on your income, spending and budgets.',
                  ),
                  _HelpStep(
                    icon: Icons.warning_amber_outlined,
                    text: 'Anomaly: spending that is unusual compared to your normal pattern. It is a prompt to look, not a warning of a problem.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _supportCard(context),
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

  Widget _supportCard(BuildContext context) {
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
            'STILL STUCK?',
            style: context.colours.b1.copyWith(color: context.colours.cardText),
          ),
          const SizedBox(height: 12),
          Text(
            'If something is not working the way you expect, let us know what you were doing and which screen you were on.',
            style: context.colours.b2.copyWith(color: context.colours.cardText),
          ),
          const SizedBox(height: 12),
          Text(
            'Budget IT by Dev Oops',
            style: context.colours.b2.copyWith(color: context.colours.cardText),
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