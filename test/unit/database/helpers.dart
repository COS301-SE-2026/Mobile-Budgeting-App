import 'dart:ffi';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:budgetit/database/app_database.dart';

/// Call once per test file (e.g. in setUpAll) to ensure the SQLite shared
/// library can be found on all Linux distributions.
///
/// On Fedora/RHEL the unversioned libsqlite3.so symlink is only present when
/// sqlite-devel is installed, but libsqlite3.so.0 is always available.
void configureSqliteForTests() {
  if (Platform.isLinux) {
    open.overrideFor(OperatingSystem.linux, () {
      for (final lib in ['libsqlite3.so', 'libsqlite3.so.0']) {
        try {
          return DynamicLibrary.open(lib);
        } catch (_) {}
      }
      throw UnsupportedError(
        'Could not load SQLite. '
        'Install sqlite-devel (Fedora/RHEL) or libsqlite3-dev (Debian/Ubuntu).',
      );
    });
  }
}

/// Opens a fresh in-memory SQLite database for a single test.
/// Call [AppDatabase.close] in tearDown.
AppDatabase openTestDatabase() =>
    AppDatabase.forTesting(NativeDatabase.memory());

/// Waits long enough for a subsequent DB write to receive a later [updatedAt].
///
/// Drift stores DateTime as INTEGER milliseconds since epoch. A 1-second delay
/// is conservative but avoids any risk of equal timestamps on slow machines.
Future<void> waitForNextSecond() => Future.delayed(const Duration(seconds: 1));
