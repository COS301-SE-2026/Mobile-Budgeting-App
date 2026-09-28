import 'package:budgetit/auth/providers/auth_provider.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BiometricLockScreen extends StatelessWidget {
  const BiometricLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final colours = context.colours;
    return Scaffold(
      backgroundColor: colours.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: colours.primary,
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 64, color: colours.cardText),
                  const SizedBox(height: 20),
                  Text(
                    'BUDGET IT IS LOCKED',
                    textAlign: TextAlign.center,
                    style: colours.h2.copyWith(color: colours.cardText),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Verify your Android biometrics to continue.',
                    textAlign: TextAlign.center,
                    style: colours.b1.copyWith(color: colours.cardText),
                  ),
                  if (auth.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      auth.errorMessage!,
                      textAlign: TextAlign.center,
                      style: colours.b1.copyWith(color: colours.error),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: auth.isLoading ? null : auth.unlock,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Unlock'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colours.cardText,
                      foregroundColor: colours.primary,
                      textStyle: colours.b1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 3),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: auth.isLoading ? null : auth.usePasswordInstead,
                    style: TextButton.styleFrom(
                      foregroundColor: colours.cardText,
                      textStyle: colours.b1.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    child: const Text('Use password instead'),
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
