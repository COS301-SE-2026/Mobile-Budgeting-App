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
  { "category_name": "Not A Real Category", "amount": "10.00", "period_type": "monthly", "currency": "ZAR" }
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
}