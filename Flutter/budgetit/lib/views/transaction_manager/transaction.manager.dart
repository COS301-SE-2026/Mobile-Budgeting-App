import 'package:budgetit/shared/widgets/searchbox.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/shared/widgets/badge.dart';

import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/fab.dart';
import 'package:budgetit/shared/widgets/box.dart';
class TransactionManager extends StatelessWidget{
  const TransactionManager({super.key});

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: MyColours().background,
   
    
    body: 
    GestureDetector(
      onTap: () {
      
        FocusScope.of(context).unfocus();
      },

    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
           Divider(color: Colors.transparent),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
               
                Expanded(
                  child: SearchBox(hintText: 'Search for Transaction', onChanged: (value) {
                  
                }),
                ), 
              ],
            ),
          ),
          Divider(color: Colors.transparent),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
            child: Row(
              children: [
                MyBadge(text: 'All'),
                Divider(color: Colors.transparent, indent: 8),
                MyBadge(text: 'Income'),
                Divider(color: Colors.transparent, indent: 8),
                MyBadge(text: 'Expenses'),
              ],
            )
          ),
          Divider(color: Colors.transparent),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: MyColours().headingFontSize2,
                    color: MyColours().textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monday',
                  style: TextStyle(
                    fontSize: MyColours().headingFontSize2,
                    color: MyColours().textPrimary,
                   // fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '18 May 2026',
                  style: TextStyle(
                    fontSize: MyColours().headingFontSize3,
                    color: MyColours().textPrimary,
                   // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Divider(color: Colors.transparent),
              box(text: 'Grocery Order - R500', icon: Icons.shopping_cart),
              Divider(color: Colors.transparent),
              box(text: 'Electricity - R300', icon: Icons.bolt),
              Divider(color: Colors.transparent),
              box(text: 'Water - R200', icon: Icons.local_drink),
            ],
          ),
        ],
      ),
    ),
    ),
    floatingActionButton: const FAB(),
  );
}
}