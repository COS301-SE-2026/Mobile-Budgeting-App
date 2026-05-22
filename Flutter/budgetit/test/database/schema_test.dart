import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/database/schema.dart';

void main() {
  group('DecimalConverter', () {
    final converter = DecimalConverter();

    test('fromSql parses a positive decimal string', () {
      expect(converter.fromSql('123.45'), equals(Decimal.parse('123.45')));
    });

    test('fromSql parses a negative decimal string', () {
      expect(converter.fromSql('-99.99'), equals(Decimal.parse('-99.99')));
    });

    test('fromSql parses zero', () {
      expect(converter.fromSql('0'), equals(Decimal.zero));
    });

    test('fromSql parses a high-precision value', () {
      expect(
        converter.fromSql('1234567890.123456789'),
        equals(Decimal.parse('1234567890.123456789')),
      );
    });

    test('toSql serializes a Decimal to its string representation', () {
      final value = Decimal.parse('99.99');
      expect(converter.toSql(value), equals(value.toString()));
    });

    test('toSql serializes negative Decimal correctly', () {
      final value = Decimal.parse('-0.01');
      expect(converter.toSql(value), equals(value.toString()));
    });

    test('round-trip: fromSql(toSql(x)) equals x', () {
      final values = [
        Decimal.zero,
        Decimal.parse('1.5'),
        Decimal.parse('-999.99'),
        Decimal.parse('1234567890.123456789'),
      ];
      for (final v in values) {
        expect(converter.fromSql(converter.toSql(v)), equals(v));
      }
    });
  });
}
