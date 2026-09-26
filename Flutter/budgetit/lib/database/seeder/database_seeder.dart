import 'dart:convert';

import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/utils/icon_mapper.dart';
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

part 'budget_scope_mutator.dart';
part 'category_scope_mutator.dart';
part 'database_seeder_impl.dart';
part 'recurring_transaction_scope_mutator.dart';
part 'seed_fixture_reader.dart';
part 'transaction_scope_mutator.dart';

/// A collection of related seed data that can be seeded or deleted.
enum SeedScope {
  /// Category records and their closures.
  categories('Categories'),

  /// Budget templates and their generated periods.
  budgets('Budgets'),

  /// Transactions and their category assignments.
  transactions('Transactions'),

  /// Recurring transaction templates.
  recurringTransactions('Recurring transactions');

  /// Creates a scope with its [label].
  const SeedScope(this.label);

  /// The user facing name of this scope.
  final String label;
}

/// Manual seed operations.
///
/// Mutators should never be called in release builds.
abstract interface class DatabaseSeeder {
  /// Creates a seeder that operates on [database].
  ///
  /// Uses [JsonSeedFixtureReader] unless [fixtureReader] is supplied.
  factory DatabaseSeeder(
    AppDatabase database, {
    SeedFixtureReader? fixtureReader,
  }) = _DatabaseSeeder;

  /// The database used for seeding.
  AppDatabase get db;

  /// Returns the row counts for each scope
  /// Includes soft deleted records.
  Future<Map<SeedScope, int>> getScopeCounts();

  /// Lists the categories of fixtures that are absent from the current database.
  Future<List<String>> listMissingCategories(SeedScope scope);

  /// Seeds an empty [scope].
  ///
  /// Optionally replaces missing category dependencies.
  Future<void> seedScope(
    SeedScope scope, {
    bool replaceCategories = false,
    Map<SeedScope, int>? expectedCounts,
  });

  /// Deletes all the records in the supplied [scope].
  ///
  /// Cascades deletes to dependants.
  Future<void> deleteScope(
    SeedScope scope, {
    Map<SeedScope, int>? expectedCounts,
  });

  /// Returns the number of rows that deleting [scope] will remove.
  Future<Map<SeedScope, int>> getDeletionImpact(SeedScope scope);

  /// Returns the confirmation for deleting [scope].
  Future<String> getDeletionDetails(SeedScope scope);

  /// Returns the confirmation for deleting all seed data.
  Future<String> getDeleteAllDetails();

  /// Restores known settings to their default values from the fixtures.
  Future<void> resetSettings();

  /// Seeds every scope after confirming that they are all empty.
  Future<void> seedAll();

  /// Deletes every scope after checking the expected counts.
  Future<void> deleteAll({Map<SeedScope, int>? expectedCounts});
}

abstract interface class _SeedScopeMutator {
  Future<_SeedScopeDeletionImpact> getDeletionImpact();

  Future<void> seed();

  Future<void> deleteAll();
}

class _SeedScopeDeletionImpact {
  const _SeedScopeDeletionImpact({
    required this.deletedRowsByScope,
    this.effects = const [],
  });

  final Map<SeedScope, int> deletedRowsByScope;
  final List<_DeletionEffect> effects;
}

class _DeletionEffect {
  const _DeletionEffect(this.label, this.count);

  final String label;
  final int count;
}

Map<SeedScope, int> _createEmptyDeletedRowsByScope() {
  return {for (final scope in SeedScope.values) scope: 0};
}
