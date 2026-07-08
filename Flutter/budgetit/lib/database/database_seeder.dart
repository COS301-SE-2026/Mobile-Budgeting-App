import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';

import 'app_database.dart';
import 'schema.dart';
import '../utils/icon_mapper.dart';

/// Populates the database with development seed data loaded from JSON assets.
///
/// Call [seed] once after the database has been created/wiped. The four seed
/// methods run in dependency order: settings → categories → budget templates
/// → transactions (templates and transactions both need category IDs).
class DatabaseSeeder {
  final AppDatabase db;

  DatabaseSeeder(this.db);

  Future<void> seed() async {
    await _seedSettings();
    final categoryIds = await _seedCategories();
    await _seedBudgetTemplates(categoryIds);
    await _seedTransactions(categoryIds);
  }

  Future<void> _seedSettings() async {
    final raw = await rootBundle.loadString('assets/seeds/settings.json');
    final entries = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    for (final entry in entries) {
      await db.settingsDao.setSetting(
        entry['key'] as String,
        entry['value'] as String,
      );
    }
  }

  /// Returns a map of category name → generated UUID for downstream use.
  Future<Map<String, String>> _seedCategories() async {
    final raw = await rootBundle.loadString('assets/seeds/categories.json');
    final entries = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    final ids = <String, String>{};
    for (final entry in entries) {
      final typeStr = entry['type'] as String;
      final type = typeStr == 'income'
          ? CategoryType.income
          : CategoryType.expense;
      final iconStr = entry['icon'] as String?;
      final category = await db.categoryDao.insertCategory(
        name: entry['name'] as String,
        type: type,
        icon: iconStr != null ? iconFromDb(iconStr) : null,
        color: entry['color'] as String?,
        isDefault: true,
      );
      ids[category.name] = category.id;
    }
    return ids;
  }

  Future<void> _seedBudgetTemplates(Map<String, String> categoryIds) async {
    final raw = await rootBundle.loadString(
      'assets/seeds/budget_templates.json',
    );
    final entries = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    for (final entry in entries) {
      final categoryId = categoryIds[entry['category_name'] as String];
      if (categoryId == null) continue;
      final periodStr = entry['period_type'] as String;
      final periodType = PeriodType.values.firstWhere(
        (e) => e.name == periodStr,
      );
      await db.budgetDao.insertBudgetTemplate(
        categoryId: categoryId,
        amount: Decimal.parse(entry['amount'] as String),
        periodType: periodType,
        currency: (entry['currency'] as String?) ?? 'ZAR',
      );
    }
  }

  Future<void> _seedTransactions(Map<String, String> categoryIds) async {
    final raw = await rootBundle.loadString('assets/seeds/transactions.json');
    final entries = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    for (final entry in entries) {
      final typeStr = entry['type'] as String;
      final type = typeStr == 'income'
          ? TransactionType.income
          : TransactionType.expense;
      final tx = await db.transactionDao.insertTransaction(
        amount: Decimal.parse(entry['amount'] as String),
        type: type,
        shortDescription: entry['short_description'] as String,
        transactionDate: DateTime.parse(entry['transaction_date'] as String),
        source: TransactionSource.manual,
        currency: (entry['currency'] as String?) ?? 'ZAR',
      );
      final categoryId = categoryIds[entry['category_name'] as String];
      if (categoryId != null) {
        await db.transactionDao.assignCategory(
          transactionId: tx.id,
          categoryId: categoryId,
          assignmentSource: AssignmentSource.manual,
        );
      }
    }
  }
}
