import 'package:flutter/material.dart';
import '../../../utils/app_colour.dart';
import 'landing_responsive.dart';
import 'landing_motion.dart';
import 'feature_chip.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.colours.background,
      padding: EdgeInsets.symmetric(
          horizontal: context.sectionHPadding, vertical: 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About BudgetIT",
            style: TextStyle(
              color: context.colours.informational,
              fontSize: 34,
              fontWeight: FontWeight.bold,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  fontFamily: 'JetBrainsMono',
                  color: context.colours.whiteAccents,
                ),
                children: [
                  const TextSpan(
                    text: "Budget IT is a university software "
                        "engineering project developed by ",
                  ),
                  TextSpan(
                    text: "Dev Oops",
                    style: TextStyle(
                        color: context.colours.textPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: " and proudly sponsored by "),
                  TextSpan(
                    text: "Fuse IT",
                    style: TextStyle(
                        color: context.colours.textPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: " (2026). Our mission is to make budgeting "
                        "simple, accessible, and enjoyable. Especially without an ",
                  ),
                  TextSpan(
                    text: "internet connection.",
                    style: TextStyle(
                        color: context.colours.textPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              for (int i = 0; i < _badges.length; i++)
                RevealOnScroll(
                  delay: Duration(milliseconds: 60 * i),
                  child: FeatureChip(
                    icon: _badges[i].$1,
                    value: _badges[i].$2,
                    label: _badges[i].$3,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

const _badges = <(IconData, String?, String)>[
  (Icons.wifi_off_rounded, "100%", "offline"),
  (Icons.table_chart_outlined, "0", "spreadsheets"),
  (Icons.bolt_outlined, "3", "step setup"),
  (Icons.account_balance_outlined, null, "Bank imports"),
];