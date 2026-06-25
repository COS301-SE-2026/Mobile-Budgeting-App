import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class InsightWidget extends StatefulWidget {
  final List<BudgetInsight> insights;

  const InsightWidget({super.key, required this.insights});

  @override
  State<InsightWidget> createState() => _InsightWidgetState();
}

class _InsightWidgetState extends State<InsightWidget>
    with SingleTickerProviderStateMixin {
  int _current = 0;

  late AnimationController _controller;

  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _navigate(int delta) {
    _controller.reverse().then((_) {
      setState(() {
        _current =
            (_current + delta + widget.insights.length) %
            widget.insights.length;
      });
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();
    if (widget.insights.isEmpty) {
      return const SizedBox.shrink();
    }
    final insight = widget.insights[_current];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              'Insight',

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colours.textPrimary,
              ),
            ),
            if (widget.insights.length > 1)
              Row(
                children: [
                  Text(
                    '${_current + 1}/${widget.insights.length}',

                    style: TextStyle(
                      fontSize: 12,

                      color: colours.textPrimary.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: 6),

                  _NavButton(
                    icon: Icons.chevron_left_rounded,

                    onTap: () => _navigate(-1),
                  ),

                  const SizedBox(width: 4),

                  _NavButton(
                    icon: Icons.chevron_right_rounded,

                    onTap: () => _navigate(1),
                  ),
                ],
              ),
          ],
        ),

        const SizedBox(height: 12),

        FadeTransition(
          opacity: _fade,

          child: _InsightCard(insight: insight),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final BudgetInsight insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: colours.navBarColor,

        borderRadius: BorderRadius.circular(16),

        border: Border(left: BorderSide(color: insight.accentColor, width: 3)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 36,
            height: 36,

            decoration: BoxDecoration(
              color: insight.accentColor.withValues(alpha: 0.15),

              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(insight.icon, size: 18, color: insight.accentColor),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        insight.title,

                        style: TextStyle(
                          fontSize: 14,

                          fontWeight: FontWeight.w600,

                          color: colours.textPrimary,
                        ),
                      ),
                    ),

                    _SeverityBadge(severity: insight.severity),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  insight.body,

                  style: TextStyle(
                    fontSize: 12,

                    color: colours.cardText.withValues(alpha: 0.6),

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

class _SeverityBadge extends StatelessWidget {
  final InsightSeverity severity;

  const _SeverityBadge({required this.severity});

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();

    final (label, bg, fg) = switch (severity) {
      InsightSeverity.tip => (
        'Tip',
        colours.tertiary.withValues(alpha: 0.15),
        colours.tertiary,
      ),

      InsightSeverity.warning => (
        'Warning',
        colours.secondary.withValues(alpha: 0.2),
        colours.textPrimary,
      ),

      InsightSeverity.alert => (
        'Alert',
        const Color(0x44B00020),
        Colors.redAccent,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),

      decoration: BoxDecoration(
        color: bg,

        borderRadius: BorderRadius.circular(6),
      ),

      child: Text(
        label,

        style: TextStyle(
          fontSize: 10,

          fontWeight: FontWeight.w600,

          color: fg,

          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();

    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 28,
        height: 28,

        decoration: BoxDecoration(
          color: colours.tertiary.withValues(alpha: 0.15),

          borderRadius: BorderRadius.circular(8),
        ),

        child: Icon(icon, size: 18, color: colours.textPrimary),
      ),
    );
  }
}

enum InsightSeverity { tip, warning, alert }

class BudgetInsight {
  final String title;
  final String body;
  final IconData icon;
  final Color accentColor;
  final InsightSeverity severity;

  const BudgetInsight({
    required this.title,
    required this.body,
    required this.icon,
    required this.accentColor,
    this.severity = InsightSeverity.tip,
  });
}
