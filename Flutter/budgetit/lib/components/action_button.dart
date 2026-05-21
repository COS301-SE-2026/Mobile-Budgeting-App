import 'package:flutter/material.dart';
import '../utils/app_colour.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final colours = MyColours();
  ActionButton({super.key, required this.icon, required this.label});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,

      padding: const EdgeInsets.symmetric(vertical: 15),

      decoration: BoxDecoration(
        color: colours.background,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: colours.secondary.withValues(alpha: 0.25), width: 1,),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icon, size: 30, color: colours.secondary),

          const SizedBox(height: 10),

          Text(
            label,

            textAlign: TextAlign.center,

            style: TextStyle(
              color: colours.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
