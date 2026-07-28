import 'package:flutter/material.dart';
import '../../utils/app_colour.dart';

class HowItWorks extends StatelessWidget {
  
  const HowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.colours.background,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //used chatgpt for text construct and step item
          Text(
            "How it works :",
            style: TextStyle(
              color: context.colours.whiteAccents,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia', 
            ),
          ),
          const SizedBox(height: 40),

          _StepItem(
            number: "1",
            title: "Get Started",
            description:
                "Sign in or continue as a guest. Budget It works even "
                "when you're offline.",
            titleColor: context.colours.secondary,
            descriptionColor: context.colours.whiteAccents,
          ),
          const SizedBox(height: 32),

          _StepItem(
            number: "2",
            title: "Track your expenses",
            description:
                "Record expenses, income, bills, and savings goals in "
                "seconds.",
            titleColor: context.colours.secondary,
            descriptionColor: context.colours.whiteAccents,
          ),
          const SizedBox(height: 32),

          _StepItem(
            number: "3",
            title: "Upgrade Anytime",
            description:
                "Unlock bill splitting and cloud sync when you log in "
                "online.",
            titleColor: context.colours.secondary,
            descriptionColor: context.colours.whiteAccents,
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final Color titleColor;
  final Color descriptionColor;

  const _StepItem({
    required this.number,
    required this.title,
    required this.description,
    required this.titleColor,
    required this.descriptionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'CourierMono', 
              color: titleColor,
            ),
            children: [
              TextSpan(text: "$number."),
              TextSpan(text: title),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'CourierMono',//still to change this font
            color: descriptionColor,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}