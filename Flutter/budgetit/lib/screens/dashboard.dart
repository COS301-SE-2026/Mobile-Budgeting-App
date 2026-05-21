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
  State<Dashboard> createState() =>
      _DashboardState();
}

class _DashboardState
    extends State<Dashboard> {

  String selectedFilter = "All";

  DateTime selectedDate =
      DateTime.now();

  // monthly graph data

  final List<MonthData> months = [

    MonthData(
      month: "March",
      shortMonth: "Mar",
      income: 20000,
      spent: 14200,
    ),

    MonthData(
      month: "April",
      shortMonth: "Apr",
      income: 20000,
      spent: 12800,
    ),

    MonthData(
      month: "May",
      shortMonth: "May",
      income: 20000,
      spent: 10000,
    ),
  ];

  @override
  Widget build(BuildContext context) {

    final colours = MyColours();

    return Scaffold(

      backgroundColor:
          colours.background,

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

                // dashboard title + date picker

                Padding(

                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                  child: Row(

                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    children: [

                      Text(
                        "Dashboard",

                        style: TextStyle(
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              colours.textPrimary,
                        ),
                      ),

                      GestureDetector(

                        onTap: () async {

                          final pickedDate =
                              await showDatePicker(

                            context: context,

                            initialDate:
                                selectedDate,

                            firstDate:
                                DateTime(2024),

                            lastDate:
                                DateTime(2035),
                          );

                          if (pickedDate !=
                              null) {

                            setState(() {

                              selectedDate =
                                  pickedDate;
                            });
                          }
                        },

                        child: Container(

                          padding:
                              const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),

                          decoration:
                              BoxDecoration(

                                color:
                                    colours.primary,

                                borderRadius:
                                    BorderRadius.circular(
                                      14,
                                    ),
                              ),

                          child: Row(

                            children: [

                              const Icon(
                                Icons.calendar_month,
                                color:
                                    Colors.white,
                                size: 18,
                              ),

                              const SizedBox(
                                width: 8,
                              ),

                              Text(

                                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",

                                style:
                                    const TextStyle(

                                      color:
                                          Colors.white,

                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // cream spending card

                BalanceCard(
                  selectedDate:
                      selectedDate,
                ),

                const SizedBox(height: 25),

                // pie chart

                Padding(

                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                  child: SpendingChart(

                    total: 'R4.2K',

                    categories: [

                      SpendingCategory(
                        label: 'Housing',
                        percentage: 55,
                        color:
                            colours.tertiary,
                      ),

                      SpendingCategory(
                        label: 'Dining',
                        percentage: 25,
                        color:
                            colours.secondary,
                      ),

                      SpendingCategory(
                        label: 'Others',
                        percentage: 20,
                        color:
                            colours.primary,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // monthly trends

                Padding(

                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                  child: MonthlyTrendWidget(

                    selectedDate:
                        selectedDate,

                    months: months,
                  ),
                ),

                const SizedBox(height: 25),

                // insights

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
                            Icons.trending_down_rounded,

                        accentColor:
                            colours.tertiary,

                        severity:
                            InsightSeverity.tip,
                      ),

                      BudgetInsight(

                        title:
                            'Entertainment budget exceeded',

                        body:
                            'You\'ve spent more than expected.',

                        icon:
                            Icons.movie_rounded,

                        accentColor:
                            colours.secondary,

                        severity:
                            InsightSeverity.warning,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // upcoming bills title

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

                // bills

                BillItem(
                  icon:
                      Icons.electric_bolt,

                  title:
                      "Electricity",

                  subtitle:
                      "Due tomorrow",

                  amount:
                      "R850",
                ),

                BillItem(
                  icon:
                      Icons.movie,

                  title:
                      "Netflix",

                  subtitle:
                      "Due tomorrow",

                  amount:
                      "R199",
                ),

                const SizedBox(height: 25),

                // recent transactions title

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

                // transactions

                const TransactionTile(
                  icon:
                      Icons.shopping_cart,

                  title:
                      "Groceries",

                  subtitle:
                      "Today",

                  amount:
                      "- R850",

                  isExpense:
                      true,
                ),

                const TransactionTile(
                  icon:
                      Icons.payments,

                  title:
                      "Salary",

                  subtitle:
                      "Yesterday",

                  amount:
                      "+ R22 000",

                  isExpense:
                      false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
