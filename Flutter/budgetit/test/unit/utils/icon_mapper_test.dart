import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/utils/icon_mapper.dart';

void main() {
  group('iconToDb', () {
    test('returns codePoint as a decimal string', () {
      expect(
        iconToDb(Icons.restaurant),
        equals(Icons.restaurant.codePoint.toString()),
      );
    });

    test('different icons produce different strings', () {
      expect(
        iconToDb(Icons.restaurant),
        isNot(equals(iconToDb(Icons.home_outlined))),
      );
    });
  });

  group('iconToDb', () {
    test('asserts on a non-Material icon in debug mode', () {
      const custom = IconData(0xe900, fontFamily: 'CustomIcons');
      expect(() => iconToDb(custom), throwsAssertionError);
    });
  });

  group('iconFromDb', () {
    test('reconstructs IconData with MaterialIcons fontFamily', () {
      final code = Icons.restaurant.codePoint.toString();
      final icon = iconFromDb(code);
      expect(icon!.codePoint, equals(Icons.restaurant.codePoint));
      expect(icon.fontFamily, equals('MaterialIcons'));
    });

    test('different codePoint strings produce different icons', () {
      final a = iconFromDb(Icons.restaurant.codePoint.toString());
      final b = iconFromDb(Icons.home_outlined.codePoint.toString());
      expect(a!.codePoint, isNot(equals(b!.codePoint)));
    });

    test('returns null for a non-numeric string', () {
      expect(iconFromDb('restaurant'), isNull);
    });

    test('returns null for an empty string', () {
      expect(iconFromDb(''), isNull);
    });
  });

  group('round-trip', () {
    test('iconFromDb(iconToDb(icon)) preserves codePoint', () {
      for (final icon in [
        Icons.restaurant,
        Icons.home_outlined,
        Icons.savings_outlined,
        Icons.directions_car_outlined,
        Icons.shopping_bag_outlined,
      ]) {
        expect(
          iconFromDb(iconToDb(icon))!.codePoint,
          equals(icon.codePoint),
          reason: 'Failed round-trip for icon codePoint ${icon.codePoint}',
        );
      }
    });
  });
}
