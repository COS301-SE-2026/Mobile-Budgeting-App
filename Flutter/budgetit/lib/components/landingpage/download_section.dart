import 'package:flutter/material.dart';
import '../../utils/app_colour.dart';

class DownloadSection extends StatelessWidget {
  final colours = MyColours();
  DownloadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: colours.primary,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _PlatformBadge(
                icon: Icons.android,
                iconColor: colours.greenAccents,// i dont know if i should use our green or the actual logo one, maybe a picture
                label: "ANDROID BASED",
                labelColor: colours.greenAccents,
              ),
              const Spacer(),
              _DownloadButton(),
            ],
          ),
          const SizedBox(height: 40),
          _PlatformBadge(
            icon: Icons.play_arrow_rounded,
            iconColor: Colors.greenAccent,
            label: "AVAILABLE ON\nPLAY STORE",
            labelColor: colours.greenAccents,
          ),
        ],
      ),
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color labelColor;

  const _PlatformBadge({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            color: MyColours().primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 60, color: iconColor),
        ),
        const SizedBox(width: 20),
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _DownloadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colours = MyColours();
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: colours.secondary,
        foregroundColor: MyColours().background,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        "Download the app",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}