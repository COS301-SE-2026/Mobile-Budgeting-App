import 'package:flutter/material.dart';
import 'package:budgetit/utils/app_colour.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _iconOpacity;
  late final Animation<double> _iconScale;
  late final Animation<double> _nameOpacity;
  late final Animation<double> _sloganOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _iconOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.3, curve: Curves.easeOut),
    );
    _iconScale = Tween<double>(begin: 0.82, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.35, curve: Curves.easeOutBack),
      ),
    );
    _nameOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.7, curve: Curves.easeIn),
    );
    _sloganOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.colours.primary;
    final textColor = context.colours.cardText;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: _iconOpacity,
                child: ScaleTransition(
                  scale: _iconScale,
                  child: const Image(
                    image: AssetImage('assets/images/app_icon.png'),
                    width: 210,
                    height: 210,
                    semanticLabel: 'Budget IT B icon',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FadeTransition(
                opacity: _nameOpacity,
                child: Text(
                  'Budget IT',
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 24,
                    color: textColor,
                  ),
                ),
              ),
             SizedBox(height: 18),
              FadeTransition(
                opacity: _sloganOpacity,
                child: Text(
                  'Make every rand count',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 18,
                    color: textColor,
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
