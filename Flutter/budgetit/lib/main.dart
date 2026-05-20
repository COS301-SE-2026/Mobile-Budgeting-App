import 'package:budgetit/views/transaction_manager/transaction.manager.dart';
import 'package:flutter/material.dart';
import 'shared/widgets/main_scaffold.dart';
import 'shared/widgets/main_appbar.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'views/budget_manager/budget_manager_screen.dart';

void main() {
  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});
import 'package:provider/provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';
import 'features/auth/data/cognito_auth_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppAuthProvider(
        authService: CognitoAuthService(),
      ),
      child: const BudgetItApp(),
    ),
  );
}

Future<void> _configureAmplify() async {
  try {
    final authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugin(authPlugin);
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {
    // Already configured — safe to ignore on hot restart
  }
}

class BudgetItApp extends StatelessWidget {
  const BudgetItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BudgetIt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/transaction_manager': (context) => const TransactionManager(),
      },
      home: const HomePage(),
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
    const MainScaffold(),           
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
    return Scaffold(
      appBar: MainAppbar(),
      body: _pages[_selectedIndex],   // Show the selected page
      bottomNavigationBar: Container(
  decoration: BoxDecoration(
  
    borderRadius: BorderRadius.all(Radius.circular(10)),
    border: Border(top: BorderSide(color: MyColours().secondary, width: 1.5))
    
    
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



      title: 'Budget IT',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const AuthGate(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFDDD6AE),
        onPrimary: Color(0xFF04240C),
        surface: Color(0xFF04240C),
        onSurface: Colors.white,
        secondary: Color(0xFF04240C),
        onSecondary: Colors.white,
        error: Color(0xFFCF6679),
      ),
      scaffoldBackgroundColor: const Color(0xFF04240C),
      fontFamily: 'sans-serif',
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();

    if (auth.status == AuthStatus.unknown) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFDDD6AE),
          ),
        ),
      );
    }

    if (auth.status == AuthStatus.guest) {
      return const LoginRegisterScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF04240C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF04240C),
        title: const Text(
          'Budget IT',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (auth.isLoggedIn)
            TextButton(
              onPressed: () => context.read<AppAuthProvider>().signOut(),
              child: const Text(
                'Logout',
                style: TextStyle(color: Color(0xFFDDD6AE)),
              ),
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Color(0xFFDDD6AE),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              auth.isLoggedIn
                  ? 'Welcome, ${auth.currentUser?.email ?? 'User'}'
                  : 'Browsing as Guest',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Home screen coming soon',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
            if (!auth.isLoggedIn) ...[
              const SizedBox(height: 24),
              TextButton(
                onPressed: () =>
                  context.read<AppAuthProvider>().backToLogin(),
                child: const Text(
                  'Sign in instead',
                  style: TextStyle(color: Color(0xFFDDD6AE)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
