import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

class Intro {}

@widgetbook.UseCase(name: 'Intro', type: Intro, path: '[Brand Style Guide]')
Widget introUseCase(BuildContext context) => const _IntroPage();

class _IntroPage extends StatelessWidget {
  const _IntroPage();

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 700;

    return Scaffold(
      backgroundColor: colours.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            isCompact ? 24 : 72,
            isCompact ? 40 : 72,
            isCompact ? 24 : 72,
            40,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BUDGET IT DESIGN SYSTEM',
                    style: colours.h4.copyWith(
                      color: colours.textPrimary,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome to our\nbrand style guide',
                    style: colours.bigDisplay.copyWith(
                      fontSize: isCompact ? 40 : 64,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Our design system brings consistency, clarity, and '
                    'confidence to every product experience. Explore the '
                    'building blocks that power BudgetIt.',
                    style: colours.b1.copyWith(
                      fontSize: isCompact ? 14 : 18,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colours.primary.withValues(alpha: 0.08),
                      border: Border.all(
                        color: colours.textPrimary.withValues(alpha: 0.2),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Use Addons to switch between Light and Dark themes. '
                      'Every colour on this page comes from the same theme '
                      'used by the BudgetIt app.',
                      style: colours.b1.copyWith(height: 1.5),
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
