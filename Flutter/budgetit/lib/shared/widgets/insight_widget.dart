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
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor = isDark ? colours.textPrimary : colours.secondary;

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
                color: headingColor,
              ),
            ),
            if (widget.insights.length > 1)
              Row(
                children: [
                  Text(
                    '${_current + 1}/${widget.insights.length}',

                    style: TextStyle(
                      fontSize: 12,

                      color: headingColor.withValues(alpha: 0.7),
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
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? colours.blendedprimary: colours.secondary;
    final cardTextColor = isDark ? colours.secondary: colours.background;
    final mutedCardText = cardTextColor.withValues(alpha: 0.75);
    final isAlert = insight.severity == InsightSeverity.alert;
    final signalColor = isAlert ? colours.error:cardTextColor;

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 36,
            height: 36,

            decoration: BoxDecoration(
              color: signalColor.withValues(alpha: isAlert ? 0.22 : 0.14),
              border: Border.all(color: signalColor),
            ),
            child: Icon(insight.icon, size: 18, color: signalColor),
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
                          color: cardTextColor,
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
                    color: mutedCardText,
                    height: 1.5,
                  ),
                ),
                if (insight.transactionDescription != null) ...[
                  const SizedBox(height: 16),
                  Divider(color: cardTextColor.withValues(alpha: 0.35)),
                  const SizedBox(height: 12),
                  Text(
                    'Anomolous Transaction',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: mutedCardText,
                    ),
                  ),

                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardTextColor.withValues(alpha: 0.08),
                      border: Border.all(
                        color: cardTextColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          insight.transactionDescription!,
                          style: TextStyle(
                            color: cardTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          insight.transactionCategory ?? '',
                          style: TextStyle(
                            color: colours.textMuted,
                            fontSize: 11,
                          ),
                        ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'R${insight.transactionAmount!.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: cardTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${insight.transactionDate!.day}/${insight.transactionDate!.month}/${insight.transactionDate!.year}',
                              style: TextStyle(
                                color: mutedCardText,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dashboardTextColor = isDark ? colours.secondary:colours.background;

    final (label, bg, fg) = switch (severity) {
      InsightSeverity.tip => (
        'Tip',
        dashboardTextColor.withValues(alpha: 0.15),
        dashboardTextColor,
      ),

      InsightSeverity.warning => (
        'Warning',
        dashboardTextColor.withValues(alpha: 0.2),
        dashboardTextColor,
      ),

      InsightSeverity.alert => (
        'Alert',
        colours.error.withValues(alpha: 0.22),
        dashboardTextColor,
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
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = isDark
        ? colours.secondary.withValues(alpha: 0.15)
        : colours.secondary;
    final iconColor = isDark ? colours.textPrimary : colours.background;

    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 28,
        height: 28,

        decoration: BoxDecoration(
          color: buttonColor,

          borderRadius: BorderRadius.circular(8),
        ),

        child: Icon(icon, size: 18, color: iconColor),
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
  final String? transactionDescription;
  final String? transactionCategory;
  final double? transactionAmount;
  final DateTime? transactionDate;

  const BudgetInsight({
    required this.title,
    required this.body,
    required this.icon,
    required this.accentColor,
    this.severity = InsightSeverity.tip,
    this.transactionDescription,
    this.transactionCategory,
    this.transactionAmount,
    this.transactionDate,
  });
}
