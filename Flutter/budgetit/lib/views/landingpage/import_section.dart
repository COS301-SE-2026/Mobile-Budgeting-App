import 'package:flutter/material.dart';
import '../../utils/app_colour.dart';

class ImportSection extends StatelessWidget {
 
  const ImportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Split background: dark green top, cream bottom
        Column(
          children: [
            Container(height: 180, color: context.colours.primary),
            //Container(height: 420, color: colours.secondary),
          ],
        ),

        // Decorative circles sitting on the dark green band
        Positioned(
          top: -60,
          right: 40,
          child: _Circle(size: 130, color: context.colours.secondary),
        ),
        Positioned(
          top: 90,
          left: 60,
          child: _Circle(size: 110, color: context.colours.greenAccents),
        ),

        // Main content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phone screenshot
              Expanded(
  flex: 3,
  child: Center(
    child: SizedBox(
      width: 240,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/flow.jpg',
          fit: BoxFit.contain,
        ),
      ),
    ),
  
                ),
              ),
              const SizedBox(width: 40),

              // Headline
              Expanded(
  flex: 5,
  child: Padding(
    padding: const EdgeInsets.only(top: 80),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Import your banking statement for an auto-generated personalized budget.",
          style: TextStyle(
            color: context.colours.background,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1.2,
            fontFamily: 'Georgia',
          ),
        ),

        const SizedBox(height: 24),

        Text(
          "Simply upload your bank statement in CSV or PDF format and let "
          "Budget.IT automatically organize your transactions, categorize "
          "your spending, and create a budget tailored to your financial habits. "
          "No spreadsheets. No manual data entry. Just smarter budgeting in seconds.",
          style: TextStyle(
            color: context.colours.primary,
            fontSize: 18,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 30),

            const SizedBox(height: 40),

GridView.count(
  crossAxisCount: 2,
  shrinkWrap: true,
  crossAxisSpacing: 20,
  mainAxisSpacing: 20,
  childAspectRatio: 2.3,
  physics: const NeverScrollableScrollPhysics(),
  children: const [
    FeatureCard(
      icon: Icons.upload_file,
      title: "CSV & PDF Import",
      description:
          "Easily upload your bank statements in CSV or PDF format.",
    ),
    FeatureCard(
      icon: Icons.auto_awesome,
      title: "AI Smart Categorization",
      description:
          "Automatically categorize your transactions with intelligent accuracy.",
    ),
    FeatureCard(
      icon: Icons.pie_chart_outline,
      title: "Personalized Budget",
      description:
          "Generate a budget tailored to your spending habits.",
    ),
    FeatureCard(
      icon: Icons.bar_chart,
      title: "Financial Insights",
      description:
          "Understand your spending with clear analytics and trends.",
    ),
  ],
),    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
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
      decoration: BoxDecoration(color: Color.fromARGB(255, 252, 213, 85), shape: BoxShape.circle),
    );
  }
}
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colours.secondary, // cream
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colours.background, // dark green border
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: colours.background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: colours.secondary,
              size: 30,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colours.background,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description,
                  style: TextStyle(
                    color: colours.background.withValues(alpha: 0.85),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _FeatureChip extends StatelessWidget {
  final String text;

  const _FeatureChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white24,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}