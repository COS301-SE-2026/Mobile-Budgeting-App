import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../utils/app_colour.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  Color get _green => context.colours.primary;
  Color get _cream => context.colours.cardText;
  Color get _mutedCream => _cream.withValues(alpha: 0.7);
  Color get _borderColor => context.colours.category;

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
    final auth = context.watch<AppAuthProvider>();

    return Scaffold(
      backgroundColor: _green,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
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
                    _buildSecureBadge(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: _cream),
          ),
          Text(
            'Budget IT',
            style: context.colours.title.copyWith(color: _cream, fontSize: 20),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          _step == 0 ? 'Reset Password' : 'Enter New Password',
          textAlign: TextAlign.center,
          style: context.colours.h2.copyWith(
            color: _cream,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _step == 0
              ? 'Enter your email and we\'ll send you a reset code.'
              : 'Enter the code sent to $_submittedEmail and choose a new password.',
          textAlign: TextAlign.center,
          style: context.colours.h2.copyWith(
            color: _mutedCream,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(AppAuthProvider auth) {
    return Container(
      decoration: BoxDecoration(
        color: context.colours.blendedprimary,
        border: Border.all(color: _borderColor, width: 4),
        boxShadow: [
          BoxShadow(color: _borderColor, offset: const Offset(6, 6)),
        ],
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
  Widget _buildStep0(AppAuthProvider auth) {
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
  Widget _buildStep1(AppAuthProvider auth) {
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
            onPressed: () => setState(() => _confirmVisible = !_confirmVisible),
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
        color: _cream.withValues(alpha: 0.1),
        border: Border.all(color: _borderColor, width: 4),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        inputFormatters: inputFormatters,
        style: context.colours.h2.copyWith(
          color: _cream,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: context.colours.h2.copyWith(
            color: _mutedCream,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: _cream, size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildError(AppAuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.colours.error.withValues(alpha: 0.2),
          border: Border.all(color: context.colours.error),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: context.colours.error, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                auth.errorMessage!,
                style: context.colours.h2.copyWith(
                  color: context.colours.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
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
            side: BorderSide(color: _borderColor, width: 4),
          ),
          disabledBackgroundColor: _cream.withValues(alpha: 0.53),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _green,
                ),
              )
            : Text(
                label,
                style: context.colours.h2.copyWith(
                  color: _green,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
      ),
    );
  }

  Widget _buildSecureBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock, color: _mutedCream, size: 12),
        const SizedBox(width: 6),
        Text(
          'SECURE END-TO-END ENCRYPTION',
          style: context.colours.h2.copyWith(
            color: _mutedCream,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Future<void> _handleSendCode(AppAuthProvider auth) async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your email')));
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

  Future<void> _handleConfirmReset(AppAuthProvider auth) async {
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    if (newPassword.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 8 characters')),
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
