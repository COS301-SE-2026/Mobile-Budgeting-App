import 'package:budgetit/bsg/preview_support.dart';
import 'package:budgetit/shared/widgets/fab.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'FAB', type: FAB, path: '[Widgets]')
Widget fabUseCase(BuildContext context) {
  return appPreview(
    database: true,
    child: Scaffold(
      backgroundColor: context.colours.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Floating Action Button', style: context.colours.h2),
            const SizedBox(height: 28),
            Text(
              'The fixed-size action stays consistent across phone and '
              'desktop previews. Tap it to open the transaction menu.',
              style: context.colours.b1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const FAB(),
          ],
        ),
      ),
    ),
  );
}
