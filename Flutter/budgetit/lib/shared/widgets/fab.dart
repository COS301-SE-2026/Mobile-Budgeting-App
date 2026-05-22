import 'package:budgetit/shared/widgets/add_transaction_dialog.dart';
import 'package:budgetit/shared/widgets/transac_menu.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class FAB extends StatefulWidget {
  final VoidCallback? onTransactionAdded;

  const FAB({super.key, this.onTransactionAdded});

  @override
  State<FAB> createState() => _FABState();
}

class _FABState extends State<FAB> {
  bool _pressed = false;

  void _showMenu() {
    // Capture context before async gap — FAB stays mounted while sheet is open.
    final outerContext = context;

    showModalBottomSheet<void>(
      context: outerContext,
      backgroundColor: MyColours().secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => FABMenu(
        onAddTransaction: () {
          Navigator.of(sheetContext).pop();
          showDialog<void>(
            context: outerContext,
            builder: (_) => AddTransactionDialog(
              onAdded: widget.onTransactionAdded,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: _showMenu,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _pressed ? MyColours().tertiary : MyColours().secondary,
          shape: BoxShape.rectangle,
        ),
        child: Align(
          alignment: const Alignment(-0.1, -0.1),
          child: Icon(
            Icons.add,
            color: _pressed ? MyColours().secondary : MyColours().background,
            size: MediaQuery.of(context).size.width * 0.08,
          ),
        ),
      ),
    );
  }
}
