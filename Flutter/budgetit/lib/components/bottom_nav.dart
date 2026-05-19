import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(
        vertical: 15,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF04240C),
        borderRadius: BorderRadius.circular(25),
      ),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [

          Icon(
            Icons.home,
            size: 30,
            color: Color(0xFFDDD6AE),
          ),

          Icon(
            Icons.bar_chart,
            size: 30,
            color: Color(0xFFDDD6AE),
          ),

          Icon(
            Icons.account_balance_wallet,
            size: 30,
            color: Color(0xFFDDD6AE),
          ),

          Icon(
            Icons.person,
            size: 30,
            color: Color(0xFFDDD6AE),
          ),

        ],
      ),
    );
  }
}