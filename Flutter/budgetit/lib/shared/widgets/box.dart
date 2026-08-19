import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/database/schema.dart';
import 'package:flutter/material.dart';
import 'edit_transaction_dialogue.dart';

class MyBox extends StatefulWidget {
  final String? transactionId;
  final String? text;
  final IconData? icon;
  final double? amount;
  final String? category;
  final String? date;
  // forgot to add the category to our current ui so here it is 
  final List<String> categories;
  final TransactionType? transactionType;
  final bool isExpense;
  final void Function(
    String name,
    double amount,
    IconData icon,
    String category,
  )?
  onEdited;
  final void Function()? onDelete;

  const MyBox({
    super.key,
    this.transactionId,
    this.text = '',
    this.icon,
    this.amount = 0,
    this.category = 'nothing',
    this.categories = const [],
    this.transactionType,
    this.onEdited,
    this.onDelete,
    this.date = '',
    this.isExpense = false,
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
  late String _date;
  late bool _isExpense;

  @override
  void initState() {
    super.initState();
    _name = widget.text ?? '';
    _amount = widget.amount ?? 0.0;
    _icon = widget.icon ?? Icons.attach_money;
    _category =
        widget.category ??
        (widget.categories.isNotEmpty ? widget.categories.first : '');
    _date = widget.date ?? '';
    _isExpense = widget.isExpense;
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
        transactionId : widget.transactionId,
        transactionType : widget.transactionType,
        onSave: (newName, newAmount, newIcon, newCategory) {
          setState(() {
            _name = newName;
            _amount = newAmount;
            _icon = newIcon;
            _category = newCategory;
            _date = widget.date ?? '';
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
      child: Stack(
        children: [
          Container(//adding our custom card decor
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            alignment : Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: context.colours.background,
              boxShadow: [
                BoxShadow(offset: const Offset(6, 6), color: Colors.black),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,

            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: context.colours.primary,

              border: Border.all(color: Colors.black, width: 4.0),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(
                  _icon,
                  color: _isPressed
                      ? context.colours.background
                      : _isExpense
                      ? context.colours.error
                      : context.colours.greenAccents,
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
                        style: context.colours.budgetheader.copyWith(
                          color: context.colours.cardText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_category.isNotEmpty)
                        Text(
                          _category + (_date.isNotEmpty ? ' - $_date' : ''),
                          style: context.colours.b5.copyWith(
                            color: context.colours.cardText,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                    ],
                  ),
                ),
                Text(
                  _isExpense
                      ? '- R${_amount.toStringAsFixed(2)}'
                      : 'R${_amount.toStringAsFixed(2)}',
                  style: context.colours.b4.copyWith(
                    color: _isExpense
                        ? _isPressed
                              ? context.colours.background
                              : context.colours.error
                        : _isPressed
                        ? context.colours.background
                        : context.colours.greenAccents,
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
