import 'package:flutter/material.dart';

import '../components/transaction_tile.dart';
import '../components/balance_card.dart';
import '../components/bill_item.dart';
import '../components/bottom_nav.dart';
import '../components/goal_card.dart';
import '../components/dashboard_header.dart';
import '../components/search_bar.dart';
import '../components/insight_widget.dart';
import '../components/action_button.dart';
import '../components/MonthlyTrendWidget.dart';
import '../components/quick_stats_widgets.dart';

class DashboardPage extends StatelessWidget {

  const DashboardPage({super.key});

  static const Color background = Color(0xFF04240C);

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: background,

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.only(bottom: 30),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                // header
                const DashboardHeader(),

                const SizedBox(height: 20),

                // balance card
                const BalanceCard(),

                const SizedBox(height: 20),

                // quick stats
                const Padding(

                  padding: EdgeInsets.symmetric(horizontal: 20),

                  child: QuickStatsWidget(),
                ),

                const SizedBox(height: 25),

                // action buttons
                Padding(

                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  child: Row(

                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: const [

                      ActionButton(
                        icon: Icons.send_rounded,
                        label: "Send",
                      ),

                      ActionButton(
                        icon: Icons.account_balance_wallet_rounded,
                        label: "Budget",
                      ),

                      ActionButton(
                        icon: Icons.receipt_long_rounded,
                        label: "Bills",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // monthly trend
                Padding(

                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  child: MonthlyTrendWidget(

                    months: const [

                      MonthData(
                        month: 'March 2026',
                        shortMonth: 'Mar',
                        income: 22000,
                        spent: 14200,
                      ),

                      MonthData(
                        month: 'April 2026',
                        shortMonth: 'Apr',
                        income: 22000,
                        spent: 12800,
                      ),

                      MonthData(
                        month: 'May 2026',
                        shortMonth: 'May',
                        income: 22000,
                        spent: 10000,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // insight section
                Padding(

                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  child: InsightWidget(

                    insights: [

                      BudgetInsight(
                        title: 'You\'re spending less this month',
                        body:
                            'Your expenses dropped compared to April. Great progress on controlling spending.',
                        icon: Icons.trending_down_rounded,
                        accentColor: Color(0xFF137E84),
                        severity: InsightSeverity.tip,
                      ),

                      BudgetInsight(
                        title: 'Entertainment budget exceeded',
                        body:
                            'You\'ve spent more than expected on subscriptions and movies this month.',
                        icon: Icons.movie_rounded,
                        accentColor: Color(0xFFC2B280),
                        severity: InsightSeverity.warning,
                      ),

                      BudgetInsight(
                        title: 'Vacation savings improving',
                        body:
                            'You are halfway toward your vacation savings goal.',
                        icon: Icons.flight_takeoff_rounded,
                        accentColor: Color(0xFF137E84),
                        severity: InsightSeverity.tip,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // upcoming bills
                const Padding(

                  padding: EdgeInsets.symmetric(horizontal: 20),

                  child: Text(
                    "Upcoming Bills",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 134, 143, 136),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const BillItem(
                  icon: Icons.electric_bolt,
                  title: "Electricity",
                  subtitle: "Due tomorrow",
                  amount: "R850",
                ),

                const BillItem(
                  icon: Icons.movie,
                  title: "Netflix",
                  subtitle: "Due tomorrow",
                  amount: "R199",
                ),

                const SizedBox(height: 25),

                // goals
                const Padding(

                  padding: EdgeInsets.symmetric(horizontal: 20),

                  child: Text(
                    "Savings Goals",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF04240C),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const GoalCard(
                  title: "Vacation Fund",
                  saved: "R5 000",
                  target: "R10 000",
                  progress: 0.5,
                ),

                const GoalCard(
                  title: "New Laptop",
                  saved: "R12 000",
                  target: "R20 000",
                  progress: 0.6,
                ),

                const SizedBox(height: 25),

                // recent transactions
                const Padding(

                  padding: EdgeInsets.symmetric(horizontal: 20),

                  child: Text(
                    "Recent Transactions",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF04240C),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const TransactionTile(
                  icon: Icons.shopping_cart,
                  title: "Groceries",
                  subtitle: "Today",
                  amount: "- R850",
                  isExpense: true,
                ),

                const TransactionTile(
                  icon: Icons.payments,
                  title: "Salary",
                  subtitle: "Yesterday",
                  amount: "+ R22 000",
                  isExpense: false,
                ),

                const SizedBox(height: 30),

                // bottom nav
                const BottomNav(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}