import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/open.dart';

import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/main.dart';

AppDatabase _openTestDatabase() {
  if (Platform.isLinux) {
    open.overrideFor(OperatingSystem.linux, () {
      for (final lib in ['libsqlite3.so', 'libsqlite3.so.0']) {
        try {
          return DynamicLibrary.open(lib);
        } catch (_) {}
      }
      throw UnsupportedError('Could not load SQLite.');
    });
  }
  return AppDatabase.forTesting(NativeDatabase.memory());
}

void main() {
  testWidgets('App launches and navigates between main screens', (
    WidgetTester tester,
  ) async {
    final db = _openTestDatabase();
    addTearDown(db.close);

    await tester.pumpWidget(BudgetApp(db: db));
    await tester.pumpAndSettle();

    // The app should start with the shared bottom navigation.
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(3));

    // Go to transactions screen.
    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    // Go to budget manager screen.
    await tester.tap(find.byType(NavigationDestination).at(2));
    await tester.pumpAndSettle();

    expect(find.text('MONTHLY SPENDING'), findsOneWidget);
    expect(find.text('Budget Categories'), findsOneWidget);
    expect(find.text('CREATE NEW BUDGET'), findsOneWidget);

    // Go back to dashboard.
    await tester.tap(find.byType(NavigationDestination).at(0));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
