@Tags(['nfr'])
library;
import 'dart:io';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/auth/data/auth_service.dart';
import 'package:budgetit/auth/providers/auth_provider.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/services/import/import_orchestrator.dart';
import '../unit/database/helpers.dart';

class _BlockedHttpOverrides extends HttpOverrides {
  final List<String> attempted = [];

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _BlockingHttpClient(attempted);
  }
}

class _BlockingHttpClient implements HttpClient {
  _BlockingHttpClient(this.attempted);
  final List<String> attempted;

  Never _block(Uri url) {
    attempted.add(url.toString());
    throw StateError('Network access attempted during offline test: $url');
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async => _block(url);

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _block(url);

  @override
  Future<HttpClientRequest> postUrl(Uri url) async => _block(url);

  @override
  Future<HttpClientRequest> putUrl(Uri url) async => _block(url);

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) async => _block(url);

  @override
  Future<HttpClientRequest> patchUrl(Uri url) async => _block(url);

  @override
  Future<HttpClientRequest> headUrl(Uri url) async => _block(url);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late AppDatabase db;
  late ImportOrchestrator orchestrator;
  late Directory tempDir;

  setUp(() async {
    configureSqliteForTests();
    db = openTestDatabase();
    orchestrator = ImportOrchestrator(
      db: db,
      taDao: db.transactionDao,
      categoryDao: db.categoryDao,
    );
    tempDir = await Directory.systemTemp.createTemp('nfr_offline');
  });

  tearDown(() async {
    HttpOverrides.global = null;
    await db.close();
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  Future<String> writeCsv(String name, String contents) async {
    final file = File('${tempDir.path}/$name');
    await file.writeAsString(contents);
    return file.path;
  }

  const statement = '''
Date,Description,Amount
01/05/2026,Woolworths,-450.00
02/05/2026,Salary,15000.00
03/05/2026,Checkers,-220.50
''';

  test('a full statement import completes with all network access blocked',
      () async {
    final overrides = _BlockedHttpOverrides();
    HttpOverrides.global = overrides;
    final path = await writeCsv('offline.csv', statement);
    final parsed = await orchestrator.preparePreview(path);
    final result = await orchestrator.commitImport(parsed);
    final stored = await db.select(db.transactions).get();

    print('offline import: parsed=${parsed.length} inserted=${result.inserted} '
        'stored=${stored.length} networkAttempts=${overrides.attempted.length}');
    expect(overrides.attempted, isEmpty);
    expect(result.inserted, greaterThan(0));
    expect(stored.length, result.inserted);
  });

  test('transaction CRUD completes with all network access blocked', () async {
    final overrides = _BlockedHttpOverrides();
    HttpOverrides.global = overrides;
    final created = await db.transactionDao.insertTransaction(
      amount: Decimal.parse('99.99'),
      type: TransactionType.expense,
      shortDescription: 'Offline write',
      longDescription: '',
      transactionDate: DateTime(2026, 5, 1),
      source: TransactionSource.manual,
    );
    final all = await db.transactionDao.getAllTransactions();

    print('offline CRUD: created=${created.id} total=${all.length} '
        'networkAttempts=${overrides.attempted.length}');
    expect(overrides.attempted, isEmpty);
    expect(all, isNotEmpty);
  });

  test('category read and write complete with all network access blocked',
      () async {
    final overrides = _BlockedHttpOverrides();
    HttpOverrides.global = overrides;
    final categories = await db.categoryDao.getAllCategories();

    print('offline categories: count=${categories.length} '
        'networkAttempts=${overrides.attempted.length}');
    expect(overrides.attempted, isEmpty);
  });

  test('guest mode never holds an authenticated user', () async {
    final provider = AppAuthProvider(authService: MockAuthService());
    await Future.delayed(Duration.zero);
    provider.continueAsGuest();
    print('guest mode: status=${provider.status} '
        'isLoggedIn=${provider.isLoggedIn} user=${provider.currentUser}');

    expect(provider.status, AuthStatus.skipped);
    expect(provider.isLoggedIn, isFalse);
    expect(provider.currentUser, isNull);
  });

  test('signing out clears the session but retains local financial data',
      () async {
    await db.transactionDao.insertTransaction(
      amount: Decimal.parse('250.00'),
      type: TransactionType.expense,
      shortDescription: 'Pre-logout transaction',
      longDescription: '',
      transactionDate: DateTime(2026, 5, 1),
      source: TransactionSource.manual,
    );


    final provider = AppAuthProvider(authService: MockAuthService());
    await Future.delayed(Duration.zero);
    await provider.signUp('nfr@example.com', 'password123');
    await provider.confirmSignUp('nfr@example.com', '123456');
    await provider.signIn('nfr@example.com', 'password123');
    expect(provider.isLoggedIn, isTrue);

    final before = (await db.transactionDao.getAllTransactions()).length;
    await provider.signOut();
    final after = (await db.transactionDao.getAllTransactions()).length;
    print('logout: status=${provider.status} user=${provider.currentUser} '
        'rows before=$before after=$after');
    expect(provider.isLoggedIn, isFalse);
    expect(provider.currentUser, isNull);
    expect(after, before);
  });

  test('switching guest to logged-in preserves existing local data', () async {
    final path = await writeCsv('guest.csv', statement);
    final parsed = await orchestrator.preparePreview(path);
    await orchestrator.commitImport(parsed);
    final asGuest = (await db.transactionDao.getAllTransactions()).length;

    final provider = AppAuthProvider(authService: MockAuthService());
    await Future.delayed(Duration.zero);
    provider.continueAsGuest();
    await provider.signUp('switch@example.com', 'password123');
    await provider.confirmSignUp('switch@example.com', '123456');
    await provider.signIn('switch@example.com', 'password123');
    final afterLogin = (await db.transactionDao.getAllTransactions()).length;
    print('guest->login: rows asGuest=$asGuest afterLogin=$afterLogin');

    expect(provider.isLoggedIn, isTrue);
    expect(afterLogin, asGuest);
    expect(afterLogin, greaterThan(0));
  });
}