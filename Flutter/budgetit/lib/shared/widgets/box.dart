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
        transactionId: widget.transactionId,
        transactionType: widget.transactionType,
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

  
  String _formatAmount(double amount) {
    final fixed = amount.abs().toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = parts.first;
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      final remaining = whole.length - i;
      buffer.write(whole[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
    }
    return '${buffer.toString()}.${parts.last}';
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? colours.secondary : colours.primary;
    final cardFg = isDark ? colours.background : colours.cardText;
    final incomeColor = isDark ? colours.background : colours.greenAccents;

    return GestureDetector(
      onTap: _openEditDialog,

      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: Stack(
        children: [
          Container(
            //adding our custom card decor
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            alignment: Alignment.center,
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
              color: cardColor,
              border: Border.all(color: Colors.black, width: 4.0),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: context.colours.secondary,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Icon(
                    _icon,
                    color: context.colours.background,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: context.colours.budgetheader.copyWith(
                          color: context.colours.cardText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_category.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          _category + (_date.isNotEmpty ? ' - $_date' : ''),
                          style: context.colours.b5.copyWith(
                            color: context.colours.cardText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  _isExpense
                      ? '- R${_amount.toStringAsFixed(2)}'
                      : 'R${_amount.toStringAsFixed(2)}',
                  style: context.colours.b4.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
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
