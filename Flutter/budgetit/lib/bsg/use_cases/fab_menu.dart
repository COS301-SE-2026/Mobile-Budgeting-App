import 'package:budgetit/shared/widgets/transac_menu.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'FAB Menu', type: FABMenu, path: '[Widgets]')
Widget fabMenuUseCase(BuildContext context) {
  return Scaffold(
    backgroundColor: context.colours.background,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            children: [
              Text('Pick your next move', style: context.colours.h2),
              const SizedBox(height: 28),
              Text(
                'The FAB pops this menu open when it is time to add a '
                'transaction or bring in a statement.',
                style: context.colours.b1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const FABMenu(),
            ],
          ),
        ),
      ),
    ),
  );
}
