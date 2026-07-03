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
//i used chatgpt to help me with the container  for the box and decorative circles
    @override
    Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 1000),
      color: colours.background,
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative background circles
          Positioned(
            top: -40,
            left: 20,
            child: _Circle(
                    size: 100, 
                    color: colours.primary, 
                    duration: const Duration(seconds: 3),
                    amplitude: 10,
                  ),
          ),
          Positioned(
            top: 40,
            right: 30,
            child: _Circle(
                    size: 220, 
                    color: colours.secondary,
                    duration: const Duration(seconds: 6),
                    amplitude: 25,
                  ),
          ),
          Positioned(
            top: 320,
            left: 30,
            child: _Circle(
              size: 120,
              color: colours.secondary,
              duration: const Duration(seconds: 6),
              amplitude: 25,
            ),
          ),
          Positioned(
            bottom: -60,
            left: 60,
            child: _Circle(
                    size: 220, 
                    color: colours.secondary,
                    duration: const Duration(seconds: 4),
                    amplitude: 18,),
          ),
          Positioned(
            top: 500,
            right: 250,
            child: _Circle(
              size: 90,
              color: colours.primary,
              duration: const Duration(seconds: 4),
              amplitude: 15,
            ),
          ),

          Positioned(
            top: 560,
            right: 120,
            child: _Circle(
              size: 60,
              color: colours.primary,
              duration: const Duration(seconds: 5),
              amplitude: 12,
            ),
          ),
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
                        fontFamily: 'Georgia', 
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Nerf your expenses with a budgeting app\nthat works anywhere.",
                      style: TextStyle(
                        color: colours.whiteAccents,
                        fontSize: 18,
                        fontFamily: 'Courier', 
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child:  Image.asset(
                          'assets/images/phone_mockup.jpg',
                          width: 400,
                          fit: BoxFit.contain,
                        ),
                      ),
                  ],
                ),
              ),
              
            ],
          ),
          Positioned(
            right: 120,
            top: 560,
            child: SizedBox(
              width: 280,
              height: 60,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: colours.background,
                  side: BorderSide(
                    color: colours.whiteAccents,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
               ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: colours.whiteAccents,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            right: 120,
            top: 640,
            child: SizedBox(
              width: 280,
              height: 60,
              child: ElevatedButton(
                onPressed: widget.onGetStarted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colours.whiteAccents,
                  foregroundColor: colours.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Circle extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;
  final double amplitude;
  const _Circle({required this.size, required this.color,this.duration = const Duration(seconds: 5),this.amplitude = 20,});
  @override
  State<_Circle> createState() => _CircleState();
}

class _CircleState extends State<_Circle>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
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
      builder: (context, child){
        final offset = widget.amplitude*(_controller.value - 0.510);
        return Transform.translate(offset: Offset(0,offset),child: child,);
      },
      child: Container(width: widget.size,
                        height: widget.size,
                        decoration: BoxDecoration(color: widget.color,
                        shape: BoxShape.circle,
                      ),
                    ),
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