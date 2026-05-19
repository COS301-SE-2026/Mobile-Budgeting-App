import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFF04240C), // dark green
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Color(0x6604240C),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "BALANCE : R 11,345.49",
            style: TextStyle(
              color: Color(0xFFDDD6AE), // cream
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                "SALARY: R22,000",
                style: TextStyle(
                  color: Color(0xFFDDD6AE),
                  fontSize: 14,
                ),
              ),

              Text(
                "MONEY SPENT: R10 000",
                style: TextStyle(
                  color: Color(0xFFDDD6AE),
                  fontSize: 14,
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}