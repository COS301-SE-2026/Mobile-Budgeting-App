import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/providers/auth_provider.dart';
import 'verify_email_screen.dart';
import 'forgot_password_screen.dart';
import 'coming_soon_page.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  // 0 = Login, 1 = Register
  int _selectedTab = 0;

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // Colours
  static const _green = Color(0xFF04240C);
  static const _cream = Color(0xFFDDD6AE);
  static const _glassColor = Color(0x22DDD6AE); // cream at ~13% opacity
  static const _glassBorder = Color(0x44DDD6AE); // cream at ~27% opacity

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();

    return Scaffold(
      backgroundColor: _green,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildCard(auth),
                    const SizedBox(height: 32),
                    _buildBiometricRow(),
                    const SizedBox(height: 16),
                    _buildSecureBadge(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Top Bar ---
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ComingSoonPage(
                  title: 'Menu Coming Soon',
                  message:
                      'The main menu is still being prepared. More navigation options will be added here soon.',
                  icon: Icons.menu,
                ),
              ),
            ),
          ),
          const Text(
            'Budget IT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ComingSoonPage(
                  title: 'Settings Coming Soon',
                  message:
                      'App settings are still under development. Soon you will be able to customise your preferences here.',
                  icon: Icons.settings_outlined,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Header ---
  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          _selectedTab == 0 ? 'Welcome Back' : 'Create Account',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Secure your financial future with precision.',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // --- Glass Card ---
  Widget _buildCard(AppAuthProvider auth) {
    return Container(
      decoration: BoxDecoration(
        color: _glassColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _glassBorder, width: 1),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildTabSwitcher(),
          const SizedBox(height: 24),
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          if (_selectedTab == 1) ...[
            const SizedBox(height: 16),
            _buildConfirmPasswordField(),
          ],
          if (_selectedTab == 0) ...[
            const SizedBox(height: 8),
            _buildForgotPassword(),
          ],
          const SizedBox(height: 24),
          if (auth.errorMessage != null) _buildErrorMessage(auth),
          _buildPrimaryButton(auth),
          const SizedBox(height: 16),
          _buildDivider(),
          const SizedBox(height: 16),
          _buildGuestButton(auth),
        ],
      ),
    );
  }

  // --- Tab Switcher ---
  Widget _buildTabSwitcher() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x33DDD6AE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildTab('Login', 0),
          _buildTab('Register', 1),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
            _emailController.clear();
            _passwordController.clear();
            _confirmPasswordController.clear();
          });
          context.read<AppAuthProvider>().clearError();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? _cream : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? _green : _cream,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // --- Email Field ---
  Widget _buildEmailField() {
    return _buildTextField(
      controller: _emailController,
      hint: 'wealth@budgetit.com',
      icon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
    );
  }

  // --- Password Field ---
  Widget _buildPasswordField() {
    return _buildTextField(
      controller: _passwordController,
      hint: '••••••••',
      icon: Icons.lock_outline,
      obscure: !_passwordVisible,
      suffix: IconButton(
        icon: Icon(
          _passwordVisible ? Icons.visibility_off : Icons.visibility,
          color: _cream,
          size: 20,
        ),
        onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
      ),
    );
  }

  // --- Confirm Password Field ---
  Widget _buildConfirmPasswordField() {
    return _buildTextField(
      controller: _confirmPasswordController,
      hint: 'Confirm password',
      icon: Icons.lock_outline,
      obscure: !_confirmPasswordVisible,
      suffix: IconButton(
        icon: Icon(
          _confirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
          color: _cream,
          size: 20,
        ),
        onPressed: () => setState(
            () => _confirmPasswordVisible = !_confirmPasswordVisible),
      ),
    );
  }

  // --- Reusable Text Field ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x1ADDD6AE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _glassBorder),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(icon, color: _cream, size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  // --- Forgot Password ---
  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ForgotPasswordScreen(),
          ),
        ),
        child: const Text(
          'Forgot?',
          style: TextStyle(
            color: Color(0xFFDDD6AE),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // --- Error Message ---
  Widget _buildErrorMessage(AppAuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0x33CF6679),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFCF6679)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFCF6679), size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                auth.errorMessage!,
                style: const TextStyle(color: Color(0xFFCF6679), fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Primary Button ---
  Widget _buildPrimaryButton(AppAuthProvider auth) {
    final label = _selectedTab == 0 ? 'Login →' : 'Register →';
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: auth.isLoading ? null : () => _handleSubmit(auth),
        style: ElevatedButton.styleFrom(
          backgroundColor: _cream,
          foregroundColor: _green,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: const Color(0x88DDD6AE),
        ),
        child: auth.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF04240C),
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
      ),
    );
  }

  // --- Divider ---
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white24)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('OR', style: TextStyle(color: Colors.white38, fontSize: 12)),
        ),
        Expanded(child: Divider(color: Colors.white24)),
      ],
    );
  }

  // --- Guest Button ---
  Widget _buildGuestButton(AppAuthProvider auth) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: auth.isLoading
            ? null
            : () => context.read<AppAuthProvider>().continueAsGuest(),
        style: OutlinedButton.styleFrom(
          foregroundColor: _cream,
          side: const BorderSide(color: Color(0x88DDD6AE)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Continue as Guest',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  // --- Biometric Row ---
  Widget _buildBiometricRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBiometricIcon(Icons.fingerprint),
        const SizedBox(width: 24),
        _buildBiometricIcon(Icons.face_outlined),
      ],
    );
  }

  Widget _buildBiometricIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _glassColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _glassBorder),
      ),
      child: Icon(icon, color: _cream, size: 28),
    );
  }

  // --- Secure Badge ---
  Widget _buildSecureBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.lock, color: Colors.white38, size: 12),
        SizedBox(width: 6),
        Text(
          'SECURE END-TO-END ENCRYPTION',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 10,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  // --- Handle Submit ---
  Future<void> _handleSubmit(AppAuthProvider auth) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (_selectedTab == 0) {
      // Login
      await auth.signIn(email, password);
      if (!mounted) return;
      if (auth.needsVerification) {
        // User exists but never confirmed — route to verify screen.
        // A fresh code has already been requested by the service layer.
        auth.clearNeedsVerification();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyEmailScreen(email: email),
          ),
        );
      }
    } else {
      // Register
      final confirm = _confirmPasswordController.text;
      if (password != confirm) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }
      if (password.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password must be at least 8 characters')),
        );
        return;
      }
      final success = await auth.signUp(email, password);
      if (success && mounted) {
        auth.clearNeedsVerification();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyEmailScreen(email: email),
          ),
        );
      }
    }
  }
}