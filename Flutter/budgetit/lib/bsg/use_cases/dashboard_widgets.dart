import 'package:budgetit/bsg/preview_support.dart';
import 'package:budgetit/shared/widgets/bottom_nav.dart';
import 'package:budgetit/shared/widgets/monthly_trend_widget.dart';
import 'package:budgetit/shared/widgets/quick_stats_widgets.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Bottom Navigation',
  type: BottomNav,
  path: '[Widgets]',
)
Widget bottomNavUseCase(BuildContext context) => Scaffold(
  backgroundColor: context.colours.background,
  body: const Center(child: Text('Dashboard content')),
  bottomNavigationBar: const SafeArea(child: BottomNav()),
);

@widgetbook.UseCase(
  name: 'Quick Stats',
  type: QuickStatsWidget,
  path: '[Widgets]',
)
Widget quickStatsUseCase(BuildContext context) => appPreview(
  child: Scaffold(
    backgroundColor: context.colours.background,
    body: const Center(child: SingleChildScrollView(child: QuickStatsWidget())),
  ),
);

@widgetbook.UseCase(
  name: 'Monthly Trend',
  type: MonthlyTrendWidget,
  path: '[Widgets]',
)
Widget monthlyTrendUseCase(BuildContext context) => appPreview(
  child: Scaffold(
    backgroundColor: context.colours.background,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: MonthlyTrendWidget(
            selectedDate: DateTime(2026, 9, 3),
            months: const [
              MonthData(
                month: 'July 2026',
                shortMonth: 'Jul',
                income: 12500,
                spent: 3200,
              ),
              MonthData(
                month: 'August 2026',
                shortMonth: 'Aug',
                income: 12500,
                spent: 4100,
              ),
              MonthData(
                month: 'September 2026',
                shortMonth: 'Sep',
                income: 12500,
                spent: 1850,
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);
