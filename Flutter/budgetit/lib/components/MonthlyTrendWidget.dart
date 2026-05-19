import 'package:flutter/material.dart';

class MonthlyTrendWidget extends StatefulWidget {
  final List<MonthData> months;

  const MonthlyTrendWidget({
    super.key,
    required this.months,
  });

  @override
  State<MonthlyTrendWidget> createState() => _MonthlyTrendWidgetState();
}

class _MonthlyTrendWidgetState extends State<MonthlyTrendWidget> {

  static const Color darkGreen = Color(0xFF04240C);
  static const Color cream = Color(0xFFDDD6AE);
  static const Color gold = Color(0xFFC2B280);

  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {

    final maxSpend =
        widget.months.map((m) => m.spent).reduce((a, b) => a > b ? a : b);

    final selected = _selectedIndex != null
        ? widget.months[_selectedIndex!]
        : widget.months.last;

    final trend = _getTrend();

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            const Text(
              'Monthly Trend',

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: cream,
              ),
            ),

            _TrendPill(trend: trend),

          ],
        ),

        const SizedBox(height: 16),

        Container(

          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(

            color: darkGreen,

            borderRadius: BorderRadius.circular(16),

            border: Border.all(
              color: const Color(0x22DDD6AE),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(

            children: [

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),

                child: _SelectedDetail(
                  key: ValueKey(selected.month),
                  data: selected,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(

                height: 100,

                child: Row(

                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: List.generate(widget.months.length, (i) {

                    final m = widget.months[i];

                    final isSelected =
                        _selectedIndex == i ||
                        (_selectedIndex == null &&
                            i == widget.months.length - 1);

                    final barHeight = (m.spent / maxSpend) * 80;

                    return Expanded(

                      child: GestureDetector(

                        onTap: () => setState(() {
                          _selectedIndex =
                              _selectedIndex == i ? null : i;
                        }),

                        child: _Bar(
                          data: m,
                          height: barHeight,
                          isSelected: isSelected,
                          maxHeight: 80,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 12),

              Row(

                mainAxisAlignment: MainAxisAlignment.center,

                children: const [

                  _LegendDot(
                    color: gold,
                    label: 'Spent',
                  ),

                  SizedBox(width: 16),

                  _LegendDot(
                    color: Color(0x22DDD6AE),
                    label: 'Remaining',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _TrendResult _getTrend() {

    if (widget.months.length < 2) {

      return const _TrendResult(
        label: 'No data',
        color: Colors.grey,
        icon: Icons.remove,
      );
    }

    final last = widget.months.last.spent;
    final prev = widget.months[widget.months.length - 2].spent;

    final diff = last - prev;

    final pct =
        ((diff / prev) * 100).abs().toStringAsFixed(0);

    if (diff < 0) {

      return _TrendResult(
        label: '$pct% less than last month',
        color: gold,
        icon: Icons.trending_down_rounded,
      );
    }

    else if (diff > 0) {

      return const _TrendResult(
        label: 'More than last month',
        color: Colors.redAccent,
        icon: Icons.trending_up_rounded,
      );
    }

    return const _TrendResult(
      label: 'Same as last month',
      color: Colors.grey,
      icon: Icons.trending_flat_rounded,
    );
  }
}

class _SelectedDetail extends StatelessWidget {

  static const Color cream = Color(0xFFDDD6AE);
  static const Color gold = Color(0xFFC2B280);

  final MonthData data;

  const _SelectedDetail({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {

    final remaining = data.income - data.spent;

    final pct =
        ((data.spent / data.income) * 100).round();

    return Row(

      children: [

        Expanded(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                data.month,

                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0x99DDD6AE),
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'R${_fmt(data.spent)} spent',

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: cream,
                ),
              ),

              Text(
                'of R${_fmt(data.income)} income',

                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0x99DDD6AE),
                ),
              ),
            ],
          ),
        ),

        Column(

          crossAxisAlignment: CrossAxisAlignment.end,

          children: [

            Text(
              'R${_fmt(remaining)}',

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: remaining >= 0
                    ? gold
                    : Colors.redAccent,
              ),
            ),

            const Text(
              'remaining',

              style: TextStyle(
                fontSize: 11,
                color: Color(0x99DDD6AE),
              ),
            ),

            const SizedBox(height: 6),

            Container(

              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),

              decoration: BoxDecoration(
                color: const Color(0x22C2B280),
                borderRadius: BorderRadius.circular(8),
              ),

              child: Text(
                '$pct% used',

                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: gold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _fmt(double v) =>
      v.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (m) => '${m[1]} ',
      );
}

class _Bar extends StatelessWidget {

  static const Color gold = Color(0xFFC2B280);

  final MonthData data;
  final double height;
  final bool isSelected;
  final double maxHeight;

  const _Bar({
    required this.data,
    required this.height,
    required this.isSelected,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.symmetric(horizontal: 4),

      child: Column(

        mainAxisAlignment: MainAxisAlignment.end,

        children: [

          Stack(

            alignment: Alignment.bottomCenter,

            children: [

              Container(

                width: double.infinity,
                height: maxHeight,

                decoration: BoxDecoration(
                  color: const Color(0x22DDD6AE),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              AnimatedContainer(

                duration: const Duration(milliseconds: 400),

                curve: Curves.easeOutCubic,

                width: double.infinity,

                height: height.clamp(4, maxHeight),

                decoration: BoxDecoration(
                  color: isSelected
                      ? gold
                      : const Color(0x88C2B280),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            data.shortMonth,

            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected
                  ? FontWeight.w700
                  : FontWeight.w400,
              color: isSelected
                  ? const Color(0xFFDDD6AE)
                  : const Color(0x99DDD6AE),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendPill extends StatelessWidget {

  final _TrendResult trend;

  const _TrendPill({
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: trend.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(

        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(
            trend.icon,
            size: 14,
            color: trend.color,
          ),

          const SizedBox(width: 4),

          Text(
            trend.label,

            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: trend.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {

  final Color color;
  final String label;

  const _LegendDot({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {

    return Row(

      children: [

        Container(
          width: 8,
          height: 8,

          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 5),

        const Text(
          'Spent',

          style: TextStyle(
            fontSize: 11,
            color: Color(0x99DDD6AE),
          ),
        ),
      ],
    );
  }
}

class MonthData {

  final String month;
  final String shortMonth;
  final double income;
  final double spent;

  const MonthData({
    required this.month,
    required this.shortMonth,
    required this.income,
    required this.spent,
  });
}

class _TrendResult {

  final String label;
  final Color color;
  final IconData icon;

  const _TrendResult({
    required this.label,
    required this.color,
    required this.icon,
  });
}