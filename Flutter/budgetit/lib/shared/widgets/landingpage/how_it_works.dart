import 'package:flutter/material.dart';
import '../../../utils/app_colour.dart';
import 'landing_responsive.dart';
import 'landing_motion.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({super.key});

  static const _steps = [
    (
      "Get Started",
      "Sign in or continue as a guest. BudgetIt works even when you're offline."
    ),
    (
      "Track your expenses",
      "Record expenses, income, bills, and savings goals in seconds."
    ),
    (
      "Upgrade Anytime",
      "Unlock bill splitting and cloud sync when you log in online."
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.colours.background,
      padding: EdgeInsets.symmetric(
          horizontal: context.sectionHPadding, vertical: 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How it works",
            style: TextStyle(
              color: context.colours.whiteAccents,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          const SizedBox(height: 40),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < _steps.length; i++)
                  _StepItem(
                    number: i + 1,
                    title: _steps[i].$1,
                    description: _steps[i].$2,
                    isLast: i == _steps.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final bool isLast;

  const _StepItem({
    required this.number,
    required this.title,
    required this.description,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

    return RevealOnScroll(
      triggerFraction: 0.82,
      builder: (context, reached) => Stack(
        children: [
          if (!isLast)
            Positioned(
              left: 21,
              top: 44,
              bottom: 0,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: 2,
                    color: colours.whiteAccents.withValues(alpha: 0.15),
                  ),
                  AnimatedFractionallySizedBox(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    heightFactor: reached ? 1 : 0,
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 2,
                      color: colours.greenAccents,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: reached
                      ? colours.greenAccents
                      : colours.whiteAccents.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: reached
                        ? colours.greenAccents
                        : colours.whiteAccents.withValues(alpha: 0.25),
                    width: 2,
                  ),
                ),
                child: Text(
                  "$number",
                  style: TextStyle(
                    color: reached
                        ? colours.background
                        : colours.whiteAccents.withValues(alpha: 0.7),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SpaceGrotesk',
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 36, top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SpaceGrotesk',
                          color: colours.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'JetBrainsMono',
                          color: colours.whiteAccents,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}