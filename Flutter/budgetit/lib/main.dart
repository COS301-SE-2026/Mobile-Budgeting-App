import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';
import 'features/auth/data/cognito_auth_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_register_screen.dart';
import 'package:budgetit/views/transaction_manager/transaction_manager.dart';
import 'shared/widgets/main_scaffold.dart';
import 'shared/widgets/main_appbar.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'views/budget_manager/budget_manager_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppAuthProvider(authService: CognitoAuthService()),
      child: const BudgetApp(),
    ),
  );
}

Future<void> _configureAmplify() async {
  try {
    final authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugin(authPlugin);
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {}
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: {'/transaction_manager': (context) => const TransactionManager()},
      home: const AuthGate(), // 👈 Auth gate sits in front
    );
  }
}

// AuthGate decides what the user sees first
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();

    switch (auth.status) {
      case AuthStatus.unknown:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.guest:
        return const LoginRegisterScreen(); // 👈 Shows login/onboarding
      case AuthStatus.authenticated:
      default:
        return const HomePage(); // 👈 Your existing home page
    }
  }
}

// ---- Your existing HomePage below, unchanged ----

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


  setState(() {
    _selectedIndex = index;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(),
      body: _pages[_selectedIndex],
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
