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
    return TextField(
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      cursorColor: context.colours.whiteAccents,
      style: context.colours.b1.copyWith(
        color: context.colours.whiteAccents,
      ),
      decoration: InputDecoration(
        hintText: _isFocused ? null : widget.hintText,
        hintStyle: context.colours.searchtext,
        prefixIcon: _isFocused
            ? null
            : Icon(Icons.search, color: context.colours.textMuted),
        filled: true,
        fillColor: context.colours.searchBar,
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 8,
        ),
      ),
    );
  }
}
