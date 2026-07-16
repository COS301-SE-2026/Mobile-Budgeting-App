import 'package:flutter/material.dart';
import '../../utils/app_colour.dart';

class Footer extends StatelessWidget {
  final colours = MyColours();
  Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: colours.background,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: Column(
        children: [
          
          Text(
            "© 2026 Dev Oops. All rights reserved.",
            style: TextStyle(
              color: colours.whiteAccents,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  const _FooterLink(this.label);

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextButton(
        onPressed: () {},
        child: Text(
          label,
          style: TextStyle(color: colours.whiteAccents),
        ),
      ),
    );
  }
}