import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'edit_transaction_dialogue.dart';

class MyBox extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final double? amount;
  final String? category;
  final List<String> categories;
  final void Function(String name, double amount, IconData icon, String category)? onEdited;
  final void Function()? onDelete;

  const MyBox({
    super.key,
    this.text = '',
    this.icon,
    this.amount,
    this.category,
    this.categories = const [],
    this.onEdited,
    this.onDelete,
  });

  @override
  State<MyBox> createState() => _MyBoxState();
}

class _MyBoxState extends State<MyBox> {
  bool _isPressed = false;
  late String _name;
  late double _amount;
  late IconData _icon;
  late String _category;

  @override
  void initState() {
    super.initState();
    _name = widget.text ?? '';
    _amount = widget.amount ?? 0.0;
    _icon = widget.icon ?? Icons.attach_money;
    _category = widget.category ??
        (widget.categories.isNotEmpty ? widget.categories.first : '');
  }

  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (_) => EditTransactionDialog(
        name: _name,
        amount: _amount,
        icon: _icon,
        category: _category,
        categories: widget.categories,
        onSave: (newName, newAmount, newIcon, newCategory) {
          setState(() {
            _name = newName;
            _amount = newAmount;
            _icon = newIcon;
            _category = newCategory;
          });
          widget.onEdited?.call(newName, newAmount, newIcon, newCategory);
        },
        onDelete: widget.onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openEditDialog,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * 0.9,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: MyColours().primary,
          border: Border.all(
            color: MyColours().secondary,
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(
              _icon,
              color: _isPressed ? MyColours().background : MyColours().textPrimary,
              size: MediaQuery.of(context).size.width * 0.04,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _name,
                    style: TextStyle(
                      fontSize: MyColours().bodyFontSize,
                      color: _isPressed
                          ? MyColours().background
                          : MyColours().textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_category.isNotEmpty)
                    Text(
                      _category,
                      style: TextStyle(
                        fontSize: MyColours().bodyFontSize * 0.85,
                        color: _isPressed
                            ? MyColours().background
                            : MyColours().secondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Text(
              'R${_amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: MyColours().bodyFontSize,
                color: _isPressed ? MyColours().background : MyColours().secondary,
             //   fontWeight: FontWeight,
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}