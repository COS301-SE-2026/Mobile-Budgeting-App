import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const ActionButton({super.key, required this.icon, required this.label});

  // theme colors
  static const Color darkGreen = Color(0xFF04240C);
  static const Color cream = Color(0xFFDDD6AE);
  static const Color teal = Color(0xFF137E84);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,

      padding: const EdgeInsets.symmetric(vertical: 15),

      decoration: BoxDecoration(
        color: darkGreen,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: cream.withValues(alpha: 0.25), width: 1),

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
          Icon(icon, size: 30, color: cream),

          const SizedBox(height: 10),

          Text(
            label,

            textAlign: TextAlign.center,

            style: const TextStyle(
              color: cream,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
