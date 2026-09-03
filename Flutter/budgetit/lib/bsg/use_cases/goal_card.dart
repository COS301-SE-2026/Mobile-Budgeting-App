import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/goal_card.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Goals', type:GoalCard, path: '[Widgets]'  )
Widget addButton(BuildContext context) {
  return Scaffold(
    backgroundColor: context.colours.background, 
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'GOALLLLLLLLLL',
            style: context.colours.h2,
          ),
          
           const SizedBox(height: 28),
          Text(
            'This card is a neat way to track your goals with regards to your budget! ',
            style: context.colours.b1,
            textAlign: TextAlign.center,
          ),
           const SizedBox(height: 40),
          GoalCard(title: context.knobs.string(label: 'Title', initialValue: 'Title'), saved: context.knobs.string(label: 'Saved', initialValue: 'Example'), progress: context.knobs.double.slider(label: 'Progress'), target: context.knobs.string(label: 'Target', initialValue: 'R0.00'),),
        ],
      ),
    ),
  );
}