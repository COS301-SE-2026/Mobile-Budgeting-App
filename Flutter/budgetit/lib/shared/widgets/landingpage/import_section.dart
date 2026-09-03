import 'package:flutter/material.dart';
import '../../../utils/app_colour.dart';
import 'landing_responsive.dart';
import 'equal_height_grid.dart';
import 'landing_motion.dart';

class _FeatureData {
  final IconData icon;
  final String title;
  final String description;
  final String imageAsset;

  const _FeatureData({
    required this.icon,
    required this.title,
    required this.description,
    required this.imageAsset,
  });
}

const List<_FeatureData> _features = [
  _FeatureData(
    icon: Icons.upload_file,
    title: "CSV & PDF Import",
    description: "Easily upload your bank statements in CSV or PDF format.",
    imageAsset: 'assets/images/Imports.jpeg',
  ),
  _FeatureData(
    icon: Icons.auto_awesome,
    title: "AI Smart Categorization",
    description:
        "Automatically categorize your transactions with intelligent accuracy.",
    imageAsset: 'assets/images/feature_categorization.jpg',
  ),
  _FeatureData(
    icon: Icons.pie_chart_outline,
    title: "Personalized Budget",
    description: "Generate a budget tailored to your spending habits.",
    imageAsset: 'assets/images/Budgets.jpg',
  ),
  _FeatureData(
    icon: Icons.bar_chart,
    title: "Financial Insights",
    description: "Understand your spending with clear analytics and trends.",
    imageAsset: 'assets/images/insights.jpg',
  ),
];

final ValueNotifier<int> selectedFeatureIndex = ValueNotifier<int>(0);
final ValueNotifier<Set<int>> exploredFeatures = ValueNotifier<Set<int>>({0});

class ImportSection extends StatefulWidget {
  const ImportSection({super.key});

  @override
  State<ImportSection> createState() => _ImportSectionState();
}

