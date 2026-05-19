import 'package:flutter/material.dart';
import '../utils/app_colour.dart';

class BudgetManagerScreen extends StatelessWidget {
  BudgetManagerScreen({super.key});

  final MyColours colours = MyColours();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colours.background,
      appBar: AppBar(
        backgroundColor: colours.background,
        elevation: 0,
        leading: Icon(Icons.menu, color: colours.textPrimary),
        title: Text(
          "Budget IT",
          style: TextStyle(
            color: colours.textPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Icon(Icons.account_circle_outlined, color: colours.textPrimary),
          const SizedBox(width: 12),
          Icon(Icons.settings_outlined, color: colours.textPrimary),
          const SizedBox(width: 12),
        ],
      ),
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

                _budgetCard(
                  icon: Icons.home_outlined,
                  title: "Rent",
                  subtitle: "Fixed Expense",
                  spent: 1200,
                  limit: 1200,
                  progressColor: Colors.cyan,
                ),

                const SizedBox(height: 14),

                _budgetCard(
                  icon: Icons.shopping_bag_outlined,
                  title: "Groceries",
                  subtitle: "Essential",
                  spent: 450,
                  limit: 600,
                  progressColor: Colors.greenAccent,
                ),

                const SizedBox(height: 14),

                _budgetCard(
                  icon: Icons.restaurant,
                  title: "Dining",
                  subtitle: "Discretionary",
                  spent: 200,
                  limit: 150,
                  progressColor: Colors.red,
                  isOverLimit: true,
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {},
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
      bottomNavigationBar: _bottomNavBar(),
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

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: colours.background,
      selectedItemColor: colours.secondary,
      unselectedItemColor: colours.secondary,
      type: BottomNavigationBarType.fixed,
      currentIndex: 2,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: "Transactions",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: "Budgets",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
      ],
    );
  }
}