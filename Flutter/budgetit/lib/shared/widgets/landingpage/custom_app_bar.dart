import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../utils/app_colour.dart';
import 'landing_responsive.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.activeSection,
    required this.onHomeTap,
    required this.onFeaturesTap,
    required this.onHowItWorksTap,
    required this.onDownloadTap,
    required this.onAboutTap,
    required this.onLogin,
    required this.onGetStarted,
  });

  final String activeSection;
  final VoidCallback onHomeTap;
  final VoidCallback onFeaturesTap;
  final VoidCallback onHowItWorksTap;
  final VoidCallback onDownloadTap;
  final VoidCallback onAboutTap;
  final VoidCallback onLogin;
  final VoidCallback onGetStarted;

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _menuOpen = false;

  void _closeMenu() {
    if (_menuOpen) setState(() => _menuOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final compact = context.isMobile;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 80),
          decoration: BoxDecoration(
            color: colours.secondary,
            border: Border(
              bottom: BorderSide(
                  color: colours.background.withAlpha(30), width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(

                padding: EdgeInsets.symmetric(
                    horizontal: context.sectionHPadding, vertical: 18),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset('assets/images/budgetit_logo.jpg',
                          height: 40, width: 40, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Budget IT",
                      style: TextStyle(
                        color: colours.background,
                        fontWeight: FontWeight.bold,
                        fontSize: compact ? 18 : 22,
                        fontFamily: 'SpaceGrotesk',
                      ),
                    ),
                    const Spacer(),
                    if (!compact) ...[
                      _NavLink(
                          text: "Home",
                          isActive: widget.activeSection == "Home",
                          onTap: widget.onHomeTap),
                      const SizedBox(width: 28),
                      _NavLink(
                          text: "Features",
                          isActive: widget.activeSection == "Features",
                          onTap: widget.onFeaturesTap),
                      const SizedBox(width: 28),
                      _NavLink(
                          text: "How it works",
                          isActive: widget.activeSection == "How it works",
                          onTap: widget.onHowItWorksTap),
                      const SizedBox(width: 28),
                      _NavLink(
                          text: "About",
                          isActive: widget.activeSection == "About",
                          onTap: widget.onAboutTap),
                      const SizedBox(width: 28),
                      _NavLink(
                          text: "Download App",
                          isActive: widget.activeSection == "Download App",
                          onTap: widget.onDownloadTap),

                      Container(
                        width: 1,
                        height: 22,
                        margin: const EdgeInsets.symmetric(horizontal: 22),
                        color: colours.background.withValues(alpha: 0.25),
                      ),
                      _NavLink(
                          text: "Login",
                          isActive: false,
                          onTap: widget.onLogin),
                      const SizedBox(width: 18),
                      _NavPill(text: "Get Started", onTap: widget.onGetStarted),
                    ] else
                      IconButton(
                        splashRadius: 22,
                        onPressed: () => setState(() => _menuOpen = !_menuOpen),
                        icon: Icon(
                          _menuOpen ? Icons.close_rounded : Icons.menu_rounded,
                          color: colours.background,
                        ),
                      ),
                  ],
                ),
              ),
              if (compact)
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  child: !_menuOpen
                      ? const SizedBox(width: double.infinity)
                      : Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: context.sectionHPadding,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: colours.background.withAlpha(30),
                                  width: 1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _MobileNavLink(
                                text: "Home",
                                isActive: widget.activeSection == "Home",
                                onTap: () {
                                  _closeMenu();
                                  widget.onHomeTap();
                                },
                              ),
                              _MobileNavLink(
                                text: "Features",
                                isActive: widget.activeSection == "Features",
                                onTap: () {
                                  _closeMenu();
                                  widget.onFeaturesTap();
                                },
                              ),
                              _MobileNavLink(
                                text: "How it works",
                                isActive:
                                    widget.activeSection == "How it works",
                                onTap: () {
                                  _closeMenu();
                                  widget.onHowItWorksTap();
                                },
                              ),
                              _MobileNavLink(
                                text: "About",
                                isActive: widget.activeSection == "About",
                                onTap: () {
                                  _closeMenu();
                                  widget.onAboutTap();
                                },
                              ),
                              _MobileNavLink(
                                text: "Download App",
                                isActive:
                                    widget.activeSection == "Download App",
                                onTap: () {
                                  _closeMenu();
                                  widget.onDownloadTap();
                                },
                              ),
                              const SizedBox(height: 4),
                              Divider(
                                  color: colours.background
                                      .withValues(alpha: 0.2)),
                              _MobileNavLink(
                                text: "Login",
                                isActive: false,
                                onTap: () {
                                  _closeMenu();
                                  widget.onLogin();
                                },
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: _NavPill(
                                  text: "Get Started",
                                  onTap: () {
                                    _closeMenu();
                                    widget.onGetStarted();
                                  },
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


class _NavPill extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const _NavPill({required this.text, required this.onTap});

  @override
  State<_NavPill> createState() => _NavPillState();
}

class _NavPillState extends State<_NavPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
          decoration: BoxDecoration(
            color: _hovered ? colours.greenAccents : colours.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: _hovered ? colours.background : colours.secondary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileNavLink extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;
  const _MobileNavLink(
      {required this.text, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? colours.informational : colours.background,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            fontSize: 16,
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
  const _NavLink(
      {required this.text, required this.isActive, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
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
                        ? colours.informational
                        : colours.background,
                    fontWeight:
                        widget.isActive ? FontWeight.bold : FontWeight.w600,
                    fontSize: 15,
                  ),
                  child: Text(widget.text),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  height: 2,
                  width: widget.isActive ? 22 : (_isHovered ? 14 : 0),
                  color: colours.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}