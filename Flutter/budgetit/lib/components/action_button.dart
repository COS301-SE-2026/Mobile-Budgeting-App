import 'package:flutter/material.dart';
import '../utils/app_colour.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const ActionButton({super.key, required this.icon, required this.label});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,

      padding: const EdgeInsets.symmetric(vertical: 15),

      decoration: BoxDecoration(
        color: MyColours.background,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: MyColours.secondary.withValues(alpha: 0.25), width: 1,),

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
          Icon(icon, size: 30, color: MyColours.secondary),

          const SizedBox(height: 10),

          Text(
            label,

            textAlign: TextAlign.center,

            style: const TextStyle(
              color: MyColours.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
