import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:budgetit/views/transaction_manager/transaction.manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'amplifyconfiguration.dart';
import 'auth/data/cognito_auth_service.dart';
import 'auth/providers/auth_provider.dart';
import 'screens/dashboard.dart';
import 'screens/login_password_screen.dart';
import 'utils/theme_provider.dart';

import 'shared/widgets/main_appbar.dart';

import 'package:budgetit/utils/app_colour.dart';
import 'views/budget_manager/budget_manager_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(const BudgetApp());
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
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppAuthProvider(authService: CognitoAuthService())),
      ],
      child: MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'BudgetIt',

      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),

        useMaterial3: true,
      ),

      initialRoute: '/',

      routes: {
        '/transaction_manager': (context) =>
            const TransactionManager(),
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
      body: _pages[_selectedIndex],   // Show the selected page
      bottomNavigationBar: Container(
  decoration: BoxDecoration(
  
    borderRadius: BorderRadius.all(Radius.circular(10)),
    border: Border(top: BorderSide(color: MyColours().secondary, width: 1.5))
    
    
  ),
  child: NavigationBar(
    selectedIndex: _selectedIndex,
    backgroundColor: MyColours().navBarColor,
    indicatorColor: MyColours().secondary,
  
    onDestinationSelected: _onDestinationSelected,

  
 
    destinations: [
  NavigationDestination(
    icon: const Icon(Icons.home_outlined, color: Color(0xFFDDD6AE)),
    selectedIcon: Icon(Icons.home, color: MyColours().background),
    label: '',
  ),
  NavigationDestination(
    icon: const Icon(Icons.attach_money, color: Color(0xFFDDD6AE)),
    selectedIcon: Icon(Icons.attach_money, color: MyColours().background),
    label: '',
  ),
  NavigationDestination(
    icon: const Icon(Icons.pie_chart_outline, color: Color(0xFFDDD6AE)),
    selectedIcon: Icon(Icons.pie_chart, color: MyColours().background),
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