class _ImportSectionState extends State<ImportSection> {
  void _select(int i) {
    selectedFeatureIndex.value = i;
    if (!exploredFeatures.value.contains(i)) {
      exploredFeatures.value = {...exploredFeatures.value, i};
    }
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final hPad = context.sectionHPadding;

    return Container(
      width: double.infinity,
      color: colours.primary,
      child: ClipRect(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 72),
              child: context.isMobile
                  ? _buildCompactLayout(context)
                  : _buildWideLayout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    final colours = context.colours;

    return ValueListenableBuilder<int>(
      valueListenable: selectedFeatureIndex,
      builder: (context, selected, _) {
        final feature = _features[selected];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: SizedBox(
                    width: 240,
                    child: _FeatureScreenshot(
                        asset: feature.imageAsset, feature: feature),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 48),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Text(
                      "Import your banking statement for an auto-generated personalized budget.",
                      style: TextStyle(
                        color: colours.secondary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        fontFamily: 'SpaceGrotesk',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Text(
                      "Simply upload your bank statement in CSV or PDF format and let "
                      "BudgetIT automatically organize your transactions, categorize "
                      "your spending, and create a budget tailored to your financial habits. "
                      "No spreadsheets. No manual data entry. Just smarter budgeting in seconds.",
                      style: TextStyle(
                        color: colours.whiteAccents,
                        fontSize: 17,
                        height: 1.6,
                        fontFamily: 'JetBrainsMono',
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  //const _ExploreTracker(),
                  //const SizedBox(height: 20),
                  _buildGrid(context, selected, context.featureColumns),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCompactLayout(BuildContext context) {
    final colours = context.colours;

    return ValueListenableBuilder<int>(
      valueListenable: selectedFeatureIndex,
      builder: (context, selected, _) {
        final feature = _features[selected];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 220,
                child: _FeatureScreenshot(
                    asset: feature.imageAsset, feature: feature),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Import your banking statement for an auto-generated personalized budget.",
              style: TextStyle(
                color: colours.secondary,
                fontSize: context.isSmallMobile ? 24 : 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
                fontFamily: 'SpaceGrotesk',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Simply upload your bank statement in CSV or PDF format and let "
              "BudgetIT automatically organize your transactions, categorize "
              "your spending, and create a budget tailored to your financial habits.",
              style: TextStyle(
                color: colours.whiteAccents,
                fontSize: 15,
                height: 1.6,
                fontFamily: 'JetBrainsMono',
              ),
            ),
            const SizedBox(height: 28),
            //const _ExploreTracker(),
            //const SizedBox(height: 20),
            _buildGrid(context, selected, 1),
          ],
        );
      },
    );
  }

  Widget _buildGrid(BuildContext context, int selected, int columns) {
    return ValueListenableBuilder<Set<int>>(
      valueListenable: exploredFeatures,
      builder: (context, explored, _) => EqualHeightGrid(
        columns: columns,
        spacing: 20,
        runSpacing: 20,
        children: [
          for (int i = 0; i < _features.length; i++)
            RevealOnScroll(
              delay: Duration(milliseconds: 70 * i),
              child: FeatureCard(
                icon: _features[i].icon,
                title: _features[i].title,
                description: _features[i].description,
                selected: selected == i,
                explored: explored.contains(i),
                onTap: () => _select(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExploreTracker extends StatelessWidget {
  const _ExploreTracker();

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

    return ValueListenableBuilder<Set<int>>(
      valueListenable: exploredFeatures,
      builder: (context, explored, _) {
        final count = explored.length;
        final total = _features.length;
        final done = count == total;

        return Row(
          children: [
            Icon(
              done ? Icons.verified_rounded : Icons.touch_app_outlined,
              size: 18,
              color: done ? kAmber : colours.whiteAccents.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 10),
            Text(
              done ? "All features explored" : "Tap a card  ·  $count / $total",
              style: TextStyle(
                color: done
                    ? kAmber
                    : colours.whiteAccents.withValues(alpha: 0.75),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'JetBrainsMono',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: [
                    Container(
                      height: 5,
                      color: colours.whiteAccents.withValues(alpha: 0.12),
                    ),
                    AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOut,
                      widthFactor: count / total,
                      child: Container(
                        height: 5,
                        color: done ? kAmber : colours.greenAccents,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FeatureScreenshot extends StatelessWidget {
  final String asset;
  final _FeatureData feature;
  const _FeatureScreenshot({required this.asset, required this.feature});

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
            scale: Tween(begin: 0.97, end: 1.0).animate(animation),
            child: child),
      ),
      child: Container(
        key: ValueKey(asset),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: colours.secondary.withValues(alpha: 0.25), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => AspectRatio(
            aspectRatio: 9 / 16,
            child: Container(
              color: colours.secondary,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(feature.icon, size: 48, color: colours.background),
                  const SizedBox(height: 12),
                  Text(
                    feature.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colours.background,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Screenshot coming soon",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colours.background.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontFamily: 'JetBrainsMono',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final bool explored;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.selected = false,
    this.explored = false,
    this.onTap,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final active = widget.selected;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor:
          widget.onTap == null ? MouseCursor.defer : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: colours.secondary,
              borderRadius: BorderRadius.zero,
              border: Border.all(
                color: Colors.black,
                width: active ? 4 : 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: active ? colours.greenAccents : Colors.black,
                  blurRadius: 0,
                  offset: Offset(active || _isHovered ? 6 : 4,
                      active || _isHovered ? 6 : 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: active ? colours.greenAccents : colours.background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    color: active ? colours.background : colours.secondary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                color: colours.background,
                                fontSize: 20,
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SpaceGrotesk',
                              ),
                            ),
                          ),
                          if (widget.explored && !active) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.check_circle_rounded,
                                size: 18,
                                color: colours.background
                                    .withValues(alpha: 0.35)),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.description,
                        style: TextStyle(
                          color: colours.background.withValues(alpha: 0.85),
                          fontSize: 14.5,
                          height: 1.5,
                          fontFamily: 'JetBrainsMono',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}