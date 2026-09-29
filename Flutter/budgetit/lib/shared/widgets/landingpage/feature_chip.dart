import 'package:flutter/material.dart';
import '../../../utils/app_colour.dart';

class FeatureChip extends StatelessWidget {
  const FeatureChip({
    super.key,
    required this.label,
    this.value,
    this.icon,
  });

  final String label;
  final String? value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: colours.whiteAccents.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colours.whiteAccents.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: colours.greenAccents),
            const SizedBox(width: 10),
          ],
          if (value != null) ...[
            Text(
              value!,
              style: TextStyle(
                color: colours.greenAccents,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                fontFamily: 'SpaceGrotesk',
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: colours.whiteAccents,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'JetBrainsMono',
            ),
          ),
        ],
      ),
    );
  }
}