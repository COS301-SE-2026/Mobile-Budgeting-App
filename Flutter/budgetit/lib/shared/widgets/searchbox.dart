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
      decoration: InputDecoration(
        hintText: _isFocused ? null : widget.hintText,
        prefixIcon: _isFocused
            ? null
            : Icon(Icons.search, color: MyColours().background),
        filled: true,
        fillColor: MyColours().secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}