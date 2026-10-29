import 'package:flutter/material.dart';
import '../../../utils/app_colour.dart';
import 'landing_responsive.dart';
import 'landing_motion.dart';

class _Screenshot {
  final String asset;
  final String title;
  final String caption;

  const _Screenshot(this.asset, this.title, this.caption);
}

const List<_Screenshot> _screenshots = [
  _Screenshot(
    'assets/images/screenshots/dashboard.jpg',
    "Dashboard",
    "Your balance, spending and budgets at a glance.",
  ),
  _Screenshot(
    'assets/images/screenshots/FAB.jpg',
    "Quick Actions",
    "Add a transaction or import a statement from one button.",
  ),
  _Screenshot(
    'assets/images/screenshots/Addtransaction.jpg',
    "Add Transaction",
    "Log an expense or income in a few taps.",
  ),
  _Screenshot(
    'assets/images/screenshots/tansactionmanager.jpg',
    "Transaction Manager",
    "Search, filter and edit every transaction.",
  ),
  _Screenshot(
    'assets/images/screenshots/budgetmanager.jpg',
    "Budget Manager",
    "Set limits per category and track progress.",
  ),
  _Screenshot(
    'assets/images/screenshots/ImportStatement.jpg',
    "Import Statement",
    "Upload a CSV or PDF bank statement.",
  ),
  _Screenshot(
    'assets/images/screenshots/Exportreport.jpg',
    "Export Report",
    "Manage your categories and export a spending report.",
  ),
];

class ScreenshotGallery extends StatelessWidget {
  const ScreenshotGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

    return Container(
      width: double.infinity,
      color: colours.primary,
      padding: EdgeInsets.symmetric(
        horizontal: context.sectionHPadding,
        vertical: 72,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "See it in action",
            style: TextStyle(
              color: colours.secondary,
              fontSize: context.isSmallMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              "A look at the screens you'll use every day to stay on top of your money.",
              style: TextStyle(
                color: colours.whiteAccents,
                fontSize: 16,
                height: 1.5,
                fontFamily: 'JetBrainsMono',
              ),
            ),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 24.0;
              final columns = context.isSmallMobile
                  ? 2
                  : context.isMobile
                  ? 3
                  : 4;
              final cardWidth =
                  ((constraints.maxWidth - spacing * (columns - 1)) / columns)
                      .clamp(0.0, 240.0);

              return Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: spacing,
                  runSpacing: 40,
                  children: [
                    for (int i = 0; i < _screenshots.length; i++)
                      RevealOnScroll(
                        delay: Duration(milliseconds: 80 * (i % columns)),
                        child: SizedBox(
                          width: cardWidth,
                          child: _ScreenshotCard(shot: _screenshots[i]),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ScreenshotCard extends StatelessWidget {
  final _Screenshot shot;
  const _ScreenshotCard({required this.shot});

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colours.secondary.withValues(alpha: 0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: AspectRatio(
            aspectRatio: 1080 / 2408,
            child: Image.asset(shot.asset, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          shot.title,
          style: TextStyle(
            color: colours.secondary,
            fontSize: context.isSmallMobile ? 16 : 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'SpaceGrotesk',
          ),
        ),
        const SizedBox(height: 6),
        Text(
          shot.caption,
          style: TextStyle(
            color: colours.whiteAccents,
            fontSize: context.isSmallMobile ? 12 : 13,
            height: 1.5,
            fontFamily: 'JetBrainsMono',
          ),
        ),
      ],
    );
  }
}
