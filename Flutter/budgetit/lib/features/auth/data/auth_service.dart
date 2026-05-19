// Auth service interface + mock implementation.
// When AWS is ready, swap MockAuthService for CognitoAuthService.

// --- Result types ---

class AppAuthResult {
  final bool success;
  final String? errorMessage;
  // Set to true when the operation didn't succeed because the user exists
  // but their email is not yet verified. UI uses this to route to the
  // verification screen instead of just showing an error.
  final bool needsVerification;
  const AppAuthResult({
    required this.success,
    this.errorMessage,
    this.needsVerification = false,
  });
}

class AppAuthUser {
  final String email;
  const AppAuthUser({required this.email});
}

// --- Abstract interface ---
// Every method Cognito will need to support.

abstract class AuthService {
  Future<AppAuthResult> signUp(String email, String password);
  Future<AppAuthResult> confirmSignUp(String email, String code);
  Future<AppAuthResult> resendSignUpCode(String email);
  Future<AppAuthResult> signIn(String email, String password);
  Future<AppAuthResult> signOut();
  Future<AppAuthResult> resetPassword(String email);
  Future<AppAuthResult> confirmResetPassword(
      String email, String newPassword, String code);
  Future<AppAuthUser?> getCurrentUser();
}

// --- Mock implementation ---
// Simulates Cognito responses so we can build and test the UI
// without a real AWS account. Replace with CognitoAuthService later.

class MockAuthService implements AuthService {
  // Fake in-memory store
  final Map<String, String> _users = {};
  final Set<String> _confirmedUsers = {};
  String? _loggedInEmail;

  @override
  Future<AppAuthResult> signUp(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network
    if (_users.containsKey(email)) {
      if (!_confirmedUsers.contains(email)) {
        return const AppAuthResult(
          success: true,
          needsVerification: true,
          errorMessage:
              'Account exists but is not verified. A new code was sent.',
        );
      }
      return const AppAuthResult(
          success: false, errorMessage: 'An account with this email already exists.');
    }
    _users[email] = password;
    return const AppAuthResult(success: true);
  }

  @override
  Future<AppAuthResult> confirmSignUp(String email, String code) async {
    await Future.delayed(const Duration(seconds: 1));
    if (code.length == 6) {
      _confirmedUsers.add(email);
      return const AppAuthResult(success: true);
    }
    return const AppAuthResult(
        success: false, errorMessage: 'Invalid verification code.');
  }

  @override
  Future<AppAuthResult> resendSignUpCode(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!_users.containsKey(email)) {
      return const AppAuthResult(
          success: false, errorMessage: 'No account found with this email.');
    }
    return const AppAuthResult(success: true);
  }

  @override
  Future<AppAuthResult> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (!_users.containsKey(email)) {
      return const AppAuthResult(
          success: false, errorMessage: 'No account found with this email.');
    }
    if (_users[email] != password) {
      return const AppAuthResult(
          success: false, errorMessage: 'Incorrect password.');
    }
    if (!_confirmedUsers.contains(email)) {
      return const AppAuthResult(
        success: false,
        needsVerification: true,
        errorMessage: 'Please verify your email before signing in.',
      );
    }
    _loggedInEmail = email;
    return const AppAuthResult(success: true);
  }

  @override
  Future<AppAuthResult> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _loggedInEmail = null;
    return const AppAuthResult(success: true);
  }

  @override
  Future<AppAuthResult> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    if (!_users.containsKey(email)) {
      return const AppAuthResult(
          success: false, errorMessage: 'No account found with this email.');
    }
    return const AppAuthResult(success: true);
  }

    @override
    Future<AppAuthResult> confirmResetPassword(
      String email, String newPassword, String code) async {
    await Future.delayed(const Duration(seconds: 1));
    if (code.length == 6) {
      _users[email] = newPassword;
      return const AppAuthResult(success: true);
    }
    return const AppAuthResult(
        success: false, errorMessage: 'Invalid reset code.');
  }

  @override
  Future<AppAuthUser?> getCurrentUser() async {
    if (_loggedInEmail != null) {
      return AppAuthUser(email: _loggedInEmail!);
    }
    return null;
  }
}
