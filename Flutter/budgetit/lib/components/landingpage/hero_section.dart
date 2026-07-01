import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onGetStarted;

  const HeroSection({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ...existing hero content...
        ElevatedButton(
          onPressed: onGetStarted,
          child: const Text('Get Started'),
        ),
      ],
    );
  }
}