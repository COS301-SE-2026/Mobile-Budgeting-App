import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:budgetit/views/transaction_manager/transaction.manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saropa_drift_advisor/saropa_drift_advisor.dart';
import 'amplifyconfiguration.dart';
import 'auth/data/cognito_auth_service.dart';
import 'auth/providers/auth_provider.dart';
import 'database/app_database.dart';
import 'database/database_seeder.dart';
import 'database/powersync_schema.dart';
import 'models/recurring/recurring_transaction_catch_up_result.dart';
import 'services/analysis/background_anomaly_scanner.dart';
import 'services/recurring/recurring_transaction_catch_up_service.dart';
import 'synch/backendconnector.dart';
import 'views/dashboard/dashboard.dart';
import 'shared/widgets/login_password_screen.dart';
import 'shared/widgets/biometric_lock_screen.dart';
import 'utils/theme_provider.dart';
import 'shared/widgets/main_appbar.dart';
import 'shared/widgets/splash_screen.dart';
import 'shared/widgets/biometric_lock_screen.dart';
import 'utils/app_colour.dart';
import 'views/budget_manager/budget_manager_screen.dart';
import 'package:budgetit/services/analysis/background_anomaly_scanner.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
//import 'package:flutter_gemma_litertlm/flutter_gemma_litertlm.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:flutter_gemma_mediapipe/flutter_gemma_mediapipe.dart';
import 'services/import/llm_schema_classifier.dart';
import 'services/ai/transaction_classifier/bge_model_downloader.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StartupApp());
}

class StartupApp extends StatefulWidget {
  const StartupApp({super.key});

  @override
  State<StartupApp> createState() => _StartupAppState();
}

class _StartupAppState extends State<StartupApp> {
  late final Future<Widget> _app = _loadApp();

  Future<Widget> _loadApp() async {
    // Let the brand reveal finish, but keep the splash up for as long as
    // initialization and session restoration actually need.
    final results = await Future.wait<Object?>([
      _initializeApp(),
      Future<Object?>.delayed(const Duration(milliseconds: 2500)),
    ]);
    return results.first as Widget;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _app,
      builder: (context, snapshot) {
        if (snapshot.hasData) return snapshot.data!;
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Startup failed: ${snapshot.error}'),
                ),
              ),
            ),
          );
        }
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}

Future<Widget> _initializeApp() async {
  pdfrxFlutterInitialize();
  await _configureAmplify();
  const skipReseed = bool.fromEnvironment('SKIP_RESEED', defaultValue: false);
  final shouldReseed = kDebugMode && !skipReseed;

  final powerSyncDb = await _openPowerSyncDatabase(reset: shouldReseed);
  final db = AppDatabase(powerSyncDb);

  // Initialise the local schema before seeding, so the tables exist when the
  // seeder writes to them. Syncing is started separately once the user signs in.
  await powerSyncDb.initialize();

  if (shouldReseed) await DatabaseSeeder(db).seed();
  if (kDebugMode && !kIsWeb) {
    unawaited(db.startDriftViewer(enabled: true));
  }

  const hfToken = String.fromEnvironment('HUGGINGFACE_TOKEN');
  if (!kIsWeb) {
    FlutterGemma.initialize(
      inferenceEngines: const [MediaPipeEngine()],
      huggingFaceToken: hfToken.isNotEmpty ? hfToken : null,
    );
  }

  final authProvider = _createAuthProvider(powerSyncDb);
  await authProvider.initialSessionCheck;

  return MultiProvider(
    providers: [
      Provider<AppDatabase>(create: (_) => db, dispose: (_, db) => db.close()),
      Provider<RecurringTransactionCatchUpService>(
        create: (context) =>
            RecurringTransactionCatchUpService(context.read<AppDatabase>()),
      ),
      ChangeNotifierProvider(create: (_) => authProvider),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(
        create: (context) =>
            BackgroundAnomalyScanner(context.read<AppDatabase>()),
      ),
    ],
    child: const BudgetApp(),
  );
}

Future<PowerSyncDatabase> _openPowerSyncDatabase({required bool reset}) async {
  if (kIsWeb) {
    // PowerSync stores this named database in browser storage on the web.
    return PowerSyncDatabase(schema: powerSyncSchema, path: 'budgetit.db');
  }
  final directory = await getApplicationDocumentsDirectory();
  final file = File(p.join(directory.path, 'budgetit.db'));
  if (reset && await file.exists()) {
    await file.delete();
  }
  return PowerSyncDatabase(schema: powerSyncSchema, path: file.path);
}

/// Creates the auth provider and keeps PowerSync in sync with the auth state.
///
/// PowerSync only connects once the user is signed in, and disconnects on
/// sign-out — so it doesn't repeatedly fail to fetch a JWT while the user is
/// a guest (which is what produced the recurring "JWT is null" errors).
AppAuthProvider _createAuthProvider(PowerSyncDatabase powerSyncDb) {
  final authProvider = AppAuthProvider(authService: CognitoAuthService());

  AuthStatus? lastSyncedStatus;
  void syncWithAuthStatus() {
    final status = authProvider.status;
    if (status == lastSyncedStatus) return;
    lastSyncedStatus = status;
    if (status == AuthStatus.loggedIn) {
      unawaited(powerSyncDb.connect(connector: PSyncConnector()));
    } else {
      unawaited(powerSyncDb.disconnect());
    }
  }

  authProvider.addListener(syncWithAuthStatus);
  // Handle the current status in case the session check already resolved
  // before this listener was attached.
  syncWithAuthStatus();
  return authProvider;
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {}
}

class BudgetApp extends StatefulWidget {
class BudgetApp extends StatefulWidget {
  const BudgetApp({super.key});

  @override
  State<BudgetApp> createState() => _BudgetAppState();
}

class _BudgetAppState extends State<BudgetApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      context.read<AppAuthProvider>().lock();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        extensions: [MyColours.lightTheme],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        extensions: [MyColours.darkTheme],
      ),
      initialRoute: '/',
      routes: {'/transaction_manager': (context) => const TransactionManager()},
      home: const AuthWrapper(),
      builder: (context, child) {
        final locked =
            context.watch<AppAuthProvider>().status == AuthStatus.locked;
        return Stack(
          children: [
            if (child != null) child,
            if (locked) const BiometricLockScreen(),
          ],
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    final auth = context.watch<AppAuthProvider>();

    switch (auth.status) {
      case AuthStatus.unknown:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.locked:
        return const SplashScreen();
      case AuthStatus.guest:
        return const LoginRegisterScreen();
      case AuthStatus.skipped:
      case AuthStatus.loggedIn:
        return const HomePage();
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_runRecurringTransactionCatchUp());
      if (!kIsWeb) {
        unawaited(LlmSchemaClassifier.ensureModelDownloaded());
        unawaited(BgeModelDownloader.ensureModelDownloaded());
      }
    });
  }

  Future<void> _runRecurringTransactionCatchUp() async {
    final result = await context
        .read<RecurringTransactionCatchUpService>()
        .catchUpDueRecurringTransactions(trigger: CatchUpTrigger.startup);

    debugPrint('[Recurring catch-up] $result');
    for (final template in result.templates) {
      debugPrint('[Recurring catch-up] $template');
      for (final occurrence in template.occurrences) {
        debugPrint('[Recurring catch-up] $occurrence');
        final failure = occurrence.failure;
        if (failure != null) {
          debugPrintStack(
            label: '[Recurring catch-up] ${failure.type}: ${failure.message}',
            stackTrace: failure.stackTrace,
          );
        }
      }
    }

    final runFailure = result.runFailure;
    if (runFailure != null) {
      debugPrintStack(
        label: '[Recurring catch-up] ${runFailure.type}: ${runFailure.message}',
        stackTrace: runFailure.stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();

    final db = context.read<AppDatabase>();
    final selectedNavIconColor = Theme.of(context).brightness == Brightness.dark
        ? context.colours.background
        : context.colours.cardText;
    final unselectedNavIconColor = context.colours.cardText;

    return Scaffold(
      appBar: const MainAppbar(),
      body: _buildPages(db)[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: context.colours.category, width: 4),
          ),
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            height: 60,
            selectedIndex: _selectedIndex,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? context.colours.background
                : context.colours.blendedprimary,
            indicatorColor: context.colours.secondary,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: context.colours.category, width: 3),
            ),
            onDestinationSelected: _onDestinationSelected,
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.home_outlined,
                  color: unselectedNavIconColor,
                  size: 26,
                ),
                selectedIcon: Icon(
                  Icons.home,
                  color: selectedNavIconColor,
                  size: 26,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.attach_money,
                  color: unselectedNavIconColor,
                  size: 26,
                ),
                selectedIcon: Icon(
                  Icons.attach_money,
                  color: selectedNavIconColor,
                  size: 26,
                ),
                label: 'Transactions',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.pie_chart_outline,
                  color: unselectedNavIconColor,
                  size: 26,
                ),
                selectedIcon: Icon(
                  Icons.pie_chart,
                  color: selectedNavIconColor,
                  size: 26,
                ),
                label: 'Budgets',
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPages(AppDatabase db) {
    return [
      Dashboard(onViewTransactions: () => _onDestinationSelected(1)),
      const TransactionManager(),
      BudgetManagerScreen(database: db),
    ];
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
