import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const _green = Color(0xFF04240C);
  static const _cream = Color(0xFFDDD6AE);
  static const _glassColor = Color(0x22DDD6AE);
  static const _glassBorder = Color(0x44DDD6AE);

  // Step 0 = enter email, Step 1 = enter code + new password
  int _step = 0;

  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmVisible = false;
  String? _submittedEmail;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: _green,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildBackButton(context),
              const SizedBox(height: 48),
              _buildHeader(),
              const SizedBox(height: 32),
              _buildCard(auth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text('Back', style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _step == 0 ? 'Reset Password' : 'Enter New Password',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _step == 0
              ? 'Enter your email and we\'ll send you a reset code.'
              : 'Enter the code sent to $_submittedEmail and choose a new password.',
          style: const TextStyle(color: Colors.white60, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildCard(AuthProvider auth) {
    return Container(
      decoration: BoxDecoration(
        color: _glassColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _glassBorder),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (_step == 0) _buildStep0(auth),
          if (_step == 1) _buildStep1(auth),
        ],
      ),
    );
  }

  // --- Step 0: Email input ---
  Widget _buildStep0(AuthProvider auth) {
    return Column(
      children: [
        _buildTextField(
          controller: _emailController,
          hint: 'Your email address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        if (auth.errorMessage != null) _buildError(auth),
        _buildButton(
          label: 'Send Reset Code →',
          isLoading: auth.isLoading,
          onPressed: () => _handleSendCode(auth),
        ),
      ],
    );
  }

  // --- Step 1: Code + new password ---
  Widget _buildStep1(AuthProvider auth) {
    return Column(
      children: [
        _buildTextField(
          controller: _codeController,
          hint: '6-digit code',
          icon: Icons.pin_outlined,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _newPasswordController,
          hint: 'New password',
          icon: Icons.lock_outline,
          obscure: !_passwordVisible,
          suffix: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility_off : Icons.visibility,
              color: _cream,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _passwordVisible = !_passwordVisible),
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _confirmPasswordController,
          hint: 'Confirm new password',
          icon: Icons.lock_outline,
          obscure: !_confirmVisible,
          suffix: IconButton(
            icon: Icon(
              _confirmVisible ? Icons.visibility_off : Icons.visibility,
              color: _cream,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _confirmVisible = !_confirmVisible),
          ),
        ),
        const SizedBox(height: 16),
        if (auth.errorMessage != null) _buildError(auth),
        _buildButton(
          label: 'Reset Password →',
          isLoading: auth.isLoading,
          onPressed: () => _handleConfirmReset(auth),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
    List<TextInputFormatter>? inputFormatters,
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
        inputFormatters: inputFormatters,
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

  Widget _buildError(AuthProvider auth) {
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
            const Icon(Icons.error_outline,
                color: Color(0xFFCF6679), size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                auth.errorMessage!,
                style:
                    const TextStyle(color: Color(0xFFCF6679), fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _cream,
          foregroundColor: _green,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: const Color(0x88DDD6AE),
        ),
        child: isLoading
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

  Future<void> _handleSendCode(AuthProvider auth) async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }
    final success = await auth.resetPassword(email);
    if (success && mounted) {
      setState(() {
        _submittedEmail = email;
        _step = 1;
      });
      auth.clearError();
    }
  }

  Future<void> _handleConfirmReset(AuthProvider auth) async {
    final code = _codeController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit code')),
      );
      return;
    }
    if (newPassword != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    if (newPassword.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password must be at least 8 characters')),
      );
      return;
    }

    final success = await auth.confirmResetPassword(
      _submittedEmail!,
      newPassword,
      code,
    );
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully. Please log in.'),
          backgroundColor: Color(0xFF04240C),
        ),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}