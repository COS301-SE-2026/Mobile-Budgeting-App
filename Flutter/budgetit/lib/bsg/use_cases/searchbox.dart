import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/searchbox.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Searchbox', type:SearchBox, path: '[Widgets]'  )
Widget addButton(BuildContext context) {
  return Scaffold(
    backgroundColor: context.colours.background, 
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "One day... one day",
            style: context.colours.h2,
          ),
          
           const SizedBox(height: 28),
          Text(
            "This small badge acts as a filter allowing us to sort throuh large amounts of data with one click! ",
            style: context.colours.b1,
            textAlign: TextAlign.center,
          ),
           const SizedBox(height: 40),
         SearchBox(hintText: 'Type here to search', onChanged: (value) => {},),
        ],
      ),
    ),
  );
}