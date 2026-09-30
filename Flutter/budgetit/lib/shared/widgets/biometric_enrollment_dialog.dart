import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

Future<bool> showBiometricEnrollmentDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (dialogContext) {
      final colours = dialogContext.colours;
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      final surfaceColor = isDark ? colours.blendedprimary : colours.background;
      final textColor = isDark ? colours.secondary : colours.textPrimary;
      final primaryButtonColor = isDark ? colours.secondary : colours.primary;
      final primaryButtonTextColor = isDark
          ? colours.background
          : colours.cardText;

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
                border: Border.all(color: Colors.black, width: 4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: colours.informational,
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      color: Colors.black,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'ENABLE BIOMETRIC LOCK?',
                    textAlign: TextAlign.center,
                    style: colours.h2.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Use your fingerprint or face authentication to protect '
                    'Budget IT when you return to the app.',
                    textAlign: TextAlign.center,
                    style: colours.b1.copyWith(
                      color: textColor.withValues(alpha: 0.8),
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
                            side: const BorderSide(
                              color: Colors.black,
                              width: 3,
                            ),
                            shape: const RoundedRectangleBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: colours.b1.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('NOT NOW'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryButtonColor,
                            foregroundColor: primaryButtonTextColor,
                            side: const BorderSide(
                              color: Colors.black,
                              width: 3,
                            ),
                            shape: const RoundedRectangleBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: colours.b1.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('ENABLE'),
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

  return result ?? false;
}
