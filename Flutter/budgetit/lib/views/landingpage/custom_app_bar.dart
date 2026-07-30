import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/app_colour.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
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
            color: context.colours.secondary,
            border: Border(
              bottom: BorderSide(color: context.colours.background.withAlpha(30), width: 1),
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
                  style: TextStyle(color: context.colours.background, fontWeight: FontWeight.bold, fontSize: 22, fontFamily: 'Georgia')),
              const Spacer(),
              _NavLink(text: "Home", isActive: activeSection == "Home", onTap: onHomeTap, context: context),
              const SizedBox(width: 36),
              _NavLink(text: "Features", isActive: activeSection == "Features", onTap: onFeaturesTap,context: context),
              const SizedBox(width: 36),
              _NavLink(text: "How it works", isActive: activeSection == "How it works", onTap: onHowItWorksTap, context: context),
              const SizedBox(width: 36),
              _NavLink(text: "About", isActive: activeSection == "About", onTap: onAboutTap, context: context),
              const SizedBox(width: 36),
              _NavLink(text: "Download App", isActive: activeSection == "Download App", onTap: onDownloadTap, context: context),
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
  final BuildContext context;
  const _NavLink({required this.text, required this.isActive, required this.onTap, required this.context});

  @override
   State<_NavLink> createState() => _NavLinkState();
}
class _NavLinkState extends State<_NavLink> {
  bool _isPressed = false;
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 150),
                  style: TextStyle(
                    color: _isHovered || widget.isActive
                        ? widget.context.colours.greenAccents
                        : widget.context.colours.background,
                    fontWeight: widget.isActive ? FontWeight.bold : FontWeight.w600,
                    fontSize: 15,
                  ),
                  child: Text(widget.text),
                  ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2,
                  width: widget.isActive ? 22 : (_isHovered ? 14 : 0),
                  color: Color.fromARGB(255, 252, 213, 85),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}