import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final searchBackground = Color.alphaBlend(
      colours.cardText.withValues(alpha: 0.13),
      colours.primary.withValues(alpha: 1),
    );
    final searchForeground = colours.cardText;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),

      padding: const EdgeInsets.symmetric(horizontal: 15),

      height: 55,

      decoration: BoxDecoration(
        color: searchBackground,

        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: colours.background.withValues(alpha: 0.2)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Icon(Icons.search, color: searchForeground),

          const SizedBox(width: 10),

          Text(
            "Search transactions...",

            style: TextStyle(color: searchForeground, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
