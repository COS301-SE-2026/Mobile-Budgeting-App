import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/badge.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Badge', type:MyBadge, path: '[Widgets]'  )
Widget addButton(BuildContext context) {
  return Scaffold(
    backgroundColor: context.colours.background, 
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Small Badge - Huge Power',
            style: context.colours.h2,
          ),
          
           const SizedBox(height: 28),
          Text(
            'This small badge acts as a filter allowing us to sort throuh large amounts of data with one click! ',
            style: context.colours.b1,
            textAlign: TextAlign.center,
          ),
           const SizedBox(height: 40),
          MyBadge(text: context.knobs.string(label: 'badge', initialValue: 'Hi!'),),
        ],
      ),
    ),
  );
}