import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class FABMenu extends StatefulWidget {
  final VoidCallback? onAddTransaction;
  final VoidCallback? onImportStatement;

  const FABMenu({super.key, this.onAddTransaction, this.onImportStatement});

  @override
  State<FABMenu> createState() => _FABMenuState();
}

class _FABMenuState extends State<FABMenu> {
  bool isHover1 = false;
  bool isHover2 = false;

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = isDark ? colours.blendedprimary : colours.secondary;
    final textColor = isDark ? colours.cardText : colours.background;
    final hoverColor = isDark ? colours.background : colours.primary;
    final hoverTextColor = colours.cardText;

    return Container(
      color: colours.background,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MenuButton(
            label: 'Add Transaction',
            icon: Icons.add,
            isHovered: isHover1,
            color: buttonColor,
            hoverColor: hoverColor,
            textColor: textColor,
            hoverTextColor: hoverTextColor,
            onHover: (isHovering) => setState(() => isHover1 = isHovering),
            onPressed: widget.onAddTransaction,
          ),
          const SizedBox(height: 16),
          _MenuButton(
            label: 'Import PDF/CSV',
            icon: Icons.upload_file_outlined,
            isHovered: isHover2,
            color: buttonColor,
            hoverColor: hoverColor,
            textColor: textColor,
            hoverTextColor: hoverTextColor,
            onHover: (isHovering) => setState(() => isHover2 = isHovering),
            onPressed: widget.onImportStatement,
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.icon,
    required this.isHovered,
    required this.color,
    required this.hoverColor,
    required this.textColor,
    required this.hoverTextColor,
    required this.onHover,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool isHovered;
  final Color color;
  final Color hoverColor;
  final Color textColor;
  final Color hoverTextColor;
  final ValueChanged<bool> onHover;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = isHovered ? hoverTextColor : textColor;

    return Padding(
      padding: const EdgeInsets.only(right: 6, bottom: 6),
      child: InkWell(
        onTap: onPressed,
        onHover: onHover,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: isHovered ? hoverColor : color,
            border: Border.all(color: Colors.black, width: 4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(6, 6),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: effectiveTextColor, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: context.colours.b1.copyWith(
                  color: effectiveTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
