import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/balance_card.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Balance', type:BalanceCard, path: '[Widgets]'  )
Widget addButton(BuildContext context) {
  return Scaffold(
    backgroundColor: context.colours.background, 
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sometimes all you need is some balance!",
            style: context.colours.h2,
          ),
          
           const SizedBox(height: 28),
          Text(
            "This card clearly displays the users target and current spend! ",
            style: context.colours.b1,
            textAlign: TextAlign.center,
          ),
           const SizedBox(height: 40),
          BalanceCard(selectedDate: DateTime.now(),),
        ],
      ),
    ),
  );
}