import 'dart:io';
import 'package:csv/csv.dart';
import 'package:decimal/decimal.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../models/import/parsed_transaction.dart';




class StatementParserService {
    Future<List<ParsedTransaction>> parse (String path) async {
        final lower=path.toLowerCase();
        if (lower.endsWith('.csv')) {
            return _parseCsv(path);
        }
        if (lower.endWith('.pdf')) {
            return _parsePdf(path);
        }
        throw  UnsupportedError('Unsupported file format. Use CSV or PDF.');
    }

    Future<List<ParsedTransaction>> _parseCsv(String path) async {
        final content = await File(path).readAsString();
        final rows = const CsvToListConverter(eol: '\n').convert(content);
        if (rows.length < 2) throw FormatException('CSV has no data rows.');
        
        final headers = rows.first
            .map((h) => h.toString().toLowerCase().trim())
            .toList();
        
        final dateIdx = _findCol(headers, ['date', 'transaction date', 'posting date', 'value date']);
        final descIdx = _findCol(headers, ['description', 'details', 'narration', 'merchant', 'reference']);
        final amountIdx = _findCol(headers, ['amount', 'transaction amount']);
        final creditIdx = _findCol(headers, ['credit', 'deposit', 'money in']);
        final debitIdx = _findCol(headers, ['debit', 'withdrawal', 'money out']);
        
        if (dateIdx == -1) {
            throw FormatException('Could not find a date column.');
        }
        if (descIdx == -1) {
            throw FormatException('Could not find a description column.');
        }
        if (amountIdx == -1 && (creditIdx == -1 || debitIdx == -1)) {
            throw FormatException('Could not find amount columns.');
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
        
                final date = _parseDate(row[dateIdx].toString().trim());
                final description = row[descIdx].toString().trim();
                if (description.isEmpty) continue;
        
                Decimal amount;
                bool isIncome;
        
                if (amountIdx != -1) {
                    amount = _parseAmount(row[amountIdx].toString().trim()).abs();
                    final raw = _parseAmount(row[amountIdx].toString().trim());
                    isIncome = raw >= Decimal.zero;
                } else {
                    final credit = _parseAmount(row[creditIdx].toString().trim());
                    final debit = _parseAmount(row[debitIdx].toString().trim());
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

    Future<List<ParsedTransaction>> _parsePdf(String path) async {
        try {
            final text = await _extractPdfText(path);
            return _parsePdfLines(text.split('\n'));
        } catch (e) {
            throw FormatException('Could not extract text from PDf: $e');
        }
    }

    Future<String> _extractPdfText(String path) async {
        throw UnimplementedError(
            'Add pdf_text to pubspec.yaml, then replace this stub:\n'
            " final doc = await PDFDoc.fromPath('$path');\n"
            ' return await doc.text:',
        );
    }

    List<ParsedTransaction> _parsePdfLines(List<String> lines) {
        final datePattern = RegExp(r'(\d{2}[\/\-]\d{2}[\/\-]\d{2,4}|\d{4}[\/\-]\d{2}[\/\-]\d{2})',
        );
        final amountPattern = RegExp(r'([\-]?\d{1,3}(?:[,\s]\d{3})*(?:\.\d{2}))');
        final results = <ParsedTransaction>[];

        for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.isEmpty){
                continue;
            }
            final dateMatch = datePattern.firstMatch(trimmed);
            final amountMatch = amountPattern.firstMatch(trimmed);
            if(dateMatch==null||amountMatch==null) {
                continue;
            }

            try{
                final date= _parseDate(dateMatch.group(0)!);
                final rawAmount = amountMatch.group(0)!.replaceAll(RegExp(r'[\s,]'),'');
                final amount = _parseAmount(rawAmount).abs();
                final isIncome = !rawAmount.startsWith('-');
                final afterDate = trimmed.substring(dateMatch.end).trim();
                final beforeAmount = afterDate.substring(0, afterDate.lastIndexOf(amountMatch.group(0)!)).trim();
                final description = beforeAmount.isEmpty ? afterDate : beforeAmount;

                if(description.isEmpty || amount == Decimal.zero){
                    continue;
                }
                results.add(ParsedTransaction(
                    date:date,
                    description:description,
                    amount:amount,
                    isIncome:isIncome,
                    deduplicateHash: _hash(date,amount,description),
                    rawData: {'raw_line': trimmed},
                ));
            } catch (_) {
                continue;
            }
        }

        return results;
    }

    int _findCol(List<String> headers, List<String> candidates){
        for(final candidate in candidates) {
            final idx = headers.inderWhere((h)=> h.contains(candidate));
            if(idx != -1){
                return idx;
            }
        }
        return -1;
    }

    DateTime _parseDate(String raw) {
        final cleaned = raw.trim();

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

        throw FormatException('Unrecognized date format: $cleaned');
}

Decimal _parseAmount(String raw) {
    if (raw.isEmpty) {
        return Decimal.zero;
    }
    var cleaned = raw .replaceAll(RegExp(r'[()]'), '') 
    .replaceAll(',', '');
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