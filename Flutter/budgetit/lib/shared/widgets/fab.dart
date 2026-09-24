import 'package:budgetit/shared/widgets/add_transaction_dialog.dart';
import 'package:budgetit/shared/widgets/transac_menu.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/import/import_screen.dart';
import 'package:provider/provider.dart';
import 'package:budgetit/database/app_database.dart';

class FAB extends StatefulWidget {
  final VoidCallback? onTransactionAdded;

  const FAB({super.key, this.onTransactionAdded});

  @override
  State<FAB> createState() => _FABState();
}

class _FABState extends State<FAB> {
  static const double _buttonSize = 58;
  static const double _iconSize = 30;

  bool _pressed = false;

  void _navigateToImport() {
    print('Debugg: _navigsteToImport called');
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImportScreen(db: context.read<AppDatabase>()),
      ),
    );
  }

  void _showMenu() {
    final outerContext = context;

    showDialog<void>(
      context: outerContext,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: FABMenu(
          onAddTransaction: () {
            Navigator.of(dialogContext).pop();
            showDialog<void>(
              context: outerContext,
              builder: (_) =>
                  AddTransactionDialog(onAdded: widget.onTransactionAdded),
            );
          },
          onImportStatement: _navigateToImport,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: _showMenu,
      child: Container(
        width: _buttonSize,
        height: _buttonSize,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(offset: const Offset(6, 6), color: Colors.black),
          ],
          border: Border.all(color: Colors.black, width: 4.0),
          color: isDark
              ? context.colours.blendedprimary
              : _pressed
              ? context.colours.informational
              : context.colours.secondary,
          shape: BoxShape.rectangle,
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: isDark
                ? context.colours.secondary
                : _pressed
                ? context.colours.secondary
                : context.colours.background,
            size: _iconSize,
          ),
        ),
      ),
    );
  }
}
