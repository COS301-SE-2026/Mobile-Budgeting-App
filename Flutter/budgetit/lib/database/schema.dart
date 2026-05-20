import 'package:drift/drift.dart';
import 'package:decimal/decimal.dart';
// ── Enums ──

enum CategoryType { income, expense }

enum TransactionType { income, expense }

enum TransactionSource { manual, import, recurring }

enum AssignmentSource { manual, ai, import }

enum PeriodType { daily, weekly, monthly, yearly }

/*
SQLite does not have a built-in decimal type.
Dart makes use of custom column types to automatically convert Decimal values
to and from SQLite's TEXT type.
*/

class DecimalConverter extends TypeConverter<Decimal, String> {
  // Convert to Decimal from SQLite's TEXT type
  @override
  Decimal fromSql(String fromDb) => Decimal.parse(fromDb);

  // Convert to SQLite's TEXT type from Decimal
  @override
  String toSql(Decimal value) => value.toString();
}

// ── Tables ──

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => textEnum<CategoryType>()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
  BoolColumn get isDefault => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class CategoryClosure extends Table {
  TextColumn get ancestorId => text().references(Categories, #id)();
  TextColumn get descendantId => text().references(Categories, #id)();
  IntColumn get depth => integer()();

  @override
  Set<Column> get primaryKey => {ancestorId, descendantId};
}

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get amount => text().map(DecimalConverter())();
  TextColumn get type => textEnum<TransactionType>()();
  TextColumn get shortDescription => text()();
  TextColumn get longDescription => text().nullable()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get source => textEnum<TransactionSource>()();
  TextColumn get currency => text().withDefault(const Constant('ZAR'))();

  @override
  Set<Column> get primaryKey => {id};
}

class TransactionCategoryMap extends Table {
  TextColumn get transactionId => text().references(Transactions, #id)();
  TextColumn get categoryId => text().references(Categories, #id)();
  DateTimeColumn get assignedAt => dateTime()();
  TextColumn get assignmentSource => textEnum<AssignmentSource>()();

  @override
  Set<Column> get primaryKey => {transactionId};
}

class BudgetTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get amount => text().map(DecimalConverter())();
  TextColumn get periodType => textEnum<PeriodType>()();
  TextColumn get currency => text().withDefault(const Constant('ZAR'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class BudgetPeriods extends Table {
  TextColumn get id => text()();
  TextColumn get templateId => text().references(BudgetTemplates, #id)();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get budgetedAmount => text().map(DecimalConverter())();
  BoolColumn get isOverridden => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}
