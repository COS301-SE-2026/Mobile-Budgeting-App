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

  group('CategoryDao.insertCategory', () {
    test('returns category with correct name and type', () async {
      final cat = await dao.insertCategory(
        name: 'Groceries',
        type: CategoryType.expense,
      );

      expect(cat.name, equals('Groceries'));
      expect(cat.type, equals(CategoryType.expense));
    });

    test('generates a non-empty UUID id', () async {
      final cat = await dao.insertCategory(
        name: 'Salary',
        type: CategoryType.income,
      );

      expect(cat.id, isNotEmpty);
    });

    test('defaults isDefault to false', () async {
      final cat = await dao.insertCategory(
        name: 'Rent',
        type: CategoryType.expense,
      );

      expect(cat.isDefault, isFalse);
    });

    test('persists isDefault when set to true', () async {
      final cat = await dao.insertCategory(
        name: 'Salary',
        type: CategoryType.income,
        isDefault: true,
      );

      expect(cat.isDefault, isTrue);
    });

    test('persists optional icon and color', () async {
      final cat = await dao.insertCategory(
        name: 'Dining',
        type: CategoryType.expense,
        icon: Icons.restaurant,
        color: '#FF5733',
      );

      expect(cat.iconData!.codePoint, equals(Icons.restaurant.codePoint));
      expect(cat.color, equals('#FF5733'));
    });

    test('icon and color are null when not provided', () async {
      final cat = await dao.insertCategory(
        name: 'Transport',
        type: CategoryType.expense,
      );

      expect(cat.icon, isNull);
      expect(cat.color, isNull);
    });

    test('sets createdAt and updatedAt to non-null timestamps', () async {
      final before = DateTime.now().toUtc().subtract(
        const Duration(seconds: 1),
      );
      final cat = await dao.insertCategory(
        name: 'Health',
        type: CategoryType.expense,
      );
      final after = DateTime.now().toUtc().add(const Duration(seconds: 1));

      expect(cat.createdAt.isAfter(before), isTrue);
      expect(cat.createdAt.isBefore(after), isTrue);
      expect(cat.updatedAt.isAfter(before), isTrue);
    });

    test('creates self-referencing closure entry at depth 0', () async {
      final cat = await dao.insertCategory(
        name: 'Food',
        type: CategoryType.expense,
      );

      final closureRows = await db.select(db.categoryClosure).get();
      final selfEntry = closureRows.where(
        (r) => r.ancestorId == cat.id && r.descendantId == cat.id,
      );

      expect(selfEntry, hasLength(1));
      expect(selfEntry.first.depth, equals(0));
    });
  });

  group('CategoryDao.getCategoryById', () {
    test('returns the category for an existing id', () async {
      final inserted = await dao.insertCategory(
        name: 'Utilities',
        type: CategoryType.expense,
      );

      final found = await dao.getCategoryById(inserted.id);

      expect(found, isNotNull);
      expect(found!.name, equals('Utilities'));
    });

    test('returns null for a non-existent id', () async {
      final found = await dao.getCategoryById('does-not-exist');

      expect(found, isNull);
    });

    test('excludes soft-deleted categories by default', () async {
      final cat = await dao.insertCategory(
        name: 'Old',
        type: CategoryType.expense,
      );
      await dao.softDeleteCategory(cat.id);

      final found = await dao.getCategoryById(cat.id);

      expect(found, isNull);
    });

    test(
      'includes soft-deleted categories when includeDeleted is true',
      () async {
        final cat = await dao.insertCategory(
          name: 'Old',
          type: CategoryType.expense,
        );
        await dao.softDeleteCategory(cat.id);

        final found = await dao.getCategoryById(cat.id, includeDeleted: true);

        expect(found, isNotNull);
        expect(found!.deletedAt, isNotNull);
      },
    );
  });

  group('CategoryDao.getAllCategories', () {
    test('returns all active categories', () async {
      await dao.insertCategory(name: 'A', type: CategoryType.expense);
      await dao.insertCategory(name: 'B', type: CategoryType.income);

      final all = await dao.getAllCategories();

      expect(all, hasLength(2));
    });

    test('returns empty list when no categories exist', () async {
      expect(await dao.getAllCategories(), isEmpty);
    });

    test('excludes soft-deleted categories by default', () async {
      final cat = await dao.insertCategory(
        name: 'Deleted',
        type: CategoryType.expense,
      );
      await dao.insertCategory(name: 'Active', type: CategoryType.expense);
      await dao.softDeleteCategory(cat.id);

      final all = await dao.getAllCategories();

      expect(all, hasLength(1));
      expect(all.first.name, equals('Active'));
    });

    test('includes soft-deleted when includeDeleted is true', () async {
      final cat = await dao.insertCategory(
        name: 'Deleted',
        type: CategoryType.expense,
      );
      await dao.softDeleteCategory(cat.id);

      final all = await dao.getAllCategories(includeDeleted: true);

      expect(all, hasLength(1));
    });
  });

  group('CategoryDao.getCategoriesByType', () {
    test('returns only income categories', () async {
      await dao.insertCategory(name: 'Salary', type: CategoryType.income);
      await dao.insertCategory(name: 'Rent', type: CategoryType.expense);

      final income = await dao.getCategoriesByType(CategoryType.income);

      expect(income, hasLength(1));
      expect(income.first.name, equals('Salary'));
    });
  });

  group('CategoryDao.updateCategory', () {
    test('updates the name', () async {
      final cat = await dao.insertCategory(
        name: 'Old Name',
        type: CategoryType.expense,
      );

      final updated = await dao.updateCategory(cat.id, name: 'New Name');

      expect(updated.name, equals('New Name'));
    });

    test('updates the type', () async {
      final cat = await dao.insertCategory(
        name: 'Ambiguous',
        type: CategoryType.expense,
      );

      final updated = await dao.updateCategory(
        cat.id,
        type: CategoryType.income,
      );

      expect(updated.type, equals(CategoryType.income));
    });

    test('does not modify fields that are not specified', () async {
      final cat = await dao.insertCategory(
        name: 'Food',
        type: CategoryType.expense,
        icon: Icons.restaurant,
        color: '#FF0000',
      );

      final updated = await dao.updateCategory(cat.id, name: 'Groceries');

      expect(updated.iconData!.codePoint, equals(Icons.restaurant.codePoint));
      expect(updated.color, equals('#FF0000'));
      expect(updated.type, equals(CategoryType.expense));
    });

    test('refreshes updatedAt timestamp', () async {
      final cat = await dao.insertCategory(
        name: 'Test',
        type: CategoryType.expense,
      );
      final originalSec = cat.updatedAt.microsecondsSinceEpoch ~/ 1000000;

      await waitForNextSecond();

      final updated = await dao.updateCategory(cat.id, name: 'Updated');

      expect(
        updated.updatedAt.microsecondsSinceEpoch ~/ 1000000,
        greaterThan(originalSec),
      );
    });
  });

  group('CategoryDao.softDeleteCategory', () {
    test('sets a non-null deletedAt timestamp', () async {
      final cat = await dao.insertCategory(
        name: 'Temp',
        type: CategoryType.expense,
      );

      await dao.softDeleteCategory(cat.id);

      final fetched = await dao.getCategoryById(cat.id, includeDeleted: true);
      expect(fetched!.deletedAt, isNotNull);
    });
  });

  group('CategoryDao.restoreCategory', () {
    test('clears deletedAt', () async {
      final cat = await dao.insertCategory(
        name: 'Restored',
        type: CategoryType.expense,
      );
      await dao.softDeleteCategory(cat.id);

      await dao.restoreCategory(cat.id);

      final fetched = await dao.getCategoryById(cat.id);
      expect(fetched, isNotNull);
      expect(fetched!.deletedAt, isNull);
    });
  });

  group('CategoryDao.hardDeleteCategory', () {
    test('removes the category row', () async {
      final cat = await dao.insertCategory(
        name: 'Gone',
        type: CategoryType.expense,
      );

      await dao.hardDeleteCategory(cat.id);

      expect(await dao.getCategoryById(cat.id, includeDeleted: true), isNull);
    });

    test('removes the associated closure entry', () async {
      final cat = await dao.insertCategory(
        name: 'Gone',
        type: CategoryType.expense,
      );

      await dao.hardDeleteCategory(cat.id);

      final closureRows = await db.select(db.categoryClosure).get();
      expect(
        closureRows.where(
          (r) => r.ancestorId == cat.id || r.descendantId == cat.id,
        ),
        isEmpty,
      );
    });
  });
}
