import 'package:flutter/material.dart';
import '../../utils/app_colour.dart';

class DownloadSection extends StatelessWidget {
  final colours = MyColours();
  DownloadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: colours.background,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _PlatformBadge(
                  icon: Icons.android_rounded,
                  label: "ANDROID BASED",
                ),
              ),
              _DownloadButton(),
            ],
          ),
          const SizedBox(height: 48),
          _PlatformBadge(
            icon: Icons.play_arrow_rounded,
            label: "AVAILABLE ON\nPLAY STORE",
          ),
        ],
      ),
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PlatformBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();
    return Row(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: MyColours().primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 60, color: colours.greenAccents),
        ),
        const SizedBox(width: 24),
        Text(
          label,
          style: TextStyle(
            color: colours.greenAccents,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            height: 1.4,
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
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        "Download the app",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }
}