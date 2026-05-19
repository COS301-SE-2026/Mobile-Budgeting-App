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

  static const Color darkGreen = Color(0xFF04240C);
  static const Color cream = Color(0xFFDDD6AE);
  static const Color teal = Color(0xFF137E84);
  static const Color gold = Color(0xFFC2B280);

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(

        color: darkGreen,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: const Color(0x22DDD6AE),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(

        children: [

          Container(

            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(

              color: isExpense
                  ? const Color(0x22C2B280)
                  : const Color(0x22137E84),

              borderRadius: BorderRadius.circular(15),
            ),

            child: Icon(
              icon,

              color: isExpense
                  ? gold
                  : teal,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cream,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Transaction details",

                  style: TextStyle(
                    color: Color(0x99DDD6AE),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Text(
            amount,

            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,

              color: isExpense
                  ? gold
                  : teal,
            ),
          ),
        ],
      ),
    );
  }
}