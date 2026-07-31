import 'dart:async';
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
import 'models/recurring/recurring_transaction_catch_up_result.dart';
import 'services/recurring/recurring_transaction_catch_up_service.dart';
import 'views/dashboard/dashboard.dart';
import 'shared/widgets/login_password_screen.dart';
import 'utils/theme_provider.dart';
import 'shared/widgets/main_appbar.dart';
import 'utils/app_colour.dart';
import 'views/budget_manager/budget_manager_screen.dart';
import 'package:budgetit/services/analysis/background_anomaly_scanner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  const skipReseed = bool.fromEnvironment('SKIP_RESEED', defaultValue: false);
  final shouldReseed = kDebugMode && !skipReseed;
  final db = await AppDatabase.create(reset: shouldReseed);
  if (shouldReseed) await DatabaseSeeder(db).seed();
  if (kDebugMode) {
    unawaited(db.startDriftViewer(enabled: true));
  }

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => db,
          dispose: (_, db) => db.close(),
        ),
        Provider<RecurringTransactionCatchUpService>(
          create: (context) =>
              RecurringTransactionCatchUpService(context.read<AppDatabase>()),
        ),
        ChangeNotifierProvider(
          //USED DEEPSEEK TO FIX CONTEXT ERRORS
          create: (_) => AppAuthProvider(authService: CognitoAuthService()),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) =>
              BackgroundAnomalyScanner(context.read<AppDatabase>()),
        ),
      ],
      child: const BudgetApp(),
    ),
  );
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {}
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

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
        return const Scaffold(
          backgroundColor: Color(0xFF04240C),
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFFDDD6AE)),
          ),
        );
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

    return Scaffold(
      appBar: const MainAppbar(),
      body: _buildPages(db)[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          backgroundColor: context.colours.background,
          indicatorColor: context.colours.secondary,
          onDestinationSelected: _onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.attach_money),
              selectedIcon: Icon(Icons.attach_money),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.pie_chart_outline),
              selectedIcon: Icon(Icons.pie_chart),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPages(AppDatabase db) {
    return [
      const Dashboard(),
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
