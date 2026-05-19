import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),

      padding: EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [

          Container(

            padding: EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(15),
            ),

            child: Icon(
              icon,
              color: const Color(0xFF04240C),
            ),
          ),

          SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Color(0xFFDDD6AE),
                  ),
                ),

              ],
            ),
          ),

          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

        ],
      ),
    );
  }
}