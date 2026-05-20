import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {

  const BalanceCard({super.key});

  static const Color darkGreen =
      Color(0xFF04240C);

  static const Color cream =
      Color(0xFFDDD6AE);

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),

      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(

        borderRadius:
            BorderRadius.circular(30),

        gradient: const LinearGradient(

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [

            Color(0xFF1B3D16),
            Color(0xFF4E6240),
            Color(0xFF6E7F5B),
          ],
        ),

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

          const Text(
            "MONTHLY SPENDING MAY 2026",

            style: TextStyle(
              color: cream,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "R1,850.00",

            style: TextStyle(
              color: cream,
              fontSize: 52,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),

          const SizedBox(height: 25),

          Text(
            "Target: R1,950.00",

            style: TextStyle(
              color: cream.withValues(
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