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
}