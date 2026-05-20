import 'package:flutter/material.dart';

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

  static const Color darkGreen =
      Color(0xFF04240C);

  static const Color cream =
      Color(0xFFDDD6AE);

  static const Color teal =
      Color(0xFF137E84);

  static const Color gold =
      Color(0xFFC2B280);

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: cream,

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
              color: const Color(0x2204240C),

              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: const Text(
              "TRANSACTION",

              style: TextStyle(
                color: darkGreen,
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
                          ? const Color(
                            0x22FF5252,
                          )
                          : const Color(
                            0x22137E84,
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
                          : teal,
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
                          const TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                darkGreen,
                          ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Transaction details",

                      style: TextStyle(
                        color:
                            Color(0xAA04240C),

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
                              : teal,
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
                              : teal
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