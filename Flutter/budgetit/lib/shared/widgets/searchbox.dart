import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const SearchBox({super.key, required this.hintText, required this.onChanged});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchBackground = Color.alphaBlend(
      context.colours.cardText.withValues(alpha: 0.13),
      context.colours.primary.withValues(alpha: 1),
    );
    final searchForeground = context.colours.cardText;

    return TextField(
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      cursorColor: searchForeground,
      style: context.colours.b1.copyWith(color: searchForeground),
      decoration: InputDecoration(
        hintText: _isFocused ? null : widget.hintText,
        hintStyle: TextStyle(color: searchForeground),
        prefixIcon: _isFocused
            ? null
            : Icon(Icons.search, color: searchForeground),
        filled: true,
        fillColor: searchBackground,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.black, width: 4),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.black, width: 4),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.black, width: 4),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      ),
    );
  }
}
