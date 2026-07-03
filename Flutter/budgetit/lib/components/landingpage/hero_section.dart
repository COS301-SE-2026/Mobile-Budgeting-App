import 'package:flutter/material.dart';
import '../../utils/app_colour.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback? onGetStarted; //used chatgpt for voidcallback

  const HeroSection({super.key, this.onGetStarted});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}
  class _HeroSectionState extends State<HeroSection> {
    final colours = MyColours();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: colours.background,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative background circles
          Positioned(
            top: -40,
            left: 20,
            child: _Circle(size: 100, color: colours.primary),
          ),
          Positioned(
            top: 150,
            right: -100,
            child: _Circle(size: 500, color: colours.secondary),
          ),
          Positioned(
            bottom: -60,
            left: 60,
            child: _Circle(size: 220, color: colours.secondary),
          ),

          // Main content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to Budget IT",
                      style: TextStyle(
                        color: colours.textPrimary,
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia', // swap for your serif font
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Nerf your expenses with a budgeting app\nthat works anywhere.",
                      style: TextStyle(
                        color: colours.whiteAccents,
                        fontSize: 18,
                        fontFamily: 'Courier', // swap for your mono font
                      ),
                    ),
                    const SizedBox(height: 40),
                    Image.asset(
                      'assets/images/phone_mockup.png',
                      width: 340,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 300),
                  child: Text(
                    "Know exactly where your\nMONEY goes",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: colours.background,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double size;
  final Color color;
  const _Circle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _ActionButton extends StatelessWidget {
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
    final colours = MyColours();

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
    final colours = MyColours();
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
}