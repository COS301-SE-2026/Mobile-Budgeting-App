import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

/// The shared dark-mode action styles used by application dialogs.
class AppDialogStyle {
  const AppDialogStyle._();

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color surface(BuildContext context) => context.colours.blendedprimary;

  static Color foreground(BuildContext context) => context.colours.secondary;

  static ButtonStyle cancel(BuildContext context) => OutlinedButton.styleFrom(
    backgroundColor: context.colours.background,
    foregroundColor: foreground(context),
    side: const BorderSide(color: Colors.black, width: 3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    textStyle: context.colours.b1.copyWith(fontWeight: FontWeight.bold),
  );

  static ButtonStyle primary(BuildContext context) => ElevatedButton.styleFrom(
    backgroundColor: foreground(context),
    foregroundColor: context.colours.background,
    side: const BorderSide(color: Colors.black, width: 3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    textStyle: context.colours.b1.copyWith(fontWeight: FontWeight.bold),
  );
}
