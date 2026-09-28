import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../services/friend_service.dart';
import '../../utils/app_colour.dart';

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

  Future<void> _toggleBiometricLock(
    BuildContext context,
    AppAuthProvider auth,
  ) async {
    final changed = await auth.setBiometricLockEnabled(
      !auth.biometricLockEnabled,
    );
    if (!changed && context.mounted && auth.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(auth.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final auth = context.watch<AppAuthProvider>();

    return Scaffold(
      backgroundColor: colours.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colours.primary,
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: colours.cardText,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text('PROFILE', style: colours.h2),
                ],
              ),
              const SizedBox(height: 36),
              Align(
                child: Container(
                  width: 96,
                  height: 96,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colours.primary,
                    border: Border.all(color: Colors.black, width: 4),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                    ],
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: 52,
                    color: colours.cardText,
                  ),
                ),
              ),
              const SizedBox(height: 26),

              // Identity line — email for logged-in users, guest label otherwise
              if (auth.isLoggedIn && auth.currentUser != null)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colours.primary,
                    border: Border.all(color: Colors.black, width: 4),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'USERNAME',
                        style: colours.h4.copyWith(color: colours.cardText),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        auth.currentUser!.email,
                        style: colours.b1.copyWith(
                          color: colours.cardText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                      style: colours.b1.copyWith(
                        color: colours.textPrimary.withValues(alpha: 0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 20),
              if (auth.isLoggedIn) ...[
                FutureBuilder<String>(
                  future: FriendService.instance.getMyFriendCode(),
                  builder: (context, snapshot) {
                    final code = snapshot.data;
                    return Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colours.primary,
                        border: Border.all(color: Colors.black, width: 4),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'YOUR FRIEND CODE',
                            style: colours.h4.copyWith(color: colours.cardText),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? 'LOADING...'
                                      : code ?? 'UNAVAILABLE',
                                  style: colours.h2.copyWith(
                                    color: colours.cardText,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Copy friend code',
                                onPressed: code == null
                                    ? null
                                    : () async {
                                        await Clipboard.setData(
                                          ClipboardData(text: code),
                                        );
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Friend code copied'),
                                          ),
                                        );
                                      },
                                icon: Icon(
                                  Icons.copy,
                                  color: code == null
                                      ? colours.cardText.withValues(alpha: 0.4)
                                      : colours.cardText,
                                ),
                              ),
                            ],
                          ),
                          if (snapshot.hasError) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Could not load the code. Check the Friends server and try again.',
                              style: colours.b1.copyWith(color: colours.error),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
              ],
              if (auth.isLoggedIn) ...[
                Container(
                  decoration: BoxDecoration(
                    color: colours.primary,
                    border: Border.all(color: Colors.black, width: 4),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                    ],
                  ),
                  child: InkWell(
                    onTap: auth.isLoading
                        ? null
                        : () => _toggleBiometricLock(context, auth),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BIOMETRIC LOCK',
                                  style: colours.h4.copyWith(
                                    color: colours.cardText,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Require Android biometrics when reopening the app',
                                  style: colours.b1.copyWith(
                                    color: colours.cardText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: auth.biometricLockEnabled
                                  ? colours.cardText
                                  : colours.background,
                              border: Border.all(color: Colors.black, width: 3),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(3, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              auth.biometricLockEnabled ? 'ON' : 'OFF',
                              style: colours.b1.copyWith(
                                color: auth.biometricLockEnabled
                                    ? colours.primary
                                    : colours.cardText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],

              // Sign Up button — only shown for guest users, sits above Log Out
              if (auth.status == AuthStatus.skipped) ...[
                ElevatedButton.icon(
                  onPressed: () => _handleGoToSignUp(context),
                  icon: const Icon(Icons.person_add_outlined),
                  label: const Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colours.primary,
                    foregroundColor: colours.cardText,
                    textStyle: colours.b1.copyWith(fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 3),
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
                  style: colours.b1.copyWith(
                    color: auth.isLoading ? _red.withValues(alpha: 0.5) : _red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: auth.isLoading ? _red.withValues(alpha: 0.4) : _red,
                    width: 3,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  shape: const RoundedRectangleBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
