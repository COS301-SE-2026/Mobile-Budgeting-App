import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/fab.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'FAB', type: FAB, path: '[Widgets]' )
Widget addButton(BuildContext context) {
  return Scaffold(
    backgroundColor: context.colours.background, 
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "This is a FAB",
            style: context.colours.h2,
          ),
          const SizedBox(height: 28),
          Text(
            "AKA a FLoating Action Button ",
            style: context.colours.h4,
          ),
           const SizedBox(height: 28),
           
          Text(
            "It hovers over our Transaction Manager Page, providing a way to add transactions that pops out at you (literally!) ",
            style: context.colours.b1,
            textAlign: TextAlign.center,
          ),
           const SizedBox(height: 40),
          FAB(),
        ],
      ),
    ),
  );
}