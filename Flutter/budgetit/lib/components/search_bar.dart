import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {

  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {

    final colours = MyColours();

    return Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),

      height: 55,

      decoration: BoxDecoration(

        color: colours.secondary,

        borderRadius:
            BorderRadius.circular(15),

        border: Border.all(
          color: colours.background
              .withValues(alpha: 0.2),
        ),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.15,
            ),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(

        children: [

          Icon(
            Icons.search,
            color: colours.background,
          ),

          const SizedBox(width: 10),

          Text(
            "Search transactions...",

            style: TextStyle(
              color: colours.background
                  .withValues(alpha: 0.7),

              fontSize:
                  colours.bodyFontSize,
            ),
          ),
        ],
      ),
    );
  }
}