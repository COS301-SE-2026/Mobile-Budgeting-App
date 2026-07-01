import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class MyBadge extends StatefulWidget {
  final String? text;
  final bool isSelected;
  final VoidCallback? onTap;

  const MyBadge({
    super.key,
    this.text = '',
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<MyBadge> createState() => _MyBadgeState();
}

class _MyBadgeState extends State<MyBadge> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isSelected || _isPressed;
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.25,
          minHeight: MediaQuery.of(context).size.height * 0.04,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: MyColours().secondary, width: 1.5),
          color: isActive ? MyColours().secondary : MyColours().background,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MyColours().bodyFontSize,
                color: isActive
                    ? MyColours().background
                    : MyColours().textPrimary.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
