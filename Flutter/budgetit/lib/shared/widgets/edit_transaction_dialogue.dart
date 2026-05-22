import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:budgetit/utils/app_colour.dart';

class EditTransactionDialog extends StatefulWidget {
  final String name;
  final double amount;
  final IconData icon;
  final String category;
  final List<String> categories;
  final void Function(String name, double amount, IconData icon, String category) onSave;
  final void Function()? onDelete;

  const EditTransactionDialog({
    super.key,
    required this.name,
    required this.amount,
    required this.icon,
    required this.category,
    required this.categories,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<EditTransactionDialog> createState() => _EditTransactionDialogState();
}

class _EditTransactionDialogState extends State<EditTransactionDialog> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late String _selectedCategory;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _amountController =
        TextEditingController(text: widget.amount.toStringAsFixed(2));
    _selectedCategory = widget.categories.contains(widget.category)
        ? widget.category
        : (widget.categories.isNotEmpty ? widget.categories.first : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newAmount = double.tryParse(_amountController.text) ?? widget.amount;
      widget.onSave(
        _nameController.text.trim(),
        newAmount,
        widget.icon, 
        _selectedCategory,
      );
      Navigator.of(context).pop();
    }
  }

  void _confirmDelete() {
    Navigator.of(context).pop();
    widget.onDelete?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();

    return Dialog(
      backgroundColor: colours.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colours.secondary, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              Row(
                children: [
                  Icon(widget.icon, color: colours.secondary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Edit Transaction',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colours.textPrimary,
                      ),
                    ),
                  ),
                  if (widget.onDelete != null)
                    IconButton(
                      onPressed: _confirmDelete,
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent, size: 20),
                      tooltip: 'Delete',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: colours.secondary.withValues(alpha: 0.35), height: 1),
              const SizedBox(height: 16),

              _FieldLabel('Transaction Name', colours),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: colours.cardText, fontSize: 14),
                decoration: _inputDecoration('e.g. Grocery run', colours),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),

             
              _FieldLabel('Amount (R)', colours),
              const SizedBox(height: 6),
              TextFormField(
                controller: _amountController,
                style: TextStyle(color: colours.cardText, fontSize: 14),
                decoration: _inputDecoration('0.00', colours),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Amount is required';
                  if (double.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

            
              if (widget.categories.isNotEmpty) ...[
                _FieldLabel('Category', colours),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: colours.primary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colours.secondary, width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      dropdownColor: colours.navBarColor,
                      style: TextStyle(color: colours.cardText, fontSize: 14),
                      icon: Icon(Icons.keyboard_arrow_down, color: colours.cardText),
                      items: widget.categories
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel',
                        style: TextStyle(color: colours.secondary)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colours.secondary,
                      foregroundColor: colours.background,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Save',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _FieldLabel(String text, MyColours colours) => Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colours.secondary,
      ),
    );

InputDecoration _inputDecoration(String hint, MyColours colours) =>
    InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: MyColours().cardText.withValues(alpha: 0.5)),
      filled: true,
      fillColor: colours.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colours.secondary, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colours.secondary, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colours.secondary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );