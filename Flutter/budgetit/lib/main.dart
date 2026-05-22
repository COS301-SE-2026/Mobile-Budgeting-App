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
import 'screens/dashboard.dart';
import 'screens/login_password_screen.dart';
import 'utils/theme_provider.dart';

import 'shared/widgets/main_appbar.dart';

import 'package:budgetit/utils/app_colour.dart';
import 'views/budget_manager/budget_manager_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  const skipReseed = bool.fromEnvironment('SKIP_RESEED', defaultValue: false);
  final shouldReseed = kDebugMode && !skipReseed;
  final db = await AppDatabase.create(reset: shouldReseed);
  if (shouldReseed) await DatabaseSeeder(db).seed();
  runApp(BudgetApp(db: db));
  if (kDebugMode) {
    unawaited(db.startDriftViewer(enabled: true));
  }
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {
    // Already configured — safe to ignore.
  }
}

class BudgetApp extends StatelessWidget {
  final AppDatabase db;

  const BudgetApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => db,
          dispose: (_, db) => db.close(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppAuthProvider(authService: CognitoAuthService()),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BudgetIt',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/transaction_manager': (context) => const TransactionManager(),
        },
        home: const AuthWrapper(),
      ),
    );
  }
}

// Separate stateful widget for the home screen with bottom navigation
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Dashboard(),
    const TransactionManager(),
    BudgetManagerScreen(),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>(); // rebuild navigation bar + appbar on theme change
    return Scaffold(
      appBar: MainAppbar(),
      body: _pages[_selectedIndex], // Show the selected page
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border(
            top: BorderSide(color: MyColours().secondary, width: 1.5),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          backgroundColor: MyColours().background,
          indicatorColor: MyColours().secondary,
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
}

// Routes to the correct screen based on authentication state.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>(); // propagate theme to all descendant pages
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
