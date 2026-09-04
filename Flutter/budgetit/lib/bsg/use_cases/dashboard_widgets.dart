import 'package:budgetit/bsg/preview_support.dart';
import 'package:budgetit/shared/widgets/quick_stats_widgets.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;


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
