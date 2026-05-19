// ignore_for_file: unused_import

import 'package:flutter/material.dart';

import '../components/transaction_tile.dart';
import '../components/balance_card.dart';
import '../components/bill_item.dart';
import '../components/bottom_nav.dart';
import '../components/dashboard_header.dart';
import '../components/insight_widget.dart';
import '../components/quick_stats_widgets.dart';
import '../components/monthly_trend_widget.dart'
    hide InsightWidget,
    BudgetInsight,
    InsightSeverity;
    
class DashboardPage extends StatefulWidget {

  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState
    extends State<DashboardPage> {

  static const Color background =
      Color(0xFF04240C);

  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: background,

      bottomNavigationBar:
          const BottomNav(),

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

                const DashboardHeader(),

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

                              borderRadius:
                                  BorderRadius.circular(
                                    18,
                                  ),

                              border: Border.all(
                                color:
                                    const Color(
                                      0x66DDD6AE,
                                    ),
                              ),

                              gradient:
                                  const LinearGradient(

                                    begin:
                                        Alignment
                                            .topLeft,

                                    end:
                                        Alignment
                                            .bottomRight,

                                    colors: [

                                      Color(
                                        0xFF1B3D16,
                                      ),

                                      Color(
                                        0xFF4E6240,
                                      ),

                                      Color(
                                        0xFF6E7F5B,
                                      ),
                                    ],
                                  ),
                            ),

                        child: Row(

                          children: const [

                            Icon(
                              Icons.search,
                              color:
                                  Color(
                                    0xFFDDD6AE,
                                  ),
                              size: 20,
                            ),

                            SizedBox(width: 10),

                            Text(
                              "Search transactions...",

                              style: TextStyle(
                                color:
                                    Color(
                                      0xCCDDD6AE,
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

                              borderRadius:
                                  BorderRadius.circular(
                                    16,
                                  ),

                              gradient:
                                  const LinearGradient(

                                    begin:
                                        Alignment
                                            .topLeft,

                                    end:
                                        Alignment
                                            .bottomRight,

                                    colors: [

                                      Color(
                                        0xFF137E84,
                                      ),

                                      Color(
                                        0xFF1B5E63,
                                      ),
                                    ],
                                  ),
                            ),

                        child: Row(

                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                          children: const [

                            Icon(
                              Icons
                                  .upload_file_rounded,

                              color:
                                  Color(
                                    0xFFDDD6AE,
                                  ),

                              size: 20,
                            ),

                            SizedBox(width: 10),

                            Text(
                              "Import Bank Statement (CSV/PDF)",

                              style: TextStyle(
                                color:
                                    Color(
                                      0xFFDDD6AE,
                                    ),

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

                      const BudgetInsight(

                        title:
                            'You\'re spending less this month',

                        body:
                            'Your expenses dropped compared to April.',

                        icon:
                            Icons
                                .trending_down_rounded,

                        accentColor:
                            Color(
                              0xFF137E84,
                            ),

                        severity:
                            InsightSeverity
                                .tip,
                      ),

                      const BudgetInsight(

                        title:
                            'Entertainment budget exceeded',

                        body:
                            'You\'ve spent more than expected.',

                        icon:
                            Icons
                                .movie_rounded,

                        accentColor:
                            Color(
                              0xFFC2B280,
                            ),

                        severity:
                            InsightSeverity
                                .warning,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                const Padding(

                  padding:
                      EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                  child: Text(
                    "Upcoming Bills",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,

                      color:
                          Color(
                            0xFFDDD6AE,
                          ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const BillItem(
                  icon:
                      Icons.electric_bolt,

                  title: "Electricity",

                  subtitle:
                      "Due tomorrow",

                  amount: "R850",
                ),

                const BillItem(
                  icon: Icons.movie,
                  title: "Netflix",
                  subtitle:
                      "Due tomorrow",
                  amount: "R199",
                ),

                const SizedBox(height: 25),

                const Padding(

                  padding:
                      EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                  child: Text(
                    "Recent Transactions",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,

                      color:
                          Color(
                            0xFFDDD6AE,
                          ),
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
                  ? const Color(
                    0xFFDDD6AE,
                  )
                  : const Color(
                    0x22137E84,
                  ),

          borderRadius:
              BorderRadius.circular(
                30,
              ),

          border: Border.all(
            color:
                const Color(
                  0x88DDD6AE,
                ),
          ),
        ),

        child: Text(
          label,

          style: TextStyle(

            color:
                isSelected
                    ? const Color(
                      0xFF04240C,
                    )
                    : const Color(
                      0xFFDDD6AE,
                    ),

            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),
    );
  }
}