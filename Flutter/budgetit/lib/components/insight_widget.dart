import 'package:flutter/material.dart';

class InsightWidget extends StatefulWidget {

  final List<BudgetInsight> insights;

  const InsightWidget({
    super.key,
    required this.insights,
  });

  @override
  State<InsightWidget> createState() => _InsightWidgetState();
}

class _InsightWidgetState extends State<InsightWidget>
    with SingleTickerProviderStateMixin {

  static const Color darkGreen = Color(0xFF04240C);
  static const Color cream = Color(0xFFDDD6AE);
  static const Color gold = Color(0xFFC2B280);
  static const Color teal = Color(0xFF137E84);

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

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

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

            const Text(
              'Insight',

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: cream,
              ),
            ),

            if (widget.insights.length > 1)

              Row(

                children: [

                  Text(
                    '${_current + 1}/${widget.insights.length}',

                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0x99DDD6AE),
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

  static const Color darkGreen = Color(0xFF04240C);
  static const Color cream = Color(0xFFDDD6AE);

  final BudgetInsight insight;

  const _InsightCard({
    required this.insight,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: darkGreen,

        borderRadius: BorderRadius.circular(16),

        border: Border(
          left: BorderSide(
            color: insight.accentColor,
            width: 3,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
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
              color: insight.accentColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(
              insight.icon,
              size: 18,
              color: insight.accentColor,
            ),
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

                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: cream,
                        ),
                      ),
                    ),

                    _SeverityBadge(
                      severity: insight.severity,
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  insight.body,

                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0x99DDD6AE),
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

  static const Color cream = Color(0xFFDDD6AE);
  static const Color teal = Color(0xFF137E84);

  final InsightSeverity severity;

  const _SeverityBadge({
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {

    final (label, bg, fg) = switch (severity) {

      InsightSeverity.tip => (
        'Tip',
        const Color(0x22137E84),
        teal,
      ),

      InsightSeverity.warning => (
        'Warning',
        const Color(0x33DDD6AE),
        cream,
      ),

      InsightSeverity.alert => (
        'Alert',
        const Color(0x44B00020),
        Colors.redAccent,
      ),
    };

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),

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

  static const Color cream = Color(0xFFDDD6AE);
  static const Color teal = Color(0xFF137E84);

  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        width: 28,
        height: 28,

        decoration: BoxDecoration(
          color: const Color(0x22137E84),
          borderRadius: BorderRadius.circular(8),
        ),

        child: Icon(
          icon,
          size: 18,
          color: cream,
        ),
      ),
    );
  }
}

enum InsightSeverity {
  tip,
  warning,
  alert,
}

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