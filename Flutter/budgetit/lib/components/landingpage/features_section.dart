import '../../utils/app_colour.dart';

import 'package:flutter/material.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();

    final List<Map<String, String>> features = [
      
      {
        "title": "Offline-First Transaction Management",
        "description":
            "Runs entirely on your device with no internet connection required."
      },
      {
        "title": "Bills & Subscriptions",
        "description":
            "Track recurring payments in one place. Know what is due, what is scheduled and what you can cut."
      },
      {
        "title": "Budget Goals",
        "description":
            "Set spending limits, monitor progress in real time and get notified before you overspend."
      },
      {
        "title": "Bank-grade Security",
        "description":
            "Biometric authentication and encryption keep your financial information safe."
      },
      {
        "title": "Real time Analytics",
        "description":
            "View spending trends, category breakdowns and monthly insights instantly."
      },
      {
        "title": "Statement Import",
        "description":
            "Upload CSV or PDF bank statements and Budget IT automatically categorises transactions."
      },//might change to just bank statement
    ];

    return Container(
      width: double.infinity,
      color: MyColours().secondary,
      padding: const EdgeInsets.symmetric(
        horizontal: 70,
        vertical: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Features",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: colours.primary,
            ),
          ),

          const SizedBox(height: 45),

          Wrap(
            spacing: 30,
            runSpacing: 30,
            children: features
                .map(
                  (feature) => SizedBox(
                    width: 320,
                    height: 210,
                    child: _FeatureCard(
                      title: feature["title"]!,
                      description: feature["description"]!,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String description;

  const _FeatureCard({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colours.background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colours.primary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            description,
            style: TextStyle(
              color: colours.textPrimary,
              fontSize: 18,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}