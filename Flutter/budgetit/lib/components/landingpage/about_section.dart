import 'package:flutter/material.dart';
import '../../utils/app_colour.dart';

class AboutSection extends StatelessWidget {
  final colours = MyColours();
  AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: colours.background,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About Budget IT",
            style: TextStyle(
              color: Color.fromARGB(255, 252, 213, 85),
              fontSize: 34,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia', // for now i will use Georgia @PavthePekka
            ),
          ),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                fontFamily: 'CourierMono', //for now
                color: colours.whiteAccents,
              ),
              children: [
                const TextSpan(
                  text: "Budget IT is a university software "
                      "engineering project developed by ",
                ),
                TextSpan(
                  text: "Dev Oops",
                  style: TextStyle(color:colours.textPrimary, fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: " and proudly sponsored by "),
                TextSpan(
                  text: "Fuse IT",
                  style: TextStyle(color:colours.textPrimary, fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: " (2026). Our mission is to make budgeting "
                      "simple, accessible, and enjoyable. Especially without an ",
                ),
                TextSpan(
                  text: "internet connection.",
                  style: TextStyle(color: colours.textPrimary, fontWeight: FontWeight.bold),
                ),//making the different color effects for capturing the most important parts
              ],
            ),
          ),
        ],
      ),
    );
  }
}