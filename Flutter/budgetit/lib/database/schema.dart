/// Database schema definitions for the Budgetit application.
///
/// This file defines all tables and enums used across the application's
/// database via [Drift](https://drift.simonbinder.eu/).
library;

import 'package:drift/drift.dart';
import 'package:decimal/decimal.dart';

// ── Enums ──

/// The type of a [Categories] entry.
enum CategoryType { income, expense }

/// Whether a transaction is money coming in or going out.
enum TransactionType { income, expense }

/// How a transaction was created or imported.
enum TransactionSource { manual, import, recurring }

/// How a category was assigned to a transaction.
enum AssignmentSource { manual, ai, import }

/// The period type used by budget templates.
enum PeriodType { daily, weekly, monthly, yearly }

/// SQLite does not have a built-in decimal type.
/// Dart uses custom column types to automatically convert [Decimal] values
/// to and from SQLite's TEXT type.

/// Converts [Decimal] values to and from SQLite's TEXT type.
///
/// Drift uses this converter to persist [Decimal] values as strings
/// in the database and convert them back when reading.
class DecimalConverter extends TypeConverter<Decimal, String> {
  /// Parses a decimal from a string value read from SQLite.
  @override
  Decimal fromSql(String fromDb) => Decimal.parse(fromDb);

  /// Serializes a [Decimal] to a string for storage in SQLite.
  @override
  String toSql(Decimal value) => value.toString();
}

/// Stores category definitions used for tracking income and expenses.
///
/// Categories can be marked as [isDefault] system defaults and support
/// soft deletion via [deletedAt].
class Categories extends Table {
  /// Unique identifier for the category.
  TextColumn get id => text()();

  /// Display name of the category (e.g., 'Groceries', 'Salary').
  TextColumn get name => text()();

  /// Whether this is an income or expense category.
  TextColumn get type => textEnum<CategoryType>()();

  /// Optional icon identifier (e.g., a font icon name or emoji).
  TextColumn get icon => text().nullable()();

  /// Optional color for UI display.
  TextColumn get color => text().nullable()();

  /// Whether this is a built-in/default category.
  BoolColumn get isDefault => boolean()();

  /// When the category was created.
  DateTimeColumn get createdAt => dateTime()();

  /// When the category was last modified.
  DateTimeColumn get updatedAt => dateTime()();

  /// When the category was soft-deleted (null if active).
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Stores hierarchical relationships between categories using a closure table.
///
/// This enables efficient queries for ancestors, descendants, and subtree
/// traversal in a tree structure.
class CategoryClosure extends Table {
  /// Ancestor category ID.
  TextColumn get ancestorId => text().references(Categories, #id)();

  /// Descendant category ID.
  TextColumn get descendantId => text().references(Categories, #id)();

  /// Distance from ancestor to descendant (0 = self, 1 = direct child, etc.).
  IntColumn get depth => integer()();

  @override
  Set<Column> get primaryKey => {ancestorId, descendantId};
}

/// Stores individual income and expense transactions.
///
/// Transactions are linked to categories via [TransactionCategoryMap].
class Transactions extends Table {
  /// Unique identifier for the transaction.
  TextColumn get id => text()();

  /// Transaction amount (stored as a decimal string via [DecimalConverter]).
  TextColumn get amount => text().map(DecimalConverter())();

  /// Whether this is an income or expense transaction.
  TextColumn get type => textEnum<TransactionType>()();

  /// Short description of the transaction (max 100 chars).
  TextColumn get shortDescription => text()();

  /// Optional extended description (max 500 chars).
  TextColumn get longDescription => text().nullable()();

  /// When the transaction actually occurred.
  DateTimeColumn get transactionDate => dateTime()();

  /// When the record was created in the database.
  DateTimeColumn get createdAt => dateTime()();

  /// When the record was last modified.
  DateTimeColumn get updatedAt => dateTime()();

  /// When the transaction was soft-deleted (null if active).
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// Source of the transaction (manual, imported, recurring).
  TextColumn get source => textEnum<TransactionSource>()();

  /// Currency code for the transaction (defaults to 'ZAR').
  TextColumn get currency => text().withDefault(const Constant('ZAR'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Maps transactions to categories via a many-to-one relationship.
///
/// Each transaction can be assigned one category, with metadata about
/// how the assignment was made.
class TransactionCategoryMap extends Table {
  /// The transaction this category is assigned to.
  TextColumn get transactionId => text().references(Transactions, #id)();

  /// The assigned category.
  TextColumn get categoryId => text().references(Categories, #id)();

  /// When the assignment was made.
  DateTimeColumn get assignedAt => dateTime()();

  /// How the assignment was determined (manual, AI, import).
  TextColumn get assignmentSource => textEnum<AssignmentSource>()();

  @override
  Set<Column> get primaryKey => {transactionId};
}

/// Defines a recurring budget amount for a category over a time period.
///
/// [BudgetPeriods] are generated from a template and track actual
/// budgeted amounts for each period.
class BudgetTemplates extends Table {
  /// Unique identifier for the template.
  TextColumn get id => text()();

  /// The category this budget applies to.
  TextColumn get categoryId => text().references(Categories, #id)();

  /// The budget amount per period.
  TextColumn get amount => text().map(DecimalConverter())();

  /// How often the budget repeats (daily, weekly, monthly, yearly).
  TextColumn get periodType => textEnum<PeriodType>()();

  /// Currency code (defaults to 'ZAR').
  TextColumn get currency => text().withDefault(const Constant('ZAR'))();

  /// When the template was created.
  DateTimeColumn get createdAt => dateTime()();

  /// When the template was last modified.
  DateTimeColumn get updatedAt => dateTime()();

  /// When the template was soft-deleted (null if active).
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Represents a specific budget period generated from a [BudgetTemplates] template.
///
/// Periods can be overridden manually via [isOverridden].
class BudgetPeriods extends Table {
  /// Unique identifier for the period.
  TextColumn get id => text()();

  /// The template this period belongs to.
  TextColumn get templateId => text().references(BudgetTemplates, #id)();

  /// Start of the budgeting period.
  DateTimeColumn get startDate => dateTime()();

  /// End of the budgeting period.
  DateTimeColumn get endDate => dateTime()();

  /// The amount budgeted for this period.
  TextColumn get budgetedAmount => text().map(DecimalConverter())();

  /// Whether this period's budget has been manually overridden.
  BoolColumn get isOverridden => boolean()();

  /// When the period was created.
  DateTimeColumn get createdAt => dateTime()();

  /// When the period was last modified.
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Stores key-value settings for the application.
///
/// Common settings include default currency, theme mode, and onboarding status.
class AppSettings extends Table {
  /// Unique key for the setting (e.g., 'default_currency').
  TextColumn get key => text()();

  /// The setting value (always a string).
  TextColumn get value => text()();

  /// When the setting was last updated.
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}
