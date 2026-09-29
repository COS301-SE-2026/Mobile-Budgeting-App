import 'package:flutter/material.dart';

class EqualHeightGrid extends StatelessWidget {
  const EqualHeightGrid({
    super.key,
    required this.children,
    required this.columns,
    this.spacing = 20,
    this.runSpacing = 20,
  });

  final List<Widget> children;
  final int columns;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    final cols = columns < 1 ? 1 : columns;
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += cols) {
      final end = (i + cols) > children.length ? children.length : i + cols;
      final slice = children.sublist(i, end);
      final cells = <Widget>[];
      for (var c = 0; c < cols; c++) {
        if (c > 0) cells.add(SizedBox(width: spacing));
        cells.add(Expanded(
          child: c < slice.length ? slice[c] : const SizedBox.shrink(),
        ));
      }

      rows.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: cells,
        ),
      ));

      if (end < children.length) rows.add(SizedBox(height: runSpacing));
    }

    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }
}