import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/fab.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;



@widgetbook.UseCase(name: 'FAB', type: FAB)
Widget addButton(BuildContext context){
      return 

     
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "This is a FAB",
            style: context.colours.h2,
          ),
        ],),
          SizedBox(height: 28),
         Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          FAB(),

        ],),
           SizedBox(height: 28),
           
        ],
      );
    
}