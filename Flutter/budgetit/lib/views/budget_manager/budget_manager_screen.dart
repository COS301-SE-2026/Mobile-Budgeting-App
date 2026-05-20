import 'package:flutter/material.dart';
import '../../utils/app_colour.dart';

class BudgetManagerScreen extends StatefulWidget {
  const BudgetManagerScreen({super.key});

  @override
  State<BudgetManagerScreen> createState() => _BudgetManagerScreenState();
}

class _BudgetCategory {
  final IconData icon;
  final String title;
  final String subtitle;
  final double spent;
  final double limit;
  final Color progressColor;
  final bool isOverLimit;

  const _BudgetCategory({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.spent,
    required this.limit,
    required this.progressColor,
    this.isOverLimit = false,
  });
}

class _BudgetManagerScreenState extends State<BudgetManagerScreen> {
  final MyColours colours = MyColours();

  final List<_BudgetCategory> _budgetCategories = [
    _BudgetCategory(
      icon: Icons.home_outlined,
      title: "Rent",
      subtitle: "Fixed Expense",
      spent: 1200,
      limit: 1200,
      progressColor: Colors.cyan,
    ),
    _BudgetCategory(
      icon: Icons.shopping_bag_outlined,
      title: "Groceries",
      subtitle: "Essential",
      spent: 450,
      limit: 600,
      progressColor: Colors.greenAccent,
    ),
    _BudgetCategory(
      icon: Icons.restaurant,
      title: "Dining",
      subtitle: "Discretionary",
      spent: 200,
      limit: 150,
      progressColor: Colors.red,
      isOverLimit: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colours.background,
     
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryCard(),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Budget Categories",
                      style: TextStyle(
                        color: colours.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "JUNE 2024",
                      style: TextStyle(
                        color: colours.textPrimary,
                        fontSize: 9,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                for (final budget in _budgetCategories) ...[
  _budgetCard(
    icon: budget.icon,
    title: budget.title,
    subtitle: budget.subtitle,
    spent: budget.spent,
    limit: budget.limit,
    progressColor: budget.progressColor,
    isOverLimit: budget.isOverLimit,
  ),
  const SizedBox(height: 14),
],

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                           _showCreateBudgetDialog(context);
                          },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text(
                      "CREATE NEW BUDGET",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colours.secondary,
                      foregroundColor: colours.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Center(
                  child: Text(
                    "Plan your financial future with precision. All data is stored locally for your privacy.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colours.textPrimary,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    
    );
  }

  Widget _summaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: colours.primaryGradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "MONTHLY SPENDING",
            style: TextStyle(
              color: colours.textPrimary,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "R1,850.00",
            style: TextStyle(
              color: colours.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Target: R1,950.00",
            style: TextStyle(
              color: colours.textPrimary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _budgetCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required double spent,
    required double limit,
    required Color progressColor,
    bool isOverLimit = false,
  }) {
    final double progress = spent / limit;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: colours.primaryGradient,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOverLimit ? Colors.red : colours.secondary,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          if (isOverLimit)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  "OVER LIMIT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: colours.secondary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: colours.background,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: colours.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: colours.textPrimary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                "R${spent.toInt()} / R${limit.toInt()}",
                style: TextStyle(
                  color: isOverLimit ? Colors.red : colours.textPrimary,
                  fontSize: 12,
                  fontWeight:
                      isOverLimit ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress > 1 ? 1 : progress,
              minHeight: 6,
              backgroundColor: colours.secondary,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ),
    );
  }

  
  void _showCreateBudgetDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController limitController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: colours.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colours.secondary,
            width: 1.5,
          ),
        ),
        title: Text(
          'Create New Budget',
          style: TextStyle(
            color: colours.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(color: colours.textPrimary),
              decoration: InputDecoration(
                labelText: 'Budget name',
                labelStyle: TextStyle(color: colours.textPrimary),
                hintText: 'e.g. Transport',
                hintStyle: TextStyle(
                  color: colours.textPrimary.withValues(alpha: 0.6),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colours.secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colours.secondary,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: limitController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: colours.textPrimary),
              decoration: InputDecoration(
                labelText: 'Budget limit',
                labelStyle: TextStyle(color: colours.textPrimary),
                hintText: 'e.g. 500',
                hintStyle: TextStyle(
                  color: colours.textPrimary.withValues(alpha: 0.6),
                ),
                prefixText: 'R ',
                prefixStyle: TextStyle(color: colours.textPrimary),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colours.secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colours.secondary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: colours.textPrimary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final String name = nameController.text.trim();
              final double? limit = double.tryParse(
                limitController.text.trim(),
              );

              if (name.isEmpty || limit == null || limit <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid budget name and limit.'),
                  ),
                );
                return;
              }

              setState(() {
                _budgetCategories.add(
                  _BudgetCategory(
                    icon: Icons.account_balance_wallet_outlined,
                    title: name,
                    subtitle: 'Custom Budget',
                    spent: 0,
                    limit: limit,
                    progressColor: Colors.amber,
                  ),
                );
              });

              Navigator.of(dialogContext).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Budget "$name" created.'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colours.secondary,
              foregroundColor: colours.background,
            ),
            child: const Text('Create'),
          ),
        ],
      );
    },
  ).then((_) {
    nameController.dispose();
    limitController.dispose();
  });
}
}