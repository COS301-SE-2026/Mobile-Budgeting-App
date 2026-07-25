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
}