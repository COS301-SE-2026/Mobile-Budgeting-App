import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import '../shared/widgets/main_appbar.dart';
import '../components/transaction_tile.dart';
import '../components/balance_card.dart';
import '../components/bill_item.dart';
import '../components/insight_widget.dart';
import '../components/quick_stats_widgets.dart';
import '../components/monthly_trend_widget.dart';

class Dashboard extends StatefulWidget {

  const Dashboard({super.key});

  @override
  State<Dashboard> createState() =>
      _DashboardState();
}

class _DashboardState
    extends State<Dashboard> {

  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {

    final colours = MyColours();

    return Scaffold(

      backgroundColor:
          colours.background,

      appBar: const MainAppbar(),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding:
                const EdgeInsets.only(
                  bottom: 40,
                ),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 20),

                const BalanceCard(),

                const SizedBox(height: 20),

                const Padding(

                  padding:
                      EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                  child:
                      QuickStatsWidget(),
                ),

                const SizedBox(height: 25),

                Padding(

                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                  child: Column(

                    children: [

                      Container(

                        padding:
                            const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),

                        decoration:
                            BoxDecoration(

                              color:
                                  colours.secondary,

                              borderRadius:
                                  BorderRadius.circular(
                                    18,
                                  ),

                              border: Border.all(
                                color:
                                    colours
                                        .background
                                        .withValues(
                                          alpha:
                                              0.15,
                                        ),
                              ),

                              boxShadow: [

                                BoxShadow(
                                  color:
                                      Colors.black
                                          .withValues(
                                            alpha:
                                                0.15,
                                          ),

                                  blurRadius:
                                      10,

                                  offset:
                                      const Offset(
                                        0,
                                        4,
                                      ),
                                ),
                              ],
                            ),

                        child: Row(

                          children: [

                            Icon(
                              Icons.search,

                              color:
                                  colours
                                      .background,

                              size: 20,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Text(
                              "Search transactions...",

                              style: TextStyle(
                                color:
                                    colours
                                        .background
                                        .withValues(
                                          alpha:
                                              0.7,
                                        ),

                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      Container(

                        width:
                            double.infinity,

                        padding:
                            const EdgeInsets.symmetric(
                              vertical: 16,
                            ),

                        decoration:
                            BoxDecoration(

                              color:
                                  colours.secondary,

                              borderRadius:
                                  BorderRadius.circular(
                                    16,
                                  ),

                              border: Border.all(
                                color:
                                    colours
                                        .background
                                        .withValues(
                                          alpha:
                                              0.15,
                                        ),
                              ),

                              boxShadow: [

                                BoxShadow(
                                  color:
                                      Colors.black
                                          .withValues(
                                            alpha:
                                                0.15,
                                          ),

                                  blurRadius:
                                      10,

                                  offset:
                                      const Offset(
                                        0,
                                        4,
                                      ),
                                ),
                              ],
                            ),

                        child: Row(

                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                          children: [

                            Icon(
                              Icons
                                  .upload_file_rounded,

                              color:
                                  colours
                                      .background,

                              size: 20,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Text(
                              "Import Bank Statement (CSV/PDF)",

                              style: TextStyle(
                                color:
                                    colours
                                        .background,

                                fontSize: 15,

                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      SingleChildScrollView(

                        scrollDirection:
                            Axis.horizontal,

                        child: Row(

                          children: [

                            _FilterPill(
                              label: "All",

                              isSelected:
                                  selectedFilter ==
                                      "All",

                              onTap: () {

                                setState(() {

                                  selectedFilter =
                                      "All";
                                });
                              },
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            _FilterPill(
                              label: "Income",

                              isSelected:
                                  selectedFilter ==
                                      "Income",

                              onTap: () {

                                setState(() {

                                  selectedFilter =
                                      "Income";
                                });
                              },
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            _FilterPill(
                              label:
                                  "Expenses",

                              isSelected:
                                  selectedFilter ==
                                      "Expenses",

                              onTap: () {

                                setState(() {

                                  selectedFilter =
                                      "Expenses";
                                });
                              },
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            _FilterPill(
                              label:
                                  "Scheduled",

                              isSelected:
                                  selectedFilter ==
                                      "Scheduled",

                              onTap: () {

                                setState(() {

                                  selectedFilter =
                                      "Scheduled";
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Padding(

                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                  child:
                      MonthlyTrendWidget(

                        months: const [

                          MonthData(
                            month:
                                'March 2026',

                            shortMonth:
                                'Mar',

                            income: 22000,

                            spent: 14200,
                          ),

                          MonthData(
                            month:
                                'April 2026',

                            shortMonth:
                                'Apr',

                            income: 22000,

                            spent: 12800,
                          ),

                          MonthData(
                            month:
                                'May 2026',

                            shortMonth:
                                'May',

                            income: 22000,

                            spent: 10000,
                          ),
                        ],
                      ),
                ),

                const SizedBox(height: 25),

                Padding(

                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                  child: InsightWidget(

                    insights: [

                      BudgetInsight(

                        title:
                            'You\'re spending less this month',

                        body:
                            'Your expenses dropped compared to April.',

                        icon:
                            Icons
                                .trending_down_rounded,

                        accentColor:
                            colours.tertiary,

                        severity:
                            InsightSeverity
                                .tip,
                      ),

                      BudgetInsight(

                        title:
                            'Entertainment budget exceeded',

                        body:
                            'You\'ve spent more than expected.',

                        icon:
                            Icons
                                .movie_rounded,

                        accentColor:
                            colours.secondary,

                        severity:
                            InsightSeverity
                                .warning,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Padding(

                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                  child: Text(
                    "Upcoming Bills",

                    style: TextStyle(
                      fontSize: 18,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          colours.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                BillItem(
                  icon:
                      Icons.electric_bolt,

                  title: "Electricity",

                  subtitle:
                      "Due tomorrow",

                  amount: "R850",
                ),

                BillItem(
                  icon: Icons.movie,
                  title: "Netflix",
                  subtitle:
                      "Due tomorrow",
                  amount: "R199",
                ),

                const SizedBox(height: 25),

                Padding(

                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                  child: Text(
                    "Recent Transactions",

                    style: TextStyle(
                      fontSize: 18,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          colours.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const TransactionTile(
                  icon:
                      Icons.shopping_cart,

                  title: "Groceries",

                  subtitle: "Today",

                  amount: "- R850",

                  isExpense: true,
                ),

                const TransactionTile(
                  icon: Icons.payments,
                  title: "Salary",
                  subtitle:
                      "Yesterday",
                  amount:
                      "+ R22 000",
                  isExpense: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterPill
    extends StatelessWidget {

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final colours = MyColours();

    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding:
            const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 12,
            ),

        decoration: BoxDecoration(

          color:
              isSelected
                  ? colours.secondary
                  : colours.tertiary
                      .withValues(
                        alpha: 0.15,
                      ),

          borderRadius:
              BorderRadius.circular(
                30,
              ),

          border: Border.all(
            color:
                colours.secondary
                    .withValues(
                      alpha: 0.5,
                    ),
          ),
        ),

        child: Text(
          label,

          style: TextStyle(

            color:
                isSelected
                    ? colours.background
                    : colours.textPrimary,

            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),
    );
  }
}