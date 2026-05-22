import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionTile extends StatelessWidget {

  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool isExpense;

  const TransactionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    final colours = MyColours();

    return Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: colours.secondary,

        borderRadius:
            BorderRadius.circular(24),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.18,
            ),

            blurRadius: 12,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(

            padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

            decoration: BoxDecoration(
              color: colours.background
                  .withValues(alpha: 0.15),

              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: Text(
              "TRANSACTION",

              style: TextStyle(
                color: colours.background,
                fontSize: 11,
                fontWeight:
                    FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Row(

            children: [

              Container(

                width: 55,
                height: 55,

                decoration: BoxDecoration(

                  color:
                      isExpense
                          ? Colors.redAccent
                              .withValues(
                                alpha: 0.15,
                              )
                          : colours.tertiary
                              .withValues(
                                alpha: 0.15,
                              ),

                  borderRadius:
                      BorderRadius.circular(18),
                ),

                child: Icon(
                  icon,

                  size: 28,

                  color:
                      isExpense
                          ? Colors.redAccent
                          : colours.tertiary,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,

                      style:
                          TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                colours.background,
                          ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,

                      style: TextStyle(
                        color:
                            colours.background
                                .withValues(
                                  alpha: 0.7,
                                ),

                        fontSize: 13,

                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Column(

                crossAxisAlignment:
                    CrossAxisAlignment.end,

                children: [

                  Text(
                    amount,

                    style: TextStyle(
                      fontSize: 17,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          isExpense
                              ? Colors
                                  .redAccent
                              : colours
                                  .tertiary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    isExpense
                        ? "expense"
                        : "income",

                    style: TextStyle(
                      fontSize: 11,

                      color:
                          isExpense
                              ? Colors
                                  .redAccent
                                  .withValues(
                                    alpha:
                                        0.85,
                                  )
                              : colours
                                  .tertiary
                                  .withValues(
                                    alpha:
                                        0.8,
                                  ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}