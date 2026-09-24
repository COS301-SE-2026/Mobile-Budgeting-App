import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/native.dart';


Widget appPreview({required Widget child, bool database = false}) {
  return Builder(
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(isDark: isDark)),
          if (database)
            Provider<AppDatabase>(
              create: (_) => AppDatabase.forTesting(NativeDatabase.memory()),
              dispose: (_, value) => value.close(),
            ),
        ],
        child: child,
      );
    },
  );
}
