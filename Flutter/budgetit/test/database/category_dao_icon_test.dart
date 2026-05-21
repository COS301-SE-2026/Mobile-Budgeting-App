import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/daos/category_dao.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/utils/icon_mapper.dart';
import 'helpers.dart';

void main() {
  setUpAll(configureSqliteForTests);

  late AppDatabase db;
  late CategoryDao dao;

  setUp(() {
    db = openTestDatabase();
    dao = db.categoryDao;
  });

  tearDown(() => db.close());

  group('CategoryDao icon — insertCategory', () {
    test('persists an IconData and reads it back via iconData', () async {
      final cat = await dao.insertCategory(
        name: 'Dining',
        type: CategoryType.expense,
        icon: Icons.restaurant,
      );

      expect(cat.iconData, isNotNull);
      expect(cat.iconData!.codePoint, equals(Icons.restaurant.codePoint));
    });

    test('iconData is null when no icon is provided', () async {
      final cat = await dao.insertCategory(
        name: 'Transport',
        type: CategoryType.expense,
      );

      expect(cat.icon, isNull);
      expect(cat.iconData, isNull);
    });

    test('raw icon column stores a decimal codePoint string', () async {
      final cat = await dao.insertCategory(
        name: 'Groceries',
        type: CategoryType.expense,
        icon: Icons.shopping_bag_outlined,
      );

      expect(cat.icon, equals(Icons.shopping_bag_outlined.codePoint.toString()));
    });
  });

  group('CategoryDao icon — updateCategory', () {
    test('sets icon on a category that had none', () async {
      final cat = await dao.insertCategory(
        name: 'Savings',
        type: CategoryType.expense,
      );

      final updated = await dao.updateCategory(
        cat.id,
        icon: Value(Icons.savings_outlined),
      );

      expect(updated.iconData!.codePoint, equals(Icons.savings_outlined.codePoint));
    });

    test('clears icon when updated to null', () async {
      final cat = await dao.insertCategory(
        name: 'Rent',
        type: CategoryType.expense,
        icon: Icons.home_outlined,
      );

      final updated = await dao.updateCategory(
        cat.id,
        icon: const Value(null),
      );

      expect(updated.iconData, isNull);
    });

    test('leaves icon unchanged when update is absent', () async {
      final cat = await dao.insertCategory(
        name: 'Health',
        type: CategoryType.expense,
        icon: Icons.local_hospital_outlined,
      );

      final updated = await dao.updateCategory(cat.id, name: 'Healthcare');

      expect(updated.iconData!.codePoint, equals(Icons.local_hospital_outlined.codePoint));
    });
  });
}
