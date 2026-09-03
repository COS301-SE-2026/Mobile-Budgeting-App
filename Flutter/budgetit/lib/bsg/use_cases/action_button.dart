import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/action_button.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Action Button', type: ActionButton, path: '[Widgets]' )
Widget addButton(BuildContext context) {
  return Scaffold(
    backgroundColor: context.colours.background, 
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Lights, Cameras, Action!",
            style: context.colours.h2,
          ),
          
           const SizedBox(height: 28),
           
          Text(
            "It hovers over our Transaction Manager Page, providing a way to add transactions that pops out at you (literally!) ",
            style: context.colours.b1,
            textAlign: TextAlign.center,
          ),
           const SizedBox(height: 40),
          ActionButton(label: "Example",icon: Icons.abc),
        ],
      ),
    ),
  );
}