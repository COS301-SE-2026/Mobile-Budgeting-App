import 'package:budgetit/shared/widgets/action_button.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Action Button',
  type: ActionButton,
  path: '[Widgets]',
)
Widget addButton(BuildContext context) {
  return Scaffold(
    backgroundColor: context.colours.background,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lights, camera, action!', style: context.colours.h2),
            const SizedBox(height: 28),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Text(
                'A compact shortcut that pairs a familiar icon with a clear '
                'label, helping users reach common money moves quickly.',
                style: context.colours.b1,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            const ActionButton(label: 'Add', icon: Icons.add_rounded),
          ],
        ),
      ),
    ),
  );
}
