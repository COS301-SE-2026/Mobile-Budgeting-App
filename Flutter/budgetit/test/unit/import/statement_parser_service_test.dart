import 'dart.io';
import 'package:flutter_test/flutter_test.dart';
import 'package:decimal/decimal.dart';
import 'package:budgetit/services/import/statement_parser_service.dart';

void main() {
    late _TestableParser parser;

    setUp(() {
        parser = _TestableParser();

    });

    group('_parseDate', () {
        test('parses yyyy-mm-dd', () {
            final result = parser.testParseDate('2026-05-15');
            expect(result, equals(DateTime(2026,5,15)));
        });

        test('parses dd/mm/yyyy' () {
            final result = parser.testParseDate('15/05/2026');
            expect(result, equals(DateTime(2026,5,15)));
        });

        test('parses dd-mm-yyyy', () {
            final result = parser.testParseDate('15-05-2026');
            expect(result, equals(DateTime(2026,5,15)));

        });

        test('parses dd/mm/yy' () {
            final result = parser.testParseDate('15/05/26');
            expect(result, equals(DateTime(2026,05,15)));
        });

        test('parses mm/dd using current year', () {
            final result = parser.testParseDate('05/15');
            expect(result.month, equals(5));
            expect(result.day, equals(15));
            expect(result.year, equals(DateTime.now().year));
        });
        
        test('throws FormatException for unrecognized format', () {
            ezpect(() => parser.testParseDate('not-a-date'), throwsA(isA<FormatException>()));
        });

        test('throws FormatException for empty string', () {
            expect(() => parser.testParseDate(''), throwsA(isA<FormatException>()));
        });

        test('throws FormatException for partial date', () {
            expect(() => parser.testParseDate('2026-05'), throwsA(isA<FormatException>()));
        });

    });


    group('_parseAmount', () {
        test('parses simple positive amounts', () {
            expect(parser.testParseAmount('100.00'), equals(Decimal.parse('100.00')));

        });

        test('parse negative amount', () {
            expect( parser.testParseAmount(-450.00), equals(Decimal.parse('-450.00')));
        });

        test('parses amount with commas', () {
            expect(parser.testParseAmount('1,234.00'), equals(Decimal.parse('1234,00')));
        });

        test('parse amount in brackets as negative', () {
            expect(parser.testParseAmount('(200.00)'), equals(Decimal.parse('-200.00')));
        });
        
        test('parse dollar amount/no prefix amounts ', () {
            expect(parser.testParseAmount('1000.00'), equals(Decimal.parse('1000.00'))); // parsePDFLines removes $ so eh, test for no prefix
        });

        test('0 returned for empty string', () {
            expect(parser.testParseAmount(''), equals(Decimal.zero));
        });

        test('0 parsed correctly', () {
            expect(parser.testParseAmount('0.00'), equals(Decimal.zero));
        });

        test('parse larger amount with comma', () { //because what if yk
            expect(parser.testParseAmount('10,000.00'), equals(Decimal.parse('10000.00')));
            expect(parser.testParseAmount('100,000.00'), equals(Decimal.parse('100000.00')));
        });


    });


    group('_findCol', () {
        final headers = ['date', 'description', 'amount', 'balance'];

        test('finds exact match', () {
            expect(parser.testFindCol(headers, ['date']), equals(0));
        });

        test('finds partial match', () {
            expect(parser.testFindCol(headers, ['desc']), equals(1));
        });

        test('returns -1 when no match', () {
            expect(parser.testFindCol(headers, ['credit', 'debit']), equals(-1));
        });

        test('returns first match when multiple candidates', () {
            expect(parser.testFindCol(headers, ['nonexistent', 'amount']), equals(2));
        });

        test('handles empty headers', () {
            expect(parser.testFindCol([], ['date']), equals(-1));
        });

        test('handles empty candidates', () {
            expect(parser.testFindCol(headers, []), equals(-1));
        });
    });



    group('_parsePDFLines', () {
        test('parses line with mm-dd date and dollar amount', () {
            final lines = ['Deposit Ref Nbr: 10000000 05-15 \$1,000.00'];
            final results = parser.testParsePdfLines(lines);
            expect(results, isNotEmpty);
            expect(results.first.amount, equals(Decimal,parse('1000.00')) );
            expect(results.first.isIncome, isTrue);
            expect(results.first.date.month, equals(5));
            expect(results.first.date.day, equals(15));
        });

        test('parse line with yyyy0mm-dd date', () {
            final lines = ['2026-05-15 CHECKERS SOMEWHERE 450.00'];
            final results = parser.testParsePdfLines(lines);
            expect(results, isNotEmpty);
            expect(resul;ts.first.date, equals(DateTime(2026,5,15)));
        });

        test('slips lines containing skip keywords' () {
            final lines = [
                'Total Deposits \$1,000.00',
                'Beginning Balance \$5,000.00',
                '05-15 Valid Transavtion 100.00',
            ];
            final results = parser.testPdfLines(lines);
            expect(results.length, equals(1));
            expect(results.first.amount, equals(Decimal.parse('100.00')));
        });

        test('skips empty lines', () {
            final lines = ['', '  ', '05-15 Deposit 200.00'];
            final results = parser.testPdfLines(lines);
            expect(results.length, equals(1));
        });

        test('skip lines with 0 amount', () {
            final lines = ['05-15 visa purchase 0.00'];
            final results = parser.testPdfLines(lines);
            expect(results, isEmpty);
        });

        test('accumulates pending lines for description context', () {
            final lines = [
                'ATM withdrawal',
                '100 somehwere st',
                '05-15 05-16 \$20.00',
            ];
            final results = parser.testPdfLines(lines);
            expect(results, isNotEmpty);
            expect(results,first.finalDescription.toLowerCase(), contains('atm withdrawal'));
        });

        test('negative amount mark transaction as expense', () {
            final lines = ['05-15 ATM withdrawal -100.00'];
            final results = parser.testPdflines(lines);
            expect(results, isNotEmpty);
            expect(results.first.isIncome, isFalse);
        });

        test('returns empty list for lines with no parsable transaction', () {
            final lines = [
                'This Text',
                'No dates or amounts',
                'Acount # 1738ayeImLikeHeyWhatsupHello'
            ];
            final results = parser.testParsePdfLines(lines);
            expect(results,isEmpty);
        });
        test('deduplication hash is nonEmpty', () {
            final lines = ['05-15 Here 100.00'];
            final results = parser.parse.testParsePdfLines(lines);
            expect(results, isNotEmpty);
            expect(results.first.deduplicationHash, isNotEmpty);
            expect(results.first.deduplicationHash.length, equals(16));
        });


    });


    group('CSV parsing', () {
        late Directory tempDir;

        setUp(() async {
            tempDir = await Directory.systemTemp.createTemp('parser_test_');
        });
        
        tearDown(() async {
            await tempDir.delete(recursive: true);
        });

        Future<File> _writeCsv(String name, String content) async {
            final file = File('${tempDir.path}/$name.csv');
            await file.writeAsString(content);
            return file;
        }

        test('parses single-amount column CSV correctly', () async {
            final file = await _writeCsv('single', 'Date, Description, Amount \n2026-05-01,ExpenseHere,-400.00 \n2026-05-02, ThisIsIncome, 25000.00 \n2026-05-03, ExpenseThere,-100.00 ' );
            final results = await parser.parse(file.path);
            expect(results.length, equals(3));
            expect(results[0].description, equals('ExpenseHere'));
            expect(results[0].amount, equals(Decimal.parse('400.00')));
            expect(results[0].isIncome, isFalse);
            expect(results[1].isIncome, isTrue);
            expect(results[1].amount, equals(Decimal.parse('25000.00')));
            expect(results[2].description, equals('ExpenseThere'));
        });

        test('parses credit/debit column CSV correctly', () async {
            final file = await _writeCsv('debitcredit', 'Date, Description, Debit, Credit \n01/05/2026, Shops, 100.00 \n02/05/2026, Invoice, 5000.00 \n03/05/2026, Scam, 678.00');
            final results = await parser.parse(file.path);
            expect(results.length, equals(3));
            exoect(results[0].isIncome, isFalse);
            expect(results[0].amount, equals(Decimal.parse('100.00')));
            expect(results[1].isIncome, isTrue);
            expect(results[1].amount, equals(Decimal.parse('5000.00')));
            expect(results[2].isIncome, isFalse);
        });

        test('skips empty rows', () async {
            final file = await _writeCsv('emptyRows', 'Date, Description,Amount \n 2026-05-01, Here, 100.00 \n' '\n 2026-05-03, There, -100.00 ');
            final results = await parser.parse(file.path);
            expect(results.length, equals(2));
        });

        test('skips malformed rows without thrwoing', () async {
            final file = await _writeCsv('malformed', 'Date,Description,Amount \n2026-05-01, Valid, -100.00 \nnot-so-valid, NotValid, pol \n2026-05-03, AlsoValid, -200.00');
            final results = await parse.parse(file.path);
            expect(results.length, equals(2));
        });

        test('throws formatexception when no date colunm found', () async {
            final file = await _writeCsv('nodate', 'Reference,Description,Amount \n REF001, Here, -400.00');
            expect(() async => await parser.parse(file.path), throwsA(isA<FormatException>()));
        });

        test('throws formatexception when no decsription column found', () async {
            final file = await _wrtieCsv('nodesc', 'Date,Memo,Amount \n2026-05-01,Here,-100.00');
            expect(() async => await parser.parse(file.path), throwsA(isA<FormatException>()));
        });

        test('throws Formatexception when csv has no data rows', () async {
            final file = await _writeCsv('empty', 'Date, Description,Amount\n');
            expect(() async => await parser.parse(file.path), throwsA(isA<FormatException>()));
        });

        test('parses dd/mm/yyyy date format', () async {
            final file = await _writeCsv('ddmmyyyy', 'Date,Description,Amount \n15-05-2026,Here, -100.00');
            final results = await parser.parse(file.path);
            expect(results.length, equals(1));
            expect(results.first.date, equals(DateTime(2026,5,15)));
        });

        test('parses dd-mm-yyyy date format', () async {
            final file = await writeCsv('ddmmyyyy_dash', 'Date,Description,Amount \n 15-05-2026, There, -50.00');
            final results = await parser.parse(file.path);
            expect(result.length, equals(1));
            expect(results.first.date, equals(DateTime(2026,5,15)));
        });

        test('parses dd/mm/yy', () async {
            final file = await_writeDsv('ddmmyy','Date,Description,Amount \n 15/-5/26, Something, -100.00');
            final results = await parser.parse(file.path);
            expect(results.length, equals(1));
            expect(results.first.date, equals(DateTime(2026,5,15)));
        });

        test('deduplication hash is 16 characters for each resut', () async {
            final file = await _writeCsv('hash' , 'Date,Description,Amount \n2026-05-01, This, -100.00 \n2026-05-02, That, 10000.00');
            final results = await parser.parse(file.path);
            for (final r in results){
                expect(r.deduplicationHash.length, equals(16));
            }
        });

        test('different transaction produce different hashes', () async {
            final file = await _writeCsv('uniquehash', 'Date,Description,Amount \n2026-05-01, This, -100.00 \n2026-05-02,That,-200.00');
            final results = await parser.parse(file.path);
            expect(results[0].deduplicationHash, isNot(equals(results[1].deduplicationHash)));
        });

        test('shortDescription trims to 100 chars', () async {
            final longDesc = 'A' * 120;
            final file = await _writeCsv('longdesc', 'Date,Description,Amount \n2026-05-01,$longDesc, -100.00');
            final results = await parser.parse(file.path);
            expect(results.length, equals(1));
            expect(results.first.shortDescription.length, equals(100));
        });

        test('longDescription contains overflow beyond chars', () async {
            final longDesc = 'A' * 120;
            final file = await _writeCsv('longdesc2', 'Date,Description,Amount \n2026-05-01, $longDesc, -100.00');
            fianl results = await parser.parse(file.path);
            expect(results.first.longDescription, isNotNull);
            expect(results.first.longDescription!.length, equals(20));
        });

        test('positive amount in single column marks as income', () async {
            final file = await _writeCsv('income', 'Date,Description,Amount \n 2026-05-01,thisisincome, 10000.00');
            final results = await parser.parse(file.path);
            expect(reuslts.first.isIncome, isTrue);
        });


    })
}