import 'package:flutter/material.dart';

import 'package:budgetit/utils/app_colour.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
 
class Intro {}

@widgetbook.UseCase(
  name: "Intro",
  type: Intro,
  path: '[Brand Style Guide]',

)
Widget addButton(BuildContext context) {
  return Scaffold(
    backgroundColor: context.colours.background, 
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "WELCOME TO OUR BRAND STYLE GUIDE!",
            style: context.colours.h1,
          ),
          
           const SizedBox(height: 28),
           
          Text(
            "From our colours to fonts to sizing , every deliberate choice in our intricate UI process can be found here!",
            style: context.colours.h2,
            textAlign: TextAlign.center,
          ),
           const SizedBox(height: 40),
          Text(
            "To start please navigate to the Navigation section, on mobile you will have to click it to bring up the folder structure you can interact with.\n You can then click on any section to explore! \n Note: Use the Addons Tab (click on the bottom navbar on mobile and the right and navbar on PC) to toggle between light and dark mode. \n PS: Keep a lookout! On certain sections you can use the Knob tab to mess around even further! :)",
            textAlign: TextAlign.center,
            style: context.colours.b1,
          )
        ],
      ),
    ),
  );
}