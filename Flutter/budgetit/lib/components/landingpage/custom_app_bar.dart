import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/app_colour.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    super.key,
    required this.activeSection,
    required this.onHomeTap,
    required this.onFeaturesTap,
    required this.onHowItWorksTap,
    required this.onDownloadTap,
    required this.onAboutTap,
  });

  final String activeSection;
  final VoidCallback onHomeTap;
  final VoidCallback onFeaturesTap;
  final VoidCallback onHowItWorksTap;
  final VoidCallback onDownloadTap;
  final VoidCallback onAboutTap;

  final colours = MyColours();

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 80,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: MyColours().whiteAccents,
            border: Border(
              bottom: BorderSide(color: colours.background.withAlpha(30), width: 1),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/images/logo.png', height: 40, width: 40, fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              Text("Budget IT",
                  style: TextStyle(color: colours.background, fontWeight: FontWeight.bold, fontSize: 22, fontFamily: 'Georgia')),
              const Spacer(),
              _NavLink(text: "Home", isActive: activeSection == "Home", onTap: onHomeTap, colours: colours),
              const SizedBox(width: 36),
              _NavLink(text: "Features", isActive: activeSection == "Features", onTap: onFeaturesTap, colours: colours),
              const SizedBox(width: 36),
              _NavLink(text: "How it works", isActive: activeSection == "How it works", onTap: onHowItWorksTap, colours: colours),
              const SizedBox(width: 36),
              _NavLink(text: "About", isActive: activeSection == "About", onTap: onAboutTap, colours: colours),
              const SizedBox(width: 36),
              _NavLink(text: "Download App", isActive: activeSection == "Download App", onTap: onDownloadTap, colours: colours),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;
  final MyColours colours;
  const _NavLink({required this.text, required this.isActive, required this.onTap, required this.colours});

  //@override
   //State<_NavLink> createState() => _NavLinkState();
}
