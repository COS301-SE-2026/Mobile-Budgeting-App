import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../database/app_database.dart';
import '../../database/schema.dart';
import '../../utils/app_colour.dart';

class BudgetDetailScreen extends StatefulWidget {
  const BudgetDetailScreen({
    super.key,
    required this.database,
    required this.templateId,
    required this.categoryId,
    required this.title,
    required this.subtitle,
    required this.spent,
    required this.limit,
    required this.icon,
    required this.progressColor,
    this.isOverLimit = false,
  });

  final AppDatabase database;
  final String templateId;
  final String categoryId;
  final String title;
  final String subtitle;
  final double spent;
  final double limit;
  final IconData icon;
  final Color progressColor;
  final bool isOverLimit;

  @override
  State<BudgetDetailScreen> createState() => _BudgetDetailScreenState();
}

class _BudgetDetailScreenState extends State<BudgetDetailScreen> {
  final MyColours colours = MyColours();

  late double _spent;
  late double _limit;

  @override
  void initState() {
    super.initState();
    _spent = widget.spent;
    _limit = widget.limit;
  }

  String _formatCurrency(double amount) {
    return 'R${amount.toStringAsFixed(2)}';
  }

  bool get _isOverLimit => _spent > _limit;

  @override
  Widget build(BuildContext context) {
    final double progress = _limit <= 0 ? 0 : _spent / _limit;
    final double remaining = _limit - _spent;
    final bool closeToLimit = progress >= 0.8 && !_isOverLimit;

    return Scaffold(
      backgroundColor: colours.background,
      appBar: AppBar(
        backgroundColor: colours.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colours.textPrimary),
        title: Text(
          widget.title,
          style: TextStyle(
            color: colours.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit budget',
            onPressed: _showEditBudgetDialog,
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
          color: _isOverLimit ? colours.redColor : colours.secondary,
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
                child: Icon(widget.icon, color: colours.background, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: colours.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: colours.textPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isOverLimit)
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
            _formatCurrency(_spent),
            style: TextStyle(
              color: colours.textPrimary,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Budget limit: ${_formatCurrency(_limit)}',
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
                _isOverLimit ? colours.redColor : widget.progressColor,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _isOverLimit
                ? 'You are ${_formatCurrency(remaining.abs())} over this budget.'
                : 'You still have ${_formatCurrency(remaining)} remaining.',
            style: TextStyle(
              color: _isOverLimit ? colours.redColor : colours.textPrimary,
              fontSize: 13,
              fontWeight: _isOverLimit ? FontWeight.bold : FontWeight.normal,
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

    if (_isOverLimit) {
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
                onTap: _showAddTransactionDialog,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _actionButton(
                icon: Icons.edit_outlined,
                label: 'Edit Budget',
                onTap: _showEditBudgetDialog,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _actionButton(
          icon: Icons.analytics_outlined,
          label: 'View Spending Insights',
          onTap: _showSpendingInsights,
        ),
      ],
    );
  }

  Widget _recentTransactions() {
    return FutureBuilder<List<Transaction>>(
      future: widget.database.transactionDao.getTransactionsByCategory(
        widget.categoryId,
      ),
      builder: (context, snapshot) {
        final transactions = (snapshot.data ?? [])
            .where((transaction) => transaction.type == TransactionType.expense)
            .take(3)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Recent Transactions'),
            const SizedBox(height: 12),
            if (snapshot.connectionState == ConnectionState.waiting)
              Center(child: CircularProgressIndicator(color: colours.secondary))
            else if (transactions.isEmpty)
              _borderCard(
                child: Text(
                  'No recent transactions for this budget yet.',
                  style: TextStyle(color: colours.textPrimary, fontSize: 13),
                ),
              )
            else
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
                              transaction.shortDescription,
                              style: TextStyle(
                                color: colours.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              _formatDate(transaction.transactionDate),
                              style: TextStyle(
                                color: colours.textPrimary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatCurrency(transaction.amount.toDouble()),
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
      },
    );
  }

  Widget _budgetTips(bool closeToLimit) {
    String tip = 'Nice work. Keep tracking spending to stay within this budget.';

    if (_isOverLimit) {
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showSpendingInsights() {
    final remaining = _limit - _spent;
    final usedPercentage = _limit <= 0 ? 0 : ((_spent / _limit) * 100);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colours.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colours.secondary, width: 1.5),
          ),
          title: Text(
            'Spending Insights',
            style: TextStyle(
              color: colours.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'You have used ${usedPercentage.toStringAsFixed(1)}% of your ${widget.title} budget.\n\n'
            '${_isOverLimit ? 'You are over budget by ${_formatCurrency(remaining.abs())}.' : 'You still have ${_formatCurrency(remaining)} remaining.'}',
            style: TextStyle(color: colours.textPrimary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: colours.textPrimary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditBudgetDialog() {
    final limitController = TextEditingController(
      text: _limit.toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colours.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colours.secondary, width: 1.5),
          ),
          title: Text(
            'Edit Budget',
            style: TextStyle(
              color: colours.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: limitController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: colours.textPrimary),
            decoration: InputDecoration(
              labelText: 'Budget limit',
              labelStyle: TextStyle(color: colours.textPrimary),
              prefixText: 'R ',
              prefixStyle: TextStyle(color: colours.textPrimary),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colours.secondary),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colours.secondary, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                limitController.dispose();
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: colours.textPrimary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final newLimit = double.tryParse(limitController.text.trim());

                if (newLimit == null || newLimit <= 0) {
                  _showSnackBar(
                    message: 'Please enter a valid budget limit.',
                    isError: true,
                  );
                  return;
                }

                await widget.database.budgetDao.updateBudgetTemplate(
                  widget.templateId,
                  amount: Decimal.parse(newLimit.toString()),
                );

                if (!mounted) return;

                setState(() {
                  _limit = newLimit;
                });

                limitController.dispose();
                Navigator.of(dialogContext).pop();

                _showSnackBar(message: 'Budget updated successfully.');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colours.secondary,
                foregroundColor: colours.background,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTransactionDialog() {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colours.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colours.secondary, width: 1.5),
          ),
          title: Text(
            'Add Transaction',
            style: TextStyle(
              color: colours.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                style: TextStyle(color: colours.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: colours.textPrimary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colours.secondary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colours.secondary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: colours.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: colours.textPrimary),
                  prefixText: 'R ',
                  prefixStyle: TextStyle(color: colours.textPrimary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colours.secondary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colours.secondary, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                amountController.dispose();
                descriptionController.dispose();
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: colours.textPrimary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text.trim());
                final description = descriptionController.text.trim();

                if (description.isEmpty) {
                  _showSnackBar(
                    message: 'Please enter a description.',
                    isError: true,
                  );
                  return;
                }

                if (amount == null || amount <= 0) {
                  _showSnackBar(
                    message: 'Please enter a valid amount.',
                    isError: true,
                  );
                  return;
                }

                final transaction =
                    await widget.database.transactionDao.insertTransaction(
                  amount: Decimal.parse(amount.toString()),
                  type: TransactionType.expense,
                  shortDescription: description,
                  transactionDate: DateTime.now(),
                  source: TransactionSource.manual,
                );

                await widget.database.transactionDao.assignCategory(
                  transactionId: transaction.id,
                  categoryId: widget.categoryId,
                  assignmentSource: AssignmentSource.manual,
                );

                if (!mounted) return;

                setState(() {
                  _spent += amount;
                });

                amountController.dispose();
                descriptionController.dispose();
                Navigator.of(dialogContext).pop();

                _showSnackBar(message: 'Transaction added successfully.');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colours.secondary,
                foregroundColor: colours.background,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar({
    required String message,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? colours.redColor : colours.secondary,
          content: Text(
            message,
            style: TextStyle(
              color: isError ? colours.whiteAccents : colours.background,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
  }
}