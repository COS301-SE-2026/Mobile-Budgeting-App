import 'dart:io';
import 'package:csv/csv.dart';
import 'package:decimal/decimal.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../models/import/parsed_transaction.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:flutter/foundation.dart';
import 'schema_discovery_service.dart';
import 'stub_schema_classifier.dart';
import '../../models/import/candidate_row.dart';
import '../../models/import/statement_schema.dart';



class _CsvCandidate {
  final DateTime date;
  final String description;
  final Decimal signedAmount; //sign parsed straight frim the field
  final String? explicitMarker; //CR/DR
  final String? typeMarker;  //for separate columns
  final List<dynamic> rawRow;

  _CsvCandidate({
    required this.date,
    required this.description,
    required this.signedAmount,
    this.explicitMarker,
    this.typeMarker,
    required this.rawRow,
  });

  String? get resolvedMarker => typeMarker ?? explicitMarker ?? (signedAmount< Decimal.zero ? '-' : null);
  Decimal get absAmount => signedAmount.abs();
}


class StatementParserService {
  final SchemaDiscoveryService _schemaDiscovery;

  StatementParserService({
     SchemaDiscoveryService? schemaDiscovery,
  })
    : _schemaDiscovery = schemaDiscovery ?? SchemaDiscoveryService(classifier: StubSchemaClassifier());


    Future<List<ParsedTransaction>> parse (String path, {SchemaConfirmationCallback? onNeedsSchemaConfirmation}) async {
        final lower=path.toLowerCase();
        if (lower.endsWith('.csv')) {
            return _parseCsv(path, onNeedsSchemaConfirmation: onNeedsSchemaConfirmation);
        }
        if (lower.endsWith('.pdf')) {
            return _parsePdf(path, onNeedsSchemaConfirmation: onNeedsSchemaConfirmation);
        }
        throw  UnsupportedError('Unsupported file format. Use CSV or PDF.');
    }

    Future<List<ParsedTransaction>> _parseCsv(String path, {SchemaConfirmationCallback? onNeedsSchemaConfirmation}) async {
        final content = await File(path).readAsString();
        final rows = const CsvDecoder().convert(content);
        if (rows.length < 2) throw FormatException('CSV has no data rows.');
        
        final headers = rows.first.map((h) => h.toString().toLowerCase().trim()).toList();
        
        final dateIdx = findCol(headers, ['date', 'transaction date', 'posting date', 'value date']);
        final descIdx = findCol(headers, ['description', 'details', 'narration', 'merchant', 'reference']);
        final amountIdx = findCol(headers, ['amount', 'transaction amount']);
        final creditIdx = findCol(headers, ['credit', 'deposit', 'money in']);
        final debitIdx = findCol(headers, ['debit', 'withdrawal', 'money out']);
        final typeIdx = findCol(headers, ['type','transaction type','dr/cr','indicator']);
        
        if (dateIdx == -1) {
            throw FormatException('Could not find a date column.');
        }
        if (descIdx == -1) {
            throw FormatException('Could not find a description column.');
        }
        if (amountIdx == -1 && (creditIdx == -1 || debitIdx == -1)) {
            throw FormatException('Could not find amount columns.');
          }

        if (creditIdx != -1 && debitIdx != -1) {
          return _parseCsvSeparateColumns(rows, headers, dateIdx, descIdx, creditIdx, debitIdx);
        }

        final candidates = <_CsvCandidate>[];
        for(var i=1;i<rows.length;i++){
          final row = rows[i];
          if(row.every((c) => c.toString().trim().isEmpty)){
            continue;
          }
    
        

        try{
          final date = parseDate(row[dateIdx].toString().trim());
          final description = row[descIdx].toString().trim();
          if (description.isEmpty) continue;
          final amountField = _parseCsvAmountField(row[amountIdx].toString());

          String? typeMarker;
          if(typeIdx != -1 && typeIdx < row.length) {
            final t = row[typeIdx].toString().trim();
            if(t.isNotEmpty) {
              typeMarker  = t.toUpperCase();
            }
          }

            candidates.add(_CsvCandidate(
              date: date,
              description: description,
              signedAmount: amountField.signedAmount,
              explicitMarker: amountField.explicitMarker,
              typeMarker: typeMarker,
              rawRow: row,
            ));
          } catch (_) {
            continue;
          }
        }

        if (candidates.isEmpty) return [];

        final hasFullTypeColumn = typeIdx != -1 && candidates.every((c) => c.typeMarker != null);
        if (hasFullTypeColumn) {
          return _finalizeCsv(candidates, (c) {
            final m = c.typeMarker!;
            return m.contains('CREDIT') || m == 'CR' || m.contains('IN');
          });
        }

        final hasNegative = candidates.any((c) => c.signedAmount < Decimal.zero);
        final hasPositive = candidates.any((c) => c.signedAmount > Decimal.zero);
        if (hasNegative && hasPositive) {
          return _finalizeCsv( candidates, (c) => c.signedAmount >= Decimal.zero);
        }

        final rowCandidates = candidates
            .map((c) => CandidateRow(
                date: c.date,
                absAmount: c.absAmount,
                description: c.description,
                signMarker: c.resolvedMarker,
                rawSource: c.rawRow.join(','),
              ))
            .toList();

        //final schema = await _schemaDiscovery.discover(sourceType: 'csv', sampleRows: rowCandidates);
        final peeked = await _schemaDiscovery.peekCached(sourceType: 'csv', sampleRows: rowCandidates);
        final filteredCandidates = peeked == null ? candidates
        : candidates.where((c) => !_matchesSkipPatterns(c.rawRow.join(','), peeked.skipLinePatterns)).toList();
        final filteredRowCandidates = peeked == null ? rowCandidates
        : filteredCandidates.map((c) => CandidateRow(
            date: c.date,
            absAmount: c.absAmount,
            description: c.description,
            signMarker: c.resolvedMarker,
            rawSource: c.rawRow.join(','),
          )).toList();

        final schema = await _schemaDiscovery.discover(
          sourceType: 'csv',
          sampleRows: filteredRowCandidates,
          onNeedsConfirmation: onNeedsSchemaConfirmation,
        );

        return _finalizeCsv(candidates, (c) {
          final asRow = CandidateRow(
              date: c.date,
              absAmount: c.absAmount,
              description: c.description,
              signMarker: c.resolvedMarker,
              rawSource: '',
          );
        return resolveIsIncome(asRow, schema);
        });
      } 
        
       /* final results = <ParsedTransaction>[];
        
        for (var i = 1; i < rows.length; i++) {
            final row = rows[i];
            if (row.every((c) => c.toString().trim().isEmpty)){
                 continue;
            }
        
            try {
                final rawMap = <String, String>{
                    for (var j = 0; j < headers.length && j < row.length; j++)
                        headers[j]: row[j].toString().trim(),
                };
        
                final date = parseDate(row[dateIdx].toString().trim());
                final description = row[descIdx].toString().trim();
                if (description.isEmpty) continue;
        
                Decimal amount;
                bool isIncome;
        
                if (amountIdx != -1) {
                    amount = parseAmount(row[amountIdx].toString().trim()).abs();
                    final raw = parseAmount(row[amountIdx].toString().trim());
                    isIncome = raw >= Decimal.zero;
                } else {
                    final credit = parseAmount(row[creditIdx].toString().trim());
                    final debit = parseAmount(row[debitIdx].toString().trim());
                    if (credit > Decimal.zero) {
                        amount = credit;
                        isIncome = true;
                    } else {
                        amount = debit.abs();
                        isIncome = false;
                    }
                }
        
                results.add(ParsedTransaction(
                    date: date,
                    description: description,
                    amount: amount,
                    isIncome: isIncome,
                    deduplicationHash: _hash(date, amount, description),
                    rawData: rawMap,
                ));
                } catch (_) {
                    continue;
                }
            }
        
            return results;
        }*/

    List<ParsedTransaction> _parseCsvSeparateColumns(
      List<List<dynamic>> rows,
      List<String> headers,
      int dateIdx,
      int descIdx,
      int creditIdx,
      int debitIdx,
    ) {
      final results = <ParsedTransaction>[];
      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.every((c) => c.toString().trim().isEmpty)) {
          continue;
        }

        try {
          final rawMap = <String, String>{
            for (var j = 0; j < headers.length && j < row.length; j++)
              headers[j]: row[j].toString().trim(),
          };

          final date = parseDate(row[dateIdx].toString().trim());
          final description = row[descIdx].toString().trim();
          if (description.isEmpty) continue;
          final credit = parseAmount(row[creditIdx].toString().trim());
          final debit = parseAmount(row[debitIdx].toString().trim());

          Decimal amount;
          bool isIncome;
          if (credit > Decimal.zero) {
            amount = credit;
            isIncome = true;
          } else {
            amount = debit.abs();
            isIncome = false;
          }

          results.add(ParsedTransaction(
            date: date,
            description: description,
            amount: amount,
            isIncome: isIncome,
            deduplicationHash: _hash(date, amount, description),
            rawData: rawMap,
          ));
        } catch (_) {
          continue;
        }
      }
      return results;
    }

    List<ParsedTransaction> _finalizeCsv(
      List<_CsvCandidate> candidates,
      bool Function(_CsvCandidate) isIncomeResolver,
    ) {
      final results = <ParsedTransaction>[];
      for(final c in candidates) {
        final isIncome = isIncomeResolver(c);
        final rawMap = <String, String>{
          for(var j=0;j < c.rawRow.length; j++) 
            'col_$j' : c.rawRow[j].toString(),
        };
        results.add(ParsedTransaction(
          date: c.date,
          description: c.description,
          amount: c.absAmount,
          isIncome: isIncome,
          deduplicationHash: _hash(c.date, c.absAmount, c.description),
          rawData: rawMap,
        ));
      }
      return results;
    }

    ({Decimal signedAmount, String? explicitMarker}) _parseCsvAmountField(
      String raw) {
    final trimmed = raw.trim();
    final crDrMatch = RegExp(r'(Cr|Dr)\s*$', caseSensitive: false).firstMatch(trimmed);
    String? explicitMarker;
    var numericPart = trimmed;
    if (crDrMatch != null) {
      explicitMarker = crDrMatch.group(1)!.toUpperCase();
      numericPart = trimmed.substring(0, crDrMatch.start).trim();
    }

    final value = parseAmount(numericPart);
    return (signedAmount: value, explicitMarker: explicitMarker);
  }

    Future<List<ParsedTransaction>> _parsePdf(String path, { SchemaConfirmationCallback? onNeedsSchemaConfirmation}) async {
        try {
            final text = await _extractPdfText(path);


           final lines = text.split('\n');
            print('---- RAW PDF LINES (${lines.length}) ----');
            for (var i=0; i< lines.length; i++){
              print('[$i] "${lines[i]}"');
            }
            print('--- END RAW PDF LINES ---');


            return await parsePdfLines(
              text.split('\n'),
              onNeedsSchemaConfirmation : onNeedsSchemaConfirmation,
              );
        } on ImportCancelledException {
          rethrow;
        } catch (e) {
            throw FormatException('Could not extract text from PDf: $e');
        }
    }

    Future<String> _extractPdfText(String path) async {
        final document = await PdfDocument.openFile(path);
        final buffer = StringBuffer();
        for (int i = 1; i <= document.pages.length; i++){
            final page = document.pages[i-1];
            final text = await page.loadText();
            if (text != null){
            buffer.writeln(text.fullText);
            }
        }
        return buffer.toString();
    }

    static const List<String> _skipKeywords = [
      'total', 'balance', 'account #', 'transaction', 'description','summary', 'page number',
      'statement date', 'beginning balance', 'ending balance', 'registration number',
      'authorised financial', 'division of', 'proprietary limited', 'reserve bank',
      'terms and conditions', 'ncrcp', 'is a registered', 'period',
      'card no', 'e-stamp', 'general enquries', 'kindly contact', 'expedite any adjustments',
      'differ from your records', 'statement number', 'account number', 'PO BOX',
    ];

    //static final RegExp _datePattern = RegExp( r'(\d{4}[\/\-]\d{2}[\/\-]\d{2}|\d{1,2}[\/\-]\d{2}[\/\-]\d{2,4}|\d{2}[\/\-]\d{2}|\d{1,2}\s+[A-Za-z]{3}(?:\s+\d{4})?)');
   // static final RegExp _datePattern = RegExp( r'(\d{4}[\/\-]\d{2}[\/\-]\d{2}|\d{1,2}[\/\-]\d{2}[\/\-]\d{2,4}|(?<!\d)\d{2}[\/\-]\d{2}(?!\d)|\d{1,2}\s+[A-Za-z]{3}(?:\s+\d{4})?)');
    static final RegExp _datePattern = RegExp(
      r'(\d{4}[\/\-]\d{2}[\/\-]\d{2}'
      r'|\d{1,2}[\/\-]\d{2}[\/\-]\d{2,4}'
      r'|(?<!\d)\d{2}[\/\-]\d{2}(?!\d)'
      r'|(?<![\d.,])(?:0[1-9]|1[0-2])\s(?:0[1-9]|[12]\d|3[01])(?!\d)'
      r'|(?<!\d)\d{1,2}\s+(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*(?:\s+\d{4})?)',
      caseSensitive: false,
    );
    static final RegExp _amountPattern = RegExp(
      r'\$?R?\s?([\-]?(?:\d+(?:[,\s]\d{3})*[.,]\d{2}|\b\d{1,6}\b))(-)?\s*(Cr|Dr)?',
      caseSensitive: false,
    );
    //static final RegExp _periodRangePattern = RegExp( r'^\s*\d{1,2}\s+[A-Za-z]{3}\s+\d{4}\s+to\s+\d{1,2}\s+[A-Za-z]{3}\s+\d{4}\s*$', caseSensitive: false);
        static final RegExp _periodRangePattern = RegExp( r'^\s*(?:statement\s+from\s+)?\d{1,2}\s+[A-Za-z]{3,9}\s+\d{4}\s+to\s+\d{1,2}\s+[A-Za-z]{3,9}\s+\d{4}\s*$', caseSensitive: false);

    List<CandidateRow> _extractPdfCandidates(List<String> lines) {
      final candidates = <CandidateRow>[];
      final pendingLines = <String>[];
      DateTime? pendingDate;
      String? pendingDescription;
      String? lastGoodDescription;

      void resetPendingWrap() {
        pendingDate = null;
        pendingDescription = null;
      }

      for (final rawLine in lines) {
        final trimmed = rawLine.trim();
      if (trimmed.isEmpty) continue;
      final lower = trimmed.toLowerCase();
      if (_skipKeywords.any((k) => lower.contains(k))) {
        pendingLines.clear();
        resetPendingWrap();
        continue;
      }
      if(_periodRangePattern.hasMatch(trimmed)){
        pendingLines.clear();
        resetPendingWrap();
        continue;
      }
      final dateMatch = _datePattern.firstMatch(trimmed);

      //final amountMatch = _amountPattern.firstMatch(trimmed);
      //final amountMatch = dateMatch != null ? _amountPattern.firstMatch(trimmed.substring(dateMatch.end))
      //: _amountPattern.firstMatch(trimmed);
      final beforeDateText = dateMatch != null ? trimmed.substring(0, dateMatch.start) : '';
      final afterDateText = dateMatch != null ? trimmed.substring(dateMatch.end) : trimmed;
      final beforeAmountMatch = (dateMatch != null && !trimmed.contains('=')) ? _selectAmountMatch(beforeDateText) : null;
      final usingBeforeAmount = beforeAmountMatch != null;

      //final searchText = dateMatch != null ? trimmed.substring(dateMatch.end) : trimmed;
      final searchText = usingBeforeAmount ? beforeDateText : afterDateText;
      final allAmountMatches = _amountPattern.allMatches(searchText).toList();
      /*final amountMatch = allAmountMatches.isEmpty ? null
      : (allAmountMatches.length >= 2 ? allAmountMatches[allAmountMatches.length - 2]  
      : allAmountMatches.last);*/
      //final amountMatch = trimmed.contains('=') ? null : _selectAmountMatch(searchText);
      final amountMatch = usingBeforeAmount ? beforeAmountMatch : (trimmed.contains('=') ? null : _selectAmountMatch(afterDateText));
      if (dateMatch == null && amountMatch != null && pendingDate != null ) {
        /*if(dateMatch == null && amountMatch != null){
          final remainder = trimmed.replaceFirst(amountMatch.group(0)!, '').trim();
          if(remainder.isEmpty){
            continue;
          }
        }
        final isLikelyHeaderFragment = !trimmed.contains(' ') && trimmed.length < 15 && !trimmed.contains(RegExp(r'\d'));
        if (!isLikelyHeaderFragment) {
          pendingLines.add(trimmed);
          if (pendingLines.length > 3) pendingLines.removeAt(0);
        }
        continue;*/

      try {
        //final date = parseDate(dateMatch.group(0)!);
        final numGroup = amountMatch.group(1)!;
        final isNegative = numGroup.trim().startsWith('-');
        final trailingMinus = amountMatch.group(2) != null;
        final rawAmountStr = numGroup.replaceAll(RegExp(r'[\s,\-]'), '');
        final absAmount = _parseMatchedAmount(numGroup).abs();
        if (absAmount == Decimal.zero) {
          //throw const FormatException('zero amount');
          continue;
        }

        final crDrSuffix = amountMatch.group(3)?.toUpperCase();
        //final marker = isNegative ? '-' : crDrSuffix;

       // final beforeDate = trimmed.substring(0, dateMatch.start).trim();
        //final afterDate = trimmed.substring(dateMatch.end).trim();
        final amountStr = amountMatch.group(0)!;


        final amountPos = searchText.lastIndexOf(amountStr);

        final description = amountPos >= 0 ? searchText.substring(0, amountPos).trim()
        : searchText.trim();
        final afterAmount = amountPos >= 0 ? searchText.substring(amountPos + amountStr.length)
        : '';        

          
        
      //  final amountPos = searchText.lastIndexOf(amountStr);
      //  final tailDescription = amountPos >= 0 ? searchText.substring(0, amountPos).trim()
      //  : searchText.trim();
        


            //String? positionalMarker;
            //final hasLeadingPlaceHolderDash = RegExp(r'(?:^|\s)-\s*$').hasMatch(description);

            //if(hasLeadingPlaceHolderDash && amountPos >= 0){
          // final afterAmount = amountPos > 0 ? searchText.substring(amountPos + amountStr.length)
          //  : '';
              //positionalMarker = _detectPositionalColumnMarker(afterAmount);
            //}

            final marker = _resolveSignMarker(
              description: description,
              afterAmountText: afterAmount,
              isNegative: isNegative,
              trailingMinus: trailingMinus,
              crDrSuffix: crDrSuffix,

            );

            final combinedDescription = [
              if ((pendingDescription ?? '').isNotEmpty) pendingDescription,
              if(description.isNotEmpty) description,
            ].join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();



          //final marker  = positionalMarker ?? ((isNegative || trailingMinus) ? '-' : crDrSuffix);

        //final descriptionParts = <String>[
          //...pendingLines,
          //if (beforeDate.isNotEmpty) beforeDate,
          //if (description.isNotEmpty) description,
        //];
        //final joinedDescription = descriptionParts.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
        //final finalDescription = joinedDescription.isEmpty ? 'Uncategorised transaction' : joinedDescription;
        //pendingLines.clear();

        candidates.add(CandidateRow(
          date: pendingDate!,
          absAmount: absAmount,
          description: combinedDescription.isEmpty ? 'Uncategorised transaction' : combinedDescription,
          signMarker: marker,
          rawSource: trimmed,
        ));

        pendingLines.clear();
        resetPendingWrap();
        continue;
      } catch (_) {

        //continue;
      }
    }

    if (dateMatch == null || amountMatch == null) {
      if (dateMatch == null && amountMatch != null) {
        final remainder = trimmed.replaceFirst(amountMatch.group(0)!, '').trim();
        if (remainder.isEmpty) continue;
      }
      final isLikelyHeaderFragment = !trimmed.contains(' ') && trimmed.length < 15 && !trimmed.contains(RegExp(r'\d'));

      if (dateMatch != null) {
        try {
          final date = parseDate(dateMatch.group(0)!);
          final beforeDate = trimmed.substring(0, dateMatch.start).trim();
          final afterDate = trimmed.substring(dateMatch.end).trim();
          if (beforeDate.isEmpty && afterDate.isEmpty){
            resetPendingWrap();
          } else {
          pendingDate = date;
          pendingDescription = [beforeDate, afterDate].where((s) => s.isNotEmpty).join(' ');
          }
        } catch (_) {
          resetPendingWrap();
        }
      } else if (pendingDate != null && !isLikelyHeaderFragment) {
        pendingDescription = [
          if ((pendingDescription ?? '').isNotEmpty) pendingDescription,
          trimmed,
        ].join(' ');
      }

      if (!isLikelyHeaderFragment) {
        pendingLines.add(trimmed);
        if (pendingLines.length > 3) pendingLines.removeAt(0);
      }
      continue;
    }

      try {
        final date = parseDate(dateMatch.group(0)!);
        final numGroup = amountMatch.group(1)!;
        final isNegative = numGroup.trim().startsWith('-');
        final trailingMinus = amountMatch.group(2) != null;
        final absAmount = _parseMatchedAmount(numGroup).abs();
        if (absAmount == Decimal.zero) continue;

        final crDrSuffix = amountMatch.group(3)?.toUpperCase();
        final beforeDate = trimmed.substring(0, dateMatch.start).trim();
        final afterDate = trimmed.substring(dateMatch.end).trim();
        final amountStr = amountMatch.group(0)!;
        final amountPos = afterDate.lastIndexOf(amountStr);
        final description = amountPos >= 0
            ? afterDate.substring(0, amountPos).trim()
            : afterDate.trim();
        final afterAmount = amountPos >= 0
            ? afterDate.substring(amountPos + amountStr.length)
            : '';

        final marker = _resolveSignMarker(
          description: description,
          afterAmountText: afterAmount,
          isNegative: isNegative,
          trailingMinus: trailingMinus,
          crDrSuffix: crDrSuffix,
        );

        final descriptionParts = <String>[
          ...pendingLines,
          if (beforeDate.isNotEmpty) beforeDate,
          if (description.isNotEmpty) description,
        ];
        final joinedDescription = descriptionParts.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
        final finalDescription = joinedDescription.isNotEmpty ? joinedDescription : (lastGoodDescription != null ? '$lastGoodDescription (Fee)' : 'Bank Fee');
        if (joinedDescription.isNotEmpty) {
          lastGoodDescription = joinedDescription;
        }
        pendingLines.clear();
        resetPendingWrap();

        candidates.add(CandidateRow(
          date: date,
          absAmount: absAmount,
          description: finalDescription,
          signMarker: marker,
          rawSource: trimmed,
        ));
      } catch (_) {
        pendingLines.clear();
        resetPendingWrap();
        continue;
      }

    }

    return candidates;
  }

  String? _resolveSignMarker({
    required String description,
    required String afterAmountText,
    required bool isNegative,
    required bool trailingMinus,
    String? crDrSuffix,
  }) {
    final hasLeadingPlaceHolderDash = RegExp(r'(?:^|\s)-\s*$').hasMatch(description);
    if (hasLeadingPlaceHolderDash) {
      final positionalMarker = _detectPositionalColumnMarker(afterAmountText);
      if (positionalMarker != null) return positionalMarker;
      return 'DEBIT';
    }
    if (isNegative || trailingMinus) return '-';
    return crDrSuffix;
  }





Match? _selectAmountMatch(String text) {
  for (final m in _amountPattern.allMatches(text)) {
    final before = m.start > 0 ? text[m.start - 1] : '';
    final after = m.end < text.length ? text[m.end] : '';
    if (before == '*' || after == '*') continue;
    final tail = text.substring(m.end).replaceAll(RegExp(r'(Cr|Dr)', caseSensitive: false), '');
    if (RegExp(r'[A-Za-z]').hasMatch(tail)) continue;
    if(tail.trimLeft().startsWith('[%]')) continue;
    return m;
  }
  return null;
}  

  String? _detectPositionalColumnMarker(String afterAmountText) {
    final nextAmount = _amountPattern.firstMatch(afterAmountText);
    if(nextAmount == null ) return null;

    final between = afterAmountText.substring(0, nextAmount.start);
    final dashCount = RegExp(r'(?:^|\s)-(?=\s|$)').allMatches(between).length;

    if(dashCount  ==0) return 'DEBIT';
    if(dashCount  ==1) return 'CREDIT';
    if(dashCount  ==2) return 'DEBIT';
    return null;
  }

  Decimal _parseMatchedAmount(String matched){
    final isNeg = matched.trim().startsWith('-');
    final body = isNeg? matched.substring(1) : matched;
    final decimalMatch = RegExp(r'^(.*)[.,](\d{2})$').firstMatch(body);
    if(decimalMatch == null) {
      final digitsOnly = body.replaceAll(RegExp(r'[,\s]'), '');
      final value = Decimal.parse(digitsOnly.isEmpty ? '0' : digitsOnly);
      return isNeg ? -value : value;
    }
    final wholePart = decimalMatch.group(1)!.replaceAll(RegExp(r'[,\s]'), '');
    final centsPart = decimalMatch.group(2)!;
    final normalised = '${wholePart.isEmpty ? '0' : wholePart}.$centsPart';
    final value = Decimal.parse(normalised);
    return isNeg ? -value : value;
  }




    @visibleForTesting
    Future<List<ParsedTransaction>> parsePdfLines(List<String> lines, {SchemaConfirmationCallback? onNeedsSchemaConfirmation}) async {
       // for(final line in lines){
            //print ('PDF LINE: $line');
        //}
        //final datePattern = RegExp(r'(\d{4}[\/\-]\d{2}[\/\-]\d{2}|\d{1,2}[\/\-]\d{2}[\/\-]\d{2})',
        //final datePattern = RegExp(r'(\d{4}[\/\-]\d{2}[\/\-]\d{2}|\d{1,2}[\/\-]\d{2}[\/\-]\d{2,4}|\d{2}[\/\-]\d{2}|\d{1,2}\s+[A-Za-z]{3}(?:\s+\d{4})?)',
        //);
        //final amountPattern = RegExp(r'\$?([\-]?\d{1,3}(?:,\d{3})*(?:\.\d{2}))\s*(Cr|Dr)?', caseSensitive: false);

        //final skipKeywords = ['total','balance','account #','transaction', 'description','summary','page number','statement date', 'beginning balance', 'ending balance',];
        final candidates = _extractPdfCandidates(lines);
        if (candidates.isEmpty) {
          return [];
        }

        final peeked = await _schemaDiscovery.peekCached(sourceType: 'pdf', sampleRows: candidates);
        final filteredCandidates = peeked == null ? candidates
        : candidates.where((c) => !_matchesSkipPatterns(c.rawSource, peeked.skipLinePatterns)).toList();
        final schema = await _schemaDiscovery.discover(
          sourceType: 'pdf',
          sampleRows: filteredCandidates,
          onNeedsConfirmation: onNeedsSchemaConfirmation,
        );


        final results = <ParsedTransaction>[];

        for(final c in filteredCandidates){
          final isIncome = resolveIsIncome(c, schema);
          results.add(ParsedTransaction(
            date: c.date,
            description: c.description,
            amount: c.absAmount,
            isIncome: isIncome,
            deduplicationHash: _hash(c.date, c.absAmount, c.description),
            rawData: {'raw_line': c.rawSource},
          ));
        }
        return results;


       /* final pendingLines = <String>[];
            for (final rawLine in lines) {
                final trimmed = rawLine.trim();
                if (trimmed.isEmpty) {
                    continue;
                }
                final lower = trimmed.toLowerCase();
                if(skipKeywords.any((k) => lower.contains(k))) {
                    pendingLines.clear();
                    continue;
                
                }
            
            final dateMatch = datePattern.firstMatch(trimmed);
            final amountMatch = amountPattern.firstMatch(trimmed);
            if(dateMatch==null||amountMatch==null) {
              final isLikelyHeaderFragment = !trimmed.contains(' ') && trimmed.length < 15 && !trimmed.contains(RegExp(r'\d'));
              if(!isLikelyHeaderFragment){
                pendingLines.add(trimmed);
                if(pendingLines.length>3){
                    pendingLines.removeAt(0);
                }
              }
                continue;
            }

            try{
                final date= parseDate(dateMatch.group(0)!);
                final rawAmount = amountMatch.group(1)!.replaceAll(RegExp(r'[\s,]'),'');
                final amount = parseAmount(rawAmount).abs();

                final crDrSuffix = amountMatch.group(2)?.toUpperCase();

                final isIncome = crDrSuffix == 'CR';
                final beforeDate = trimmed.substring(0,dateMatch.start).trim();
                final afterDate = trimmed.substring(dateMatch.end).trim();
                final amountStr = amountMatch.group(0)!;
                final amountPos = afterDate.lastIndexOf(amountStr);
                //final beforeAmount = afterDate.substring(0, afterDate.lastIndexOf(amountMatch.group(0)!)).trim();
                //final description = beforeAmount.isEmpty ? afterDate : beforeAmount;
                final description = amountPos > 0 ? afterDate.substring(0, amountPos).trim() : afterDate.replaceAll(amountStr, '').trim();
               // final datePattern = RegExp(r'(\d{1,2}[\/\-]\d{2}[\/\-]?\d{0,4})');

               final descriptionParts = <String>[
                ...pendingLines,
                if(beforeDate.isNotEmpty) beforeDate,
                if(description.isNotEmpty) description,
               ];

               final joinedDescription = descriptionParts.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();

               final finalDescription = joinedDescription.isEmpty ? 'Uncategorised transaction' : joinedDescription;
               pendingLines.clear();

                if(amount == Decimal.zero){
                    continue;
                }
                results.add(ParsedTransaction(
                    date:date,
                    description:finalDescription,
                    amount:amount,
                    isIncome:isIncome,
                    deduplicationHash: _hash(date,amount,finalDescription),
                    rawData: {'raw_line': trimmed},
                ));
            } catch (_) {
                pendingLines.clear();
                continue;
            }
        }
        print('DEBUG: parsePdfLines returning ${results.length} transactions');
        for (final r in results) {
          print('DEBUG: ${r.date} | ${r.isIncome ? "IN" : "OUT"} | ${r.amount} | ${r.description}');
        }

        return results;*/
    }

    @visibleForTesting
    int findCol(List<String> headers, List<String> candidates){
        for(final candidate in candidates) {
            final idx = headers.indexWhere((h)=> h.contains(candidate));
            if(idx != -1){
                return idx;
            }
        }
        return -1;
    }

    static const Map<String, int> _monthAbbreviations = {
      'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
      'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
    };

    @visibleForTesting
    DateTime parseDate(String raw) {
        final cleaned = raw.trim();

        final dayMonthYear = RegExp(r'^(\d{1,2})\s+([A-Za-z]{3})\s+(\d{4})$'); //ai used for regexps (all of them)
        final matchDMY = dayMonthYear.firstMatch(cleaned);
        if(matchDMY != null){
          final month = _monthAbbreviations[matchDMY.group(2)!.toLowerCase()];
          if(month != null){
            return DateTime(int.parse(matchDMY.group(3)!), month, int.parse(matchDMY.group(1)!));
          }
        }
        final dayMonth = RegExp(r'^(\d{1,2})\s+([A-Za-z]{3})$');
        final matchDM = dayMonth.firstMatch(cleaned);
        if(matchDM != null){
          final month = _monthAbbreviations[matchDM.group(2)!.toLowerCase()];
          if(month != null) {
            return DateTime(DateTime.now().year, month, int.parse(matchDM.group(1)!));
          }
        }

        final monthDaySpace = RegExp(r'^(\d{2})\s(\d{2})$');
        final matchMDSpace = monthDaySpace.firstMatch(cleaned);
        if (matchMDSpace != null) {
          final month = int.parse(matchMDSpace.group(1)!);
          final day = int.parse(matchMDSpace.group(2)!);
          if (month >= 1 && month <= 12 && day >= 1 && day <= 31) {
            return DateTime(DateTime.now().year, month, day);
          }
        }

        final formats = [
                  RegExp(r'^(\d{4})-(\d{2})-(\d{2})$'),   // yyyy-mm-dd
                  RegExp(r'^(\d{2})/(\d{2})/(\d{4})$'),   // dd/mm/yyyy
                  RegExp(r'^(\d{2})-(\d{2})-(\d{4})$'),   // dd-mm-yyyy
                  RegExp(r'^(\d{2})/(\d{2})/(\d{2})$'),   // dd/mm/yy
        ];

        final match0 =  formats[0].firstMatch(cleaned);
        if (match0 != null) {
            return DateTime(int.parse(match0.group(1)!), int.parse(match0.group(2)!), int.parse(match0.group(3)!));
        }
        final match1 = formats[1].firstMatch(cleaned);
        if( match1 != null) {
            return DateTime(int.parse(match1.group(3)!), int.parse(match1.group(2)!), int.parse(match1.group(1)!));
        }
        final match2 = formats[2].firstMatch(cleaned);
        if (match2 != null) {
            return DateTime(int.parse(match2.group(3)!), int.parse(match2.group(2)!), int.parse(match2.group(1)!));
        }
        final match3 = formats[3].firstMatch(cleaned);
        if (match3 != null){
        final year = 2000 + int.parse(match3.group(3)!);
        return DateTime(year, int.parse(match3.group(2)!), int.parse(match3.group(1)!));
        }



        final RegExp mmdd = RegExp(r'^(\d{1,2})[\/\-](\d{2})$');
        final matchMMDD = mmdd.firstMatch(cleaned);
        if(matchMMDD != null){
          final month = int.parse(matchMMDD.group(1)!);
          final day = int.parse(matchMMDD.group(2)!);
          if (month < 1 || month > 12 || day < 1 || day > 31) {
              throw FormatException('Unrecognized date format: $cleaned');
          }
        return DateTime(DateTime.now().year, month, day);
        }
        throw FormatException('Unrecognized date format: $cleaned');
}

@visibleForTesting
Decimal parseAmount(String raw) {
    if (raw.isEmpty) {
        return Decimal.zero;
    }
    var cleaned = raw.replaceAll(',', '').trim();
    final negative = cleaned.startsWith('(') && cleaned.endsWith(')');
    cleaned = cleaned.replaceAll(RegExp(r'[()]'), '');
    if (cleaned.isEmpty) {
        return Decimal.zero;
    }
    final value = Decimal.parse(cleaned);
    return negative ? -value : value;
}

  bool _matchesSkipPatterns(String text, List<String> patterns) {
    if (patterns.isEmpty) return false;
    final lower = text.toLowerCase();
    return patterns.any((p) => p.trim().isNotEmpty && lower.contains(p.toLowerCase()));
  }

 String _hash(DateTime date, Decimal amount, String description) {
    final key = '${date.toIso8601String()}|${amount.toString()}|${description.toLowerCase().trim()}';
    return sha256.convert(utf8.encode(key)).toString().substring(0, 16);
  }
}