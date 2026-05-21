import 'package:flutter/material.dart';
import 'package:budgetit/utils/app_colour.dart';

import '../components/balance_card.dart';
import '../components/bill_item.dart';
import '../components/insight_widget.dart';
import '../components/monthly_trend_widget.dart';
import '../components/spending_chart.dart';
import '../components/transaction_tile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String selectedFilter = "All";
  DateTime selectedDate = DateTime.now();
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
              //adding the filter gang
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      "Dashboard",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colours.textPrimary,
                      ),
                    ),

                    GestureDetector(
                      onTap: () async {

                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;//makes it rebuild using the new date hehe
                          });
                        }
                      },

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),

                        decoration: BoxDecoration(
                          color: colours.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Row(
                          children: [

                            const Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                              size: 18,
                            ),

                            const SizedBox(width: 8),

                            Text(
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // balance section

              const SizedBox(height: 20),

              // quick stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SpendingChart(total: 'R4.2K',categories: [SpendingCategory(label: 'Housing',percentage: 55, color: colours.tertiary),
                       SpendingCategory(label: 'Dining', percentage: 25, color: colours.secondary),
                       SpendingCategory(label: 'Others', percentage: 20, color: colours.primary),],),
              ),

              const SizedBox(height: 25),

              // monthly trends
             Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: MonthlyTrendWidget(
                  selectedDate: selectedDate,

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

             

              const SizedBox(height: 25),

              // insights section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: InsightWidget(
                  insights: [
                    BudgetInsight(
                      title: 'You\'re spending less this month',

                      body: 'Your expenses dropped compared to April.',

                      icon: Icons.trending_down_rounded,

                      accentColor: colours.tertiary,

                      severity: InsightSeverity.tip,
                    ),

                    BudgetInsight(
                      title: 'Entertainment budget exceeded',

                      body: 'You\'ve spent more than expected.',

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