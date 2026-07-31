import 'package:drift/native.dart';
import 'package:budgetit/database/app_database.dart';

/// No op in sqlite3 ^3.x — library loading is handled by Dart now
void configureSqliteForTests() {}

/// Opens a fresh in-memory SQLite database for a single test.
/// Call [AppDatabase.close] in tearDown.
AppDatabase openTestDatabase() =>
    AppDatabase.forTesting(NativeDatabase.memory());

/// Waits long enough for a subsequent DB write to receive a later [updatedAt].
///
/// Drift stores DateTime as INTEGER milliseconds since epoch. A 1-second delay
/// is conservative but avoids any risk of equal timestamps on slow machines.
Future<void> waitForNextSecond() => Future.delayed(const Duration(seconds: 1));
