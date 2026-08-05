import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/database_seeder.dart';
import 'package:budgetit/database/schema.dart';
import '../database/helpers.dart';


void _mockAssetBundle(Map<String, String> assets) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/assets', (ByteData? message) async {
    final key = utf8.decode(message!.buffer.asUint8List());
    final content = assets[key];
    if (content == null) { throw FlutterError('Unable to load asset: $key');}
    final bytes = utf8.encode(content);
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  });
}

void _clearMockAssetBundle() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/assets', null);
}

const _settingsJson = '''
[
  { "key": "default_currency", "value": "ZAR" },
  { "key": "theme_mode", "value": "dark" }
]
''';

const _categoriesJson = '''
[
  { "name": "Groceries", "type": "expense" },
  { "name": "Rent", "type": "expense" },
  { "name": "Transport", "type": "expense" },
  { "name": "Salary", "type": "income" },
  { "name": "Freelance", "type": "income" }
]
''';

const _budgetTemplatesJson = '''
[
  { "category_name": "Groceries", "amount": "2000.00", "period_type": "monthly", "currency": "ZAR" },
  { "category_name": "Rent", "amount": "8000.00", "period_type": "monthly", "currency": "ZAR" },
  { "category_name": "NotACategory", "amount": "10.00", "period_type": "monthly", "currency": "ZAR" }
]
''';

const _transactionsJson = '''
[
  {
    "amount": "25000.00",
    "type": "income",
    "short_description": "May salary",
    "transaction_date": "2026-05-01T08:00:00.000Z",
    "currency": "ZAR",
    "category_name": "Salary"
  },
  {
    "amount": "8000.00",
    "type": "expense",
    "short_description": "May rent",
    "transaction_date": "2026-05-01T09:00:00.000Z",
    "currency": "ZAR",
    "category_name": "Rent"
  },
  {
    "amount": "50.00",
    "type": "expense",
    "short_description": "Uncategorised expense",
    "transaction_date": "2026-05-02T09:00:00.000Z",
    "currency": "ZAR",
    "category_name": "Category That Does Not Exist"
  }
]
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  configureSqliteForTests();

  late AppDatabase db;

  setUp(() {
    db = openTestDatabase();
    _mockAssetBundle({
      'assets/seeds/settings.json': _settingsJson,
      'assets/seeds/categories.json': _categoriesJson,
      'assets/seeds/budget_templates.json': _budgetTemplatesJson,
      'assets/seeds/transactions.json': _transactionsJson,
    });
  });

  tearDown(() async {
    _clearMockAssetBundle();
    await db.close();
  });


   group('DatabaseSeeder', () {
    test('seeds all settings entries', () async {
      final seeder = DatabaseSeeder(db);
      await seeder.seed();
      final settings = await db.select(db.appSettings).get();
      final asMap = {for (final s in settings) s.key: s.value};

      expect(asMap['default_currency'], equals('ZAR'));
      expect(asMap['theme_mode'], equals('dark'));
    });

    test('seeds all categories with correct types', () async {
      final seeder = DatabaseSeeder(db);
      await seeder.seed();
      final categories = await db.select(db.categories).get();

      expect(categories.length, equals(5));
      final groceries = categories.firstWhere((c) => c.name == 'Groceries');
      expect(groceries.type, equals(CategoryType.expense));
      expect(groceries.isDefault, isTrue);
      final salary = categories.firstWhere((c) => c.name == 'Salary');
      expect(salary.type, equals(CategoryType.income));
    });

    test('seeds budget templates and links them to the correct category id', () async {
      final seeder = DatabaseSeeder(db);
      await seeder.seed();
      final categories = await db.select(db.categories).get();
      final groceriesId = categories.firstWhere((c) => c.name == 'Groceries').id;
      final templates = await db.select(db.budgetTemplates).get();
      final groceriesTemplate = templates.firstWhere((t) => t.categoryId == groceriesId);

      expect(groceriesTemplate.amount.toString(), equals('2000.00'));
      expect(groceriesTemplate.periodType, equals(PeriodType.monthly));
    });

    test('skips budget templates whose category_name has no matching seeded category', () async {
      final seeder = DatabaseSeeder(db);
      await seeder.seed();
      final templates = await db.select(db.budgetTemplates).get();

      expect(templates.length, equals(2));
    });

    test('seeds transactions and assigns categories where a match exists', () async {
      final seeder = DatabaseSeeder(db);
      await seeder.seed();
      final transactions = await db.select(db.transactions).get();
      expect(transactions.length, equals(3));
      final salaryTx = transactions.firstWhere((t) => t.shortDescription == 'May salary');
      expect(salaryTx.type, equals(TransactionType.income));
      expect(salaryTx.amount.toString(), equals('25000.00'));

      final categoryMaps = await db.select(db.transactionCategoryMap).get();
      final salaryMapping = categoryMaps.firstWhere((m) => m.transactionId == salaryTx.id);
      final categories = await db.select(db.categories).get();
      final salaryCategoryId = categories.firstWhere((c) => c.name == 'Salary').id;

      expect(salaryMapping.categoryId, equals(salaryCategoryId));
      expect(salaryMapping.assignmentSource, equals(AssignmentSource.manual));
    });

    test('transaction with unmatched category_name is inserted but left uncategorised', () async {
      final seeder = DatabaseSeeder(db);
      await seeder.seed();
      final transactions = await db.select(db.transactions).get();
      final uncategorised = transactions.firstWhere((t) => t.shortDescription == 'Uncategorised expense');
      final categoryMaps = await db.select(db.transactionCategoryMap).get();
      final hasMapping = categoryMaps.any((m) => m.transactionId == uncategorised.id);

      expect(hasMapping, isFalse);
    });

    test('seed() runs steps in dependency order without throwing', () async {
      final seeder = DatabaseSeeder(db);
      await expectLater(seeder.seed(), completes);
    });
  });
}