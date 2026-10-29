import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

/// Prompts for data-sharing consent before sending a registration request.
Future<bool> showDataConsentDialog(BuildContext context) async {
  final accepted = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (dialogContext) {
      final colours = dialogContext.colours;
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      final surfaceColor = isDark ? colours.blendedprimary : colours.background;
      final textColor = isDark ? colours.secondary : colours.textPrimary;
      final acceptColor = isDark ? colours.secondary : colours.primary;
      final acceptTextColor = isDark ? colours.background : colours.cardText;

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: const RoundedRectangleBorder(),
        child: Stack(
          children: [
            Positioned.fill(
              child: Transform.translate(
                offset: const Offset(6, 6),
                child: Container(color: Colors.black),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border.all(width: 4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: colours.informational,
                      border: Border.all(width: 3),
                    ),
                    child: const Icon(
                      Icons.privacy_tip_outlined,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'DATA-SHARING CONSENT',
                    textAlign: TextAlign.center,
                    style: colours.h2.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Do you consent to your data being provided to DevOops?',
                    textAlign: TextAlign.center,
                    style: colours.b1.copyWith(
                      color: textColor.withValues(alpha: 0.9),
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'This prompt appears when you submit registration. '
                    'Your choice is not saved by this screen.',
                    textAlign: TextAlign.center,
                    style: colours.b2.copyWith(
                      color: textColor.withValues(alpha: 0.7),
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textColor,
                            side: const BorderSide(width: 3),
                            shape: const RoundedRectangleBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: colours.b1.copyWith(
                              color: textColor,
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('DECLINE'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: acceptColor,
                            foregroundColor: acceptTextColor,
                            side: const BorderSide(width: 3),
                            shape: const RoundedRectangleBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: colours.b1.copyWith(
                              color: acceptTextColor,
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('I CONSENT'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );

  return accepted ?? false;
}
