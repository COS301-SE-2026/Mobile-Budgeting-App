import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          // burger menu
          Container(

            padding: EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),

            child: Icon(
              Icons.menu,
              size: 28,
            ),
          ),

          // month selector
          Container(

            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),

            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Row(
              children: [
                //i need to make a drop down for date
                Text(
                  "MAY 2026",

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(width: 10),

                Icon(Icons.keyboard_arrow_down),

              ],
            ),
          ),

          // profile/settings icon
         

        ],
      ),
    );
  }
}