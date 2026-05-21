import 'package:flutter/material.dart';
import 'package:budgetit/utils/app_colour.dart';

import '../components/balance_card.dart';
import '../components/bill_item.dart';
import '../components/insight_widget.dart';
import '../components/monthly_trend_widget.dart';
import '../components/quick_stats_widgets.dart';
import '../components/transaction_tile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();

    return Scaffold(
      backgroundColor: colours.background,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 20),

              // balance section
              const BalanceCard(),

              const SizedBox(height: 20),

              // quick stats
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: QuickStatsWidget(),
              ),

              const SizedBox(height: 25),

              // monthly trends
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

              // insights section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: InsightWidget(
                  insights: [
                    BudgetInsight(
                      title: 'You\'re spending less this month',

                      body:
                          'Your expenses dropped compared to April.',

                      icon: Icons.trending_down_rounded,

                      accentColor: colours.tertiary,

                      severity: InsightSeverity.tip,
                    ),

                    BudgetInsight(
                      title: 'Entertainment budget exceeded',

                      body:
                          'You\'ve spent more than expected.',

                      icon: Icons.movie_rounded,

                      accentColor: colours.secondary,

                      severity: InsightSeverity.warning,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // upcoming bills title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Text(
                  "Upcoming Bills",

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colours.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // bills
              BillItem(
                icon: Icons.electric_bolt,
                title: "Electricity",
                subtitle: "Due tomorrow",
                amount: "R850",
              ),

              BillItem(
                icon: Icons.movie,
                title: "Netflix",
                subtitle: "Due tomorrow",
                amount: "R199",
              ),

              const SizedBox(height: 25),

              // recent transactions title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Text(
                  "Recent Transactions",

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colours.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // transactions
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
            ],
          ),
        ),
      ),
    );
  }
}