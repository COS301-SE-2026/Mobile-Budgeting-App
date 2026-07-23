import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final DateTime selectedDate;
  const BalanceCard({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(
        color: colours.bg2,

        

        
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            "DAILY SPENDING FOR ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",

            style: colours.h4,
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
              color: colours.background.withValues(alpha: 0.8),

              fontSize: 20,

              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
