import 'package:flutter/material.dart';
import '../../utils/app_colour.dart';

class CustomAppBar extends StatelessWidget {
  final colours = MyColours();
  CustomAppBar({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      color: colours.whiteAccents,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Budget IT",
            style: TextStyle(
              color: colours.primary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text("Features"),
              ),

              TextButton(
                onPressed: () {},
                child: const Text("About"),
              ),

              TextButton(
                onPressed: () {},
                child: const Text("Download"),
              ),

              const SizedBox(width: 20),

              ElevatedButton(
                onPressed: () {},
                child: const Text("Get Started"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}