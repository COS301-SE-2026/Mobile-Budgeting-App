import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
//WEEE DONEEE
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
          border: Border.all(
            color: Colors.black,
            width: 4,
          ),
          color: isActive ? context.colours.informational : context.colours.category,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text ?? '',
              textAlign: TextAlign.center,
              style: context.colours.categorytext,
            ),
          ],
        ),
      ),
    );
  }
}
