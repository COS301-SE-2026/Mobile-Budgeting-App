import 'package:flutter/material.dart';
import 'package:budgetit/utils/app_colour.dart';

class BillItem extends StatelessWidget {

  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;

  const BillItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
  });

 final colours = MyColours();
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
            BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.20,
            ),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(

        children: [

          Container(

            width: 62,
            height: 62,

            decoration: BoxDecoration(

              color: const Color(
                0x22137E84,
              ),

              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: Icon(
              icon,

              size: 30,

              color: teal,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                    color: darkGreen,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,

                  style: TextStyle(
                    color:
                        darkGreen.withValues(
                          alpha: 0.75,
                        ),

                    fontSize: 15,

                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Text(
            amount,

            style: const TextStyle(
              color: darkGreen,
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}