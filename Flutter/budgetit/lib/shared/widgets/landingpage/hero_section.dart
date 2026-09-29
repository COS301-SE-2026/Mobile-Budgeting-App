import 'package:flutter/material.dart';
import '../../../utils/app_colour.dart';
import 'landing_responsive.dart';
import 'landing_motion.dart';
import 'feature_chip.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  static const double _wideLayoutBreakpoint = 900;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= _wideLayoutBreakpoint;
        return wide ? _buildWideLayout(context) : _buildCompactLayout(context);
      },
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    final colours = context.colours;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 1000),
      color: colours.background,
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -40,
            left: 20,
            child: Parallax(
              factor: 0.20,
              child: _Circle(
                size: 100,
                color: colours.primary,
                duration: const Duration(seconds: 3),
                amplitude: 10,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 30,
            child: Parallax(
              factor: 0.24,
              child: _Circle(
                size: 220,
                color: colours.secondary,
                duration: const Duration(seconds: 6),
                amplitude: 25,
              ),
            ),
          ),
          Positioned(
            top: 320,
            left: 30,
            child: Parallax(
              factor: 0.16,
              child: _Circle(
                size: 120,
                color: colours.secondary,
                duration: const Duration(seconds: 6),
                amplitude: 25,
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: 60,
            child: Parallax(
              factor: 0.22,
              child: _Circle(
                size: 220,
                color: colours.secondary,
                duration: const Duration(seconds: 4),
                amplitude: 18,
              ),
            ),
          ),
          Positioned(
            top: 500,
            right: 250,
            child: Parallax(
              factor: 0.12,
              child: _Circle(
                size: 90,
                color: colours.primary,
                duration: const Duration(seconds: 4),
                amplitude: 15,
              ),
            ),
          ),
          Positioned(
            top: 560,
            left: 120,
            child: const Parallax(
              factor: 0.08,
              child: _Circle(
                size: 60,
                color: kCream,
                duration: Duration(seconds: 5),
                amplitude: 12,
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            right: 90,
            child: Parallax(
              factor: 0.18,
              child: _Circle(
                size: 140,
                color: colours.primary,
                duration: const Duration(seconds: 7),
                amplitude: 20,
              ),
            ),
          ),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
              color: colours.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to BudgetIT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colours.informational,
                      fontSize: 44,
                      height: 1.1,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  "Nerf your expenses with a budgeting app\nthat works anywhere.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colours.whiteAccents,
                    fontSize: 18,
                    height: 1.5,
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
              
              const SizedBox(height: 28),
              const _HeroStats(),
              const SizedBox(height: 16),
              Text(
                "No account needed — continue as a guest.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colours.whiteAccents.withValues(alpha: 0.6),
                  fontSize: 13,
                  fontFamily: 'JetBrainsMono',
                ),
              ),
              const SizedBox(height: 40),
              Image.asset(
                'assets/images/dashboard.jpg',
                width: 400,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
        ),
      ],
      ),
    );
  }

  Widget _buildCompactLayout(BuildContext context) {
    final colours = context.colours;
    final hPad = context.sectionHPadding;

    return Container(
      width: double.infinity,
      color: colours.background,
      child: ClipRect(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              top: -30,
              right: -20,
              child: Parallax(
                factor: 0.20,
                child: _Circle(
                    size: 120,
                    color: colours.secondary,
                    duration: const Duration(seconds: 6),
                    amplitude: 14),
              ),
            ),
            Positioned(
              top: 60,
              left: -30,
              child: Parallax(
                factor: 0.10,
                child: _Circle(
                    size: 90,
                    color: colours.primary,
                    duration: const Duration(seconds: 4),
                    amplitude: 10),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 48, hPad, 48),
              child: Container(
                width: double.infinity,
                color: colours.background,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to Budget IT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colours.informational,
                      fontSize: context.isSmallMobile ? 30 : 36,
                      height: 1.1,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Nerf your expenses with a budgeting app that works anywhere.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colours.whiteAccents,
                      fontSize: 16,
                      fontFamily: 'JetBrainsMono',
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _HeroStats(),
                  const SizedBox(height: 32),
                  Text(
                    "No Account Needed - continue as guest.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colours.whiteAccents.withValues(alpha:0.6),
                      fontSize: 13,
                      fontFamily: 'JetBrainsMono',
                    ),
                  ),
                  const SizedBox(height:32),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Image.asset(
                        'assets/images/phone_mockup.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  /*const SizedBox(height: 32),
                  _AuthPanel(
                    onLogin: widget.onLogin,
                    onGetStarted: widget.onGetStarted,
                    stretch: true,
                  ),*/
                ],
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _HeroStats extends StatelessWidget {
  const _HeroStats();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        FeatureChip(value: "100%", label: "offline"),
        FeatureChip(value: "0", label: "spreadsheets"),
        FeatureChip(value: "3", label: "step setup"),
      ],
    );
  }
}

class _AuthPanel extends StatelessWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onGetStarted;
  final bool stretch;

  const _AuthPanel({this.onLogin, this.onGetStarted, this.stretch = false});

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

    final buttons = <Widget>[
      SizedBox(
        width: stretch ? double.infinity : 280,
        height: 56,
        child: ElevatedButton(
          onPressed: onGetStarted,
          style: ElevatedButton.styleFrom(
            backgroundColor: colours.whiteAccents,
            foregroundColor: colours.background,
            elevation: 4,
            shadowColor: Colors.black.withValues(alpha: 0.3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            "Get Started",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
        ),
      ),
      const SizedBox(height: 14),
      SizedBox(
        width: stretch ? double.infinity : 280,
        height: 56,
        child: OutlinedButton(
          onPressed: onLogin,
          style: OutlinedButton.styleFrom(
            backgroundColor: colours.background,
            side: BorderSide(
                color: colours.whiteAccents.withValues(alpha: 0.45), width: 2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            "Login",
            style: TextStyle(
              color: colours.whiteAccents,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
        ),
      ),
    ];

    if (stretch) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...buttons,
        const SizedBox(height: 16),
        Text(
          "No account needed — continue as a guest.",
          textAlign: TextAlign.right,
          style: TextStyle(
            color: colours.whiteAccents.withValues(alpha: 0.6),
            fontSize: 13,
            fontFamily: 'JetBrainsMono',
          ),
        ),
      ],
    );
  }
}

class _Circle extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;
  final double amplitude;
  const _Circle({
    required this.size,
    required this.color,
    this.duration = const Duration(seconds: 5),
    this.amplitude = 20,
  });

  @override
  State<_Circle> createState() => _CircleState();
}

class _CircleState extends State<_Circle> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = widget.amplitude * (_controller.value - 0.510);
        return Transform.translate(offset: Offset(0, offset), child: child);
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.black, width: 3),
        ),
      ),
    );
  }
}

/*class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color textColor;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: textColor, size: 18),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: textColor, fontSize: 11)),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool isPositive;

  const _TransactionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

    return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colours.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colours.primary),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: colours.secondary,
              child: Icon(icon, color: colours.background, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: colours.whiteAccents, fontSize: 13)),
                  Text(subtitle, style: TextStyle(color: colours.whiteAccents, fontSize: 10)),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: isPositive ? Colors.greenAccent : Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
  }
}

class _BudgetBar extends StatelessWidget {
  final String label;
  final double spent;
  final double total;
  final Color color;

  const _BudgetBar({
    required this.label,
    required this.spent,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final percent = (spent / total).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: colours.whiteAccents, fontSize: 11)),
              Text(
                "R ${spent.toStringAsFixed(0)} / R ${total.toStringAsFixed(0)}",
                style: TextStyle(color: colours.whiteAccents, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: Colors.black26,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}*/