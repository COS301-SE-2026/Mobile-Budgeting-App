// Auth service interface + mock implementation.
// When AWS is ready, swap MockAuthService for CognitoAuthService.

// --- Result types ---

class AuthResult {
  final bool success;
  final String? errorMessage;
  const AuthResult({required this.success, this.errorMessage});
}

class AuthUser {
  final String email;
  const AuthUser({required this.email});
}

// --- Abstract interface ---
// Every method Cognito will need to support.

abstract class AuthService {
  Future<AuthResult> signUp(String email, String password);
  Future<AuthResult> confirmSignUp(String email, String code);
  Future<AuthResult> signIn(String email, String password);
  Future<AuthResult> signOut();
  Future<AuthResult> resetPassword(String email);
  Future<AuthResult> confirmResetPassword(
      String email, String newPassword, String code);
  Future<AuthUser?> getCurrentUser();
}

// --- Mock implementation ---
// Simulates Cognito responses so we can build and test the UI
// without a real AWS account. Replace with CognitoAuthService later.

class MockAuthService implements AuthService {
  // Fake in-memory store
  final Map<String, String> _users = {};
  String? _loggedInEmail;

  @override
  Future<AuthResult> signUp(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network
    if (_users.containsKey(email)) {
      return const AuthResult(
          success: false, errorMessage: 'An account with this email already exists.');
    }
    _users[email] = password;
    return const AuthResult(success: true);
  }

  @override
  Future<AuthResult> confirmSignUp(String email, String code) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock: any 6-digit code works
    if (code.length == 6) {
      return const AuthResult(success: true);
    }
    return const AuthResult(
        success: false, errorMessage: 'Invalid verification code.');
  }

  @override
  Future<AuthResult> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (!_users.containsKey(email)) {
      return const AuthResult(
          success: false, errorMessage: 'No account found with this email.');
    }
    if (_users[email] != password) {
      return const AuthResult(
          success: false, errorMessage: 'Incorrect password.');
    }
    _loggedInEmail = email;
    return const AuthResult(success: true);
  }

  @override
  Future<AuthResult> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _loggedInEmail = null;
    return const AuthResult(success: true);
  }

  @override
  Future<AuthResult> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    if (!_users.containsKey(email)) {
      return const AuthResult(
          success: false, errorMessage: 'No account found with this email.');
    }
    return const AuthResult(success: true);
  }

  @override
  Future<AuthResult> confirmResetPassword(
      String email, String newPassword, String code) async {
    await Future.delayed(const Duration(seconds: 1));
    if (code.length == 6) {
      _users[email] = newPassword;
      return const AuthResult(success: true);
    }
    return const AuthResult(
        success: false, errorMessage: 'Invalid reset code.');
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    if (_loggedInEmail != null) {
      return AuthUser(email: _loggedInEmail!);
    }
    return null;
  }
}