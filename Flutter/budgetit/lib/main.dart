import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/data/auth_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_register_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(
        authService: MockAuthService(),
      ),
      child: const BudgetItApp(),
    ),
  );
}

class BudgetItApp extends StatelessWidget {
  const BudgetItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    final auth = context.watch<AuthProvider>();

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

    // loggedIn or skipped — show home
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
              onPressed: () => context.read<AuthProvider>().signOut(),
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
                    context.read<AuthProvider>().backToLogin(),
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