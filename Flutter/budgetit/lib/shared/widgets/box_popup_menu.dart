import 'package:flutter/material.dart';
import 'package:budgetit/utils/app_colour.dart';

enum BoxMenuAction { edit, delete, details }

class BoxPopupMenu extends StatelessWidget {
  const BoxPopupMenu({
    super.key,
    required this.onSelected,
  });

  final void Function(BoxMenuAction action) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BoxMenuAction>(
      onSelected: onSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: MyColours().secondary,
      elevation: 6,
      icon: Icon(
        Icons.more_vert,
        color: MyColours().background,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: BoxMenuAction.details,
          child: _MenuRow(
            icon: Icons.info_outline,
            label: 'View Details',
          ),
        ),
        PopupMenuItem(
          value: BoxMenuAction.edit,
          child: _MenuRow(
            icon: Icons.edit_outlined,
            label: 'Edit',
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: BoxMenuAction.delete,
          child: _MenuRow(
            icon: Icons.delete_outline,
            label: 'Delete',
            isDestructive: true,
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.redAccent : MyColours().textPrimary;
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }
}
