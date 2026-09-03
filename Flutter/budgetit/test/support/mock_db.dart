import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/utils/theme_provider.dart';

import '../unit/database/mock_daos.mocks.dart';

class MockDb {
  MockDb()
    : db = MockAppDatabase(),
      transactionDao = MockTransactionDao(),
      categoryDao = MockCategoryDao(),
      budgetDao = MockBudgetDao(),
      settingsDao = MockSettingsDao(),
      recurringTransactionDao = MockRecurringTransactionDao() {
    when(db.transactionDao).thenReturn(transactionDao);
    when(db.categoryDao).thenReturn(categoryDao);
    when(db.budgetDao).thenReturn(budgetDao);
    when(db.settingsDao).thenReturn(settingsDao);
    when(db.recurringTransactionDao).thenReturn(recurringTransactionDao);
  }

  final MockAppDatabase db;
  final MockTransactionDao transactionDao;
  final MockCategoryDao categoryDao;
  final MockBudgetDao budgetDao;
  final MockSettingsDao settingsDao;
  final MockRecurringTransactionDao recurringTransactionDao;
}

Widget wrapWithProviders(Widget child, {required AppDatabase db}) =>
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MaterialApp(home: child),
    );

Widget wrapWithTheme(Widget child, {bool wrapInScaffold = true}) =>
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MaterialApp(home: wrapInScaffold ? Scaffold(body: child) : child),
    );