import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/providers/auth_provider.dart';
import '../utils/app_colour.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _red = Color(0xFFCF6679);

  Future<void> _handleLogout(BuildContext context) async {
    final auth = context.read<AppAuthProvider>();
    await auth.signOut();
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _handleGoToSignUp(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    context.read<AppAuthProvider>().backToLogin();
  }

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();
    final auth = context.watch<AppAuthProvider>();

    return Scaffold(
      backgroundColor: colours.background,
      appBar: AppBar(
        backgroundColor: colours.background,
        foregroundColor: colours.textPrimary,
        elevation: 0,
        title: const Text('Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: colours.secondary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 48,
                  color: colours.background,
                ),
              ),
              const SizedBox(height: 20),

              // Identity line — email for logged-in users, guest label otherwise
              if (auth.isLoggedIn && auth.currentUser != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: colours.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colours.secondary.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    auth.currentUser!.email.contains('@')
                        ? auth.currentUser!.email
                        : 'Network User',
                    style: TextStyle(
                      color: colours.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: colours.textPrimary.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Guest User',
                      style: TextStyle(
                        color: colours.textPrimary.withValues(alpha: 0.6),
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 20),
              Text(
                'Profile Coming Soon',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colours.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your profile page is still being prepared. Soon you will be able to view and manage your personal account details here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colours.textPrimary.withValues(alpha: 0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colours.secondary,
                  foregroundColor: colours.background,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sign Up button — only shown for guest users, sits above Log Out
              if (auth.status == AuthStatus.skipped) ...[
                ElevatedButton.icon(
                  onPressed: () => _handleGoToSignUp(context),
                  icon: const Icon(Icons.person_add_outlined),
                  label: const Text(
                    'Sign Up',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colours.secondary,
                    foregroundColor: colours.background,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              OutlinedButton.icon(
                onPressed: auth.isLoading ? null : () => _handleLogout(context),
                icon: auth.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _red,
                        ),
                      )
                    : const Icon(Icons.logout, color: _red),
                label: Text(
                  'Log Out',
                  style: TextStyle(
                    color: auth.isLoading
                        ? _red.withValues(alpha: 0.5)
                        : _red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: auth.isLoading
                        ? _red.withValues(alpha: 0.4)
                        : _red,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
