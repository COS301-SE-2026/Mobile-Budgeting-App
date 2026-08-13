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

  _CsvCandiddate({
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

    Future<List<ParsedTransaction>> parse (String path) async {
        final lower=path.toLowerCase();
        if (lower.endsWith('.csv')) {
            return _parseCsv(path);
        }
        if (lower.endsWith('.pdf')) {
            return _parsePdf(path);
        }
        throw  UnsupportedError('Unsupported file format. Use CSV or PDF.');
    }

    Future<List<ParsedTransaction>> _parseCsv(String path) async {
        final content = await File(path).readAsString();
        final rows = const CsvToListConverter(eol: '\n').convert(content);
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
          return _parseCsvWithSeparateCreditDebit(rows, headers, dateIdx, descIdx, creditIdx, debitIdx);
        }

        final candidates = <CandidateRow>[];
        for(var i=1;i<rows.length;i++){
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
        
        final results = <ParsedTransaction>[];
        
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
        }

    List<ParsedTransaction> _parseCsvSeparateColumns(
      List<List<dynamic>> rows,
      List<String> headers,
      int dateIdx;
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
          for(var j=0,j<c.rawRow.length;j++) 
            'col_$j' : c.rawRow[j].toString(),
        };
        resukts.add(ParsedTransaction(
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

    Future<List<ParsedTransaction>> _parsePdf(String path) async {
        try {
            final text = await _extractPdfText(path);
            //print('PDF FULL TEXT:\n$text');
            return parsePdfLines(text.split('\n'));
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
            buffer.writeln(text.fullText);
        }
        return buffer.toString();
    }

    @visibleForTesting
    List<ParsedTransaction> parsePdfLines(List<String> lines) {
        for(final line in lines){
            //print ('PDF LINE: $line');
        }
        //final datePattern = RegExp(r'(\d{4}[\/\-]\d{2}[\/\-]\d{2}|\d{1,2}[\/\-]\d{2}[\/\-]\d{2})',
        final datePattern = RegExp(r'(\d{4}[\/\-]\d{2}[\/\-]\d{2}|\d{1,2}[\/\-]\d{2}[\/\-]\d{2,4}|\d{2}[\/\-]\d{2}|\d{1,2}\s+[A-Za-z]{3}(?:\s+\d{4})?)',
        );
        final amountPattern = RegExp(r'\$?([\-]?\d{1,3}(?:,\d{3})*(?:\.\d{2}))\s*(Cr|Dr)?', caseSensitive: false);

        final skipKeywords = ['total','balance','account #','transaction', 'description','summary','page number','statement date', 'beginning balance', 'ending balance',];

        final results = <ParsedTransaction>[];


        final pendingLines = <String>[];
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

        return results;
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



        final RegExp mmdd = RegExp(r'^(\d{1,2})[\/\-](\d{2})$'); //to account for bank statements where date format has no year, based on example statement used in testing.
        final matchMMDD = mmdd.firstMatch(cleaned);
        if(matchMMDD != null){
            return DateTime(
                DateTime.now().year,
                int.parse(matchMMDD.group(1)!),
                int.parse(matchMMDD.group(2)!),
            );
        }
        throw FormatException('Unrecognized date format: $cleaned'); //forgot to move this neh
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

 String _hash(DateTime date, Decimal amount, String description) {
    final key = '${date.toIso8601String()}|${amount.toString()}|${description.toLowerCase().trim()}';
    return sha256.convert(utf8.encode(key)).toString().substring(0, 16);
  }
}