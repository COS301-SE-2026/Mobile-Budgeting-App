import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {

  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {

    final colours = MyColours();

    return Container(

      width: double.infinity,

      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),

      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(

        color: colours.secondary,

        borderRadius:
            BorderRadius.circular(30),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.30,
            ),

            blurRadius: 20,

            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            "MONTHLY SPENDING MAY 2026",

            style: TextStyle(
              color: colours.background,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "R1,850.00",

            style: TextStyle(
              color: colours.background,
              fontSize: 52,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),

          const SizedBox(height: 25),

          Text(
            "Target: R1,950.00",

            style: TextStyle(
              color: colours.background.withValues(
                alpha: 0.8,
              ),

              fontSize: 20,

              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}