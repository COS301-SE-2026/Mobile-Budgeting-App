import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final String title;
  final String saved;
  final String target;
  final double progress;

  const GoalCard({
    super.key,
    required this.title,
    required this.saved,
    required this.target,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: colours.background,

        borderRadius: BorderRadius.circular(25),

        border: Border.all(color: colours.secondary.withValues(alpha: 0.2)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),

            blurRadius: 10,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                title,

                style: TextStyle(
                  color: colours.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Icon(Icons.flag, color: colours.tertiary),
            ],
          ),

          const SizedBox(height: 15),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,

              backgroundColor: colours.secondary.withValues(alpha: 0.2),

              color: colours.tertiary,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                "Saved: $saved",

                style: TextStyle(
                  color: colours.textPrimary,

                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                "Target: $target",

                style: TextStyle(
                  color: colours.textPrimary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
