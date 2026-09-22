import 'package:pdfrx/pdfrx.dart';

class PdfLayoutCell {
  final String text;
  final double left;
  final double right;
  final bool columnBreakBefore;

  const PdfLayoutCell(
    this.text,
    this.left,
    this.right, {
    this.columnBreakBefore = false,
  });

  double get center => (left + right) / 2;
}

class PdfLayoutLine {
  final int pageNumber;
  final double top;
  final double height;
  final List<PdfLayoutCell> cells;

  const PdfLayoutLine({
    required this.pageNumber,
    required this.top,
    required this.height,
    required this.cells,
  });

  String get text {
    final buffer = StringBuffer();
    for (var i = 0; i < cells.length; i++) {
      if (i > 0) buffer.write(cells[i].columnBreakBefore ? '   ' : ' ');
      buffer.write(cells[i].text);
    }
    return buffer.toString();
  }

  List<PdfLayoutCell> get columns {
    final grouped = <PdfLayoutCell>[];
    for (final cell in cells) {
      if (grouped.isEmpty || cell.columnBreakBefore) {
        grouped.add(cell);
      } else {
        final open = grouped.removeLast();
        grouped.add(PdfLayoutCell(
          '${open.text} ${cell.text}',
          open.left,
          cell.right > open.right ? cell.right : open.right,
          columnBreakBefore: open.columnBreakBefore,
        ));
      }
    }
    return grouped;
  }
}

class PdfLayoutExtractor {
  const PdfLayoutExtractor({
    this.rowToleranceRatio = 0.5,
    this.wordGapRatio = 0.22,
    this.numericCohesionRatio = 1.4,
    this.columnGapRatio = 0.9,
  });
  final double rowToleranceRatio;
  final double wordGapRatio;
  final double numericCohesionRatio;
  final double columnGapRatio;

  Future<List<PdfLayoutLine>> extractLines(String path) async {
    final document = await PdfDocument.openFile(path);
    try {
      final lines = <PdfLayoutLine>[];
      for (final page in document.pages) {
        final pageText = await page.loadStructuredText();
        lines.addAll(_linesForPage(page.pageNumber, pageText));
      }
      return lines;
    } finally {
      await document.dispose();
    }
  }

  List<PdfLayoutLine> _linesForPage(int pageNumber, PdfPageText pageText) {
    final frags = pageText.fragments
        .where((f) => f.text.trim().isNotEmpty && f.bounds.height > 0)
        .toList();
    if (frags.isEmpty) return const [];

    final rowTolerance = _median(frags.map((f) => f.bounds.height)) * rowToleranceRatio;

    frags.sort((a, b) => b.bounds.center.y.compareTo(a.bounds.center.y));

    final rows = <List<PdfPageTextFragment>>[];
    var current = <PdfPageTextFragment>[frags.first];
    var rowY = frags.first.bounds.center.y;

    for (final f in frags.skip(1)) {
      if ((rowY - f.bounds.center.y).abs() <= rowTolerance) {
        current.add(f);
      } else {
        rows.add(current);
        current = [f];
        rowY = f.bounds.center.y;
      }
    }
    rows.add(current);

    final lines = <PdfLayoutLine>[];
    for (final row in rows) {
      row.sort((a, b) => a.bounds.left.compareTo(b.bounds.left));
      final rowHeight = _median(row.map((f) => f.bounds.height));
      final cells = _wordsForRow(row, rowHeight);
      if (cells.isEmpty) continue;
      lines.add(PdfLayoutLine(
        pageNumber: pageNumber,
        top: row.first.bounds.top,
        height: rowHeight,
        cells: cells,
      ));
    }
    return lines;
  }

  double _median(Iterable<double> values) {
    final sorted = values.toList()..sort();
    return sorted[sorted.length ~/ 2];
  }

  static bool _isDigit(String g) =>
      g.length == 1 && g.codeUnitAt(0) >= 0x30 && g.codeUnitAt(0) <= 0x39;

  static bool _isNumericGlyph(String g) =>
      g.length == 1 && (_isDigit(g) || g == '.' || g == ',');

  List<PdfLayoutCell> _wordsForRow(
    List<PdfPageTextFragment> row,
    double rowHeight,
  ) {
    final spaceGap = rowHeight * wordGapRatio;
    final columnGap = rowHeight * columnGapRatio;
    final glyphs = <String>[];
    final boxes = <PdfRect>[];
    for (final f in row) {
      final text = f.text;
      if (f.charRects.length == text.length) {
        for (var i = 0; i < text.length; i++) {
          glyphs.add(text[i]);
          boxes.add(f.charRects[i]);
        }
      } else {
        final whole = text.trim();
        if (whole.isNotEmpty) {
          glyphs.add(whole);
          boxes.add(f.bounds);
        }
      }
    }
    if (glyphs.isEmpty) return const [];

    final digitAdvances = <double>[];
    for (var i = 1; i < boxes.length; i++) {
      if (!_isDigit(glyphs[i - 1]) || !_isDigit(glyphs[i])) continue;
      final d = boxes[i].left - boxes[i - 1].left;
      if (d > 0) digitAdvances.add(d);
    }
    digitAdvances.sort();
    final digitAdvance =
        digitAdvances.isEmpty ? null : digitAdvances[digitAdvances.length ~/ 2];
    final words = <PdfLayoutCell>[];
    var buffer = StringBuffer();
    var left = 0.0;
    var right = 0.0;

    void flush() {
      final text = buffer.toString().trim();
      if (text.isNotEmpty) words.add(PdfLayoutCell(text, left, right));
      buffer = StringBuffer();
    }

    for (var i = 0; i < glyphs.length; i++) {
      final glyph = glyphs[i];
      final box = boxes[i];

      if (glyph.trim().isEmpty) {
        flush();
        continue;
      }

      final atomic = glyph.length > 1;
      final prevAtomic = i > 0 && glyphs[i - 1].length > 1;

      var starts = buffer.isEmpty || atomic || prevAtomic;
      if (!starts) {
        starts = (box.left - right) >= spaceGap;
        if (starts &&
            digitAdvance != null &&
            _isNumericGlyph(glyphs[i - 1]) &&
            _isNumericGlyph(glyph) &&
            (box.left - boxes[i - 1].left) <
                digitAdvance * numericCohesionRatio) {
          starts = false;
        }
      }


      if (starts) {
        flush();
        buffer.write(glyph);
        left = box.left;
        right = box.right;
      } else {
        buffer.write(glyph);
        if (box.right > right) right = box.right;
      }
    }
    flush();
    final result = <PdfLayoutCell>[];
    for (var i = 0; i < words.length; i++) {
      final w = words[i];
      final isBreak = i > 0 && (w.left - words[i - 1].right) >= columnGap;
      result.add(
        PdfLayoutCell(w.text, w.left, w.right, columnBreakBefore: isBreak),
      );
    }
    return result;
  }

}
