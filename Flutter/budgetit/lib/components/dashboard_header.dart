import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {

  const DashboardHeader({super.key});

  static const Color darkGreen = Color(0xFF04240C);
  static const Color cream = Color(0xFFDDD6AE);

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),

      child: Container(

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),

        decoration: BoxDecoration(

          color: cream.withOpacity(0.18),

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: cream.withOpacity(0.15),
          ),
        ),

        child: Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            // left side
            Row(

              children: [

                const Icon(
                  Icons.menu,
                  color: cream,
                  size: 20,
                ),

                const SizedBox(width: 10),

                const Text(
                  "Budget IT",

                  style: TextStyle(
                    color: cream,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // right side icons
            Row(

              children: [

                Container(

                  padding: const EdgeInsets.all(6),

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: cream.withOpacity(0.3),
                    ),
                  ),

                  child: const Icon(
                    Icons.person_outline,
                    color: cream,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 10),

                Container(

                  padding: const EdgeInsets.all(6),

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: cream.withOpacity(0.3),
                    ),
                  ),

                  child: const Icon(
                    Icons.settings_outlined,
                    color: cream,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}