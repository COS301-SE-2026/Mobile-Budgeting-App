import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../utils/app_colour.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Color get _green => context.colours.primary;
  Color get _cream => context.colours.cardText;
  Color get _mutedCream => _cream.withValues(alpha: 0.7);
  Color get _borderColor => context.colours.category;

  // One controller per digit box
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _fullCode => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();

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
              const SizedBox(height: 48),
              _buildCodeCard(auth),
              const SizedBox(height: 32),
              _buildResendRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_ios, color: _cream, size: 16),
          const SizedBox(width: 4),
          Text('Back', style: TextStyle(color: _cream, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify your email',
          style: context.colours.h2.copyWith(
            color: _cream,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: context.colours.h2.copyWith(
              color: _mutedCream,
              fontSize: 14,
            ),
            children: [
              const TextSpan(text: 'We sent a 6-digit code to\n'),
              TextSpan(
                text: widget.email,
                style: TextStyle(color: _cream, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCodeCard(AppAuthProvider auth) {
    return Container(
      decoration: BoxDecoration(
        color: context.colours.blendedprimary,
        border: Border.all(color: _borderColor, width: 4),
        boxShadow: [BoxShadow(color: _borderColor, offset: const Offset(6, 6))],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildCodeBoxes(),
          const SizedBox(height: 24),
          if (auth.errorMessage != null) _buildError(auth),
          _buildConfirmButton(auth),
        ],
      ),
    );
  }

  Widget _buildCodeBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 44,
          height: 54,
          child: Container(
            decoration: BoxDecoration(
              color: _cream.withValues(alpha: 0.1),
              border: Border.all(color: _borderColor, width: 3),
            ),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: TextStyle(
                color: _cream,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                if (value.isNotEmpty && index < 5) {
                  // Auto-advance to next box
                  _focusNodes[index + 1].requestFocus();
                } else if (value.isEmpty && index > 0) {
                  // Go back on delete
                  _focusNodes[index - 1].requestFocus();
                }
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildError(AppAuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0x33CF6679),
          border: Border.all(color: const Color(0xFFCF6679), width: 3),
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

  Widget _buildConfirmButton(AppAuthProvider auth) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: auth.isLoading ? null : () => _handleConfirm(auth),
        style: ElevatedButton.styleFrom(
          backgroundColor: _cream,
          foregroundColor: _green,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: _borderColor, width: 4),
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
            : const Text(
                'Verify →',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
      ),
    );
  }

  Widget _buildResendRow() {
    return Center(
      child: GestureDetector(
        onTap: _handleResend,
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: _mutedCream, fontSize: 13),
            children: [
              const TextSpan(text: "Didn't receive a code? "),
              TextSpan(
                text: 'Resend',
                style: TextStyle(color: _cream, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleResend() async {
    final auth = context.read<AppAuthProvider>();
    final success = await auth.resendSignUpCode(widget.email);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Verification code resent to ${widget.email}'
              : (auth.errorMessage ?? 'Could not resend code. Try again.'),
        ),
        backgroundColor: success
            ? const Color(0xFF04240C)
            : const Color(0xFFCF6679),
      ),
    );
  }

  Future<void> _handleConfirm(AppAuthProvider auth) async {
    final code = _fullCode;
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 6-digit code')),
      );
      return;
    }
    final success = await auth.confirmSignUp(widget.email, code);
    if (success && mounted) {
      // Verification done — go back to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verified! Please log in.'),
          backgroundColor: Color(0xFF04240C),
        ),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
