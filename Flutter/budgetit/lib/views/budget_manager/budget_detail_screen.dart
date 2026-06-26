import 'package:flutter/material.dart';

import '../../utils/app_colour.dart';

class BudgetDetailScreen extends StatelessWidget {
  BudgetDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.spent,
    required this.limit,
    required this.icon,
    required this.progressColor,
    this.isOverLimit = false,
  });

  final String title;
  final String subtitle;
  final double spent;
  final double limit;
  final IconData icon;
  final Color progressColor;
  final bool isOverLimit;

  final MyColours colours = MyColours();

  String _formatCurrency(double amount) {
    return 'R${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final double progress = limit <= 0 ? 0 : spent / limit;
    final double remaining = limit - spent;
    final bool closeToLimit = progress >= 0.8 && !isOverLimit;

    return Scaffold(
      backgroundColor: colours.background,
      appBar: AppBar(
        backgroundColor: colours.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colours.textPrimary),
        title: Text(
          title,
          style: TextStyle(
            color: colours.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit budget',
            onPressed: () {},
            icon: Icon(Icons.edit_outlined, color: colours.textPrimary),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _overviewCard(progress, remaining),
              const SizedBox(height: 18),
              _statusCard(closeToLimit),
              const SizedBox(height: 18),
              _quickActions(),
              const SizedBox(height: 18),
              _recentTransactions(),
              const SizedBox(height: 18),
              _budgetTips(closeToLimit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _overviewCard(double progress, double remaining) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colours.primary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isOverLimit ? colours.redColor : colours.secondary,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colours.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: colours.background, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: colours.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: colours.textPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isOverLimit)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colours.redColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'OVER',
                    style: TextStyle(
                      color: colours.whiteAccents,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'SPENT',
            style: TextStyle(
              color: colours.textPrimary,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatCurrency(spent),
            style: TextStyle(
              color: colours.textPrimary,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Budget limit: ${_formatCurrency(limit)}',
            style: TextStyle(color: colours.textPrimary, fontSize: 13),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress > 1 ? 1 : progress,
              minHeight: 8,
              backgroundColor: colours.secondary,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverLimit ? colours.redColor : progressColor,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            isOverLimit
                ? 'You are ${_formatCurrency(remaining.abs())} over this budget.'
                : 'You still have ${_formatCurrency(remaining)} remaining.',
            style: TextStyle(
              color: isOverLimit ? colours.redColor : colours.textPrimary,
              fontSize: 13,
              fontWeight: isOverLimit ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCard(bool closeToLimit) {
    IconData statusIcon = Icons.check_circle_outline;
    Color statusColor = Colors.greenAccent;
    String message = 'This budget is currently healthy.';

    if (isOverLimit) {
      statusIcon = Icons.warning_amber_outlined;
      statusColor = colours.redColor;
      message = 'You have exceeded this budget. Review your recent spending.';
    } else if (closeToLimit) {
      statusIcon = Icons.info_outline;
      statusColor = Colors.orangeAccent;
      message = 'You are close to your limit. Spend carefully.';
    }

    return _borderCard(
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colours.textPrimary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Quick Actions'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _actionButton(
                icon: Icons.add,
                label: 'Add Transaction',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _actionButton(
                icon: Icons.edit_outlined,
                label: 'Edit Budget',
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _actionButton(
          icon: Icons.analytics_outlined,
          label: 'View Spending Insights',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _recentTransactions() {
    final transactions = [
      ('Recent transaction', 'Today', 0.00),
      ('Linked transaction', 'Yesterday', 0.00),
      ('Category spend', '3 days ago', 0.00),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Recent Transactions'),
        const SizedBox(height: 12),
        ...transactions.map(
          (transaction) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colours.primary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colours.secondary),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  color: colours.textPrimary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.$1,
                        style: TextStyle(
                          color: colours.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        transaction.$2,
                        style: TextStyle(
                          color: colours.textPrimary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatCurrency(transaction.$3),
                  style: TextStyle(
                    color: colours.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _budgetTips(bool closeToLimit) {
    String tip = 'Nice work. Keep tracking spending to stay within this budget.';

    if (isOverLimit) {
      tip =
          'This budget is over limit. Consider reviewing non-essential spending or adjusting the budget amount.';
    } else if (closeToLimit) {
      tip =
          'You are close to the limit. Check recent transactions before spending more in this category.';
    }

    return _borderCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: colours.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: colours.textPrimary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colours.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: colours.background, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colours.background,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _borderCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colours.primary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colours.secondary),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: colours.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}