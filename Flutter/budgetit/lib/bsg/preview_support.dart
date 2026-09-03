import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget appPreview({
  required Widget child,
  bool database = false,
  AppDatabase? appDatabase,
}) {
  return Builder(
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      assert(
        !database || appDatabase != null,
        'An AppDatabase must be provided when database is true.',
      );

      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ThemeProvider(isDark: isDark),
          ),
          if (database && appDatabase != null)
            Provider<AppDatabase>.value(
              value: appDatabase,
            ),
        ],
        child: child,
      );
    },
  );
}