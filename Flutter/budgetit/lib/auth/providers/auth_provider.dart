import 'package:flutter/foundation.dart';
import '../data/auth_service.dart';

enum AuthStatus {
  unknown, // app just launched, checking session
  guest, // not logged in, using app as guest
  skipped, // user chose to skip login
  loggedIn, // successfully authenticated
}

class AppAuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthStatus _status = AuthStatus.unknown;
  AppAuthUser? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;
  bool _needsVerification = false;

  // Getters — screens read these to know what to show
  AuthStatus get status => _status;
  AppAuthUser? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _status == AuthStatus.loggedIn;
  bool get needsVerification => _needsVerification;

  AppAuthProvider({required AuthService authService})
    : _authService = authService {
    _checkCurrentSession();
  }

  // Called on app launch — checks if user is already logged in
  Future<void> _checkCurrentSession() async {
    _setLoading(true);
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        _status = AuthStatus.loggedIn;
      } else {
        _status = AuthStatus.guest;
      }
    } catch (_) {
      _status = AuthStatus.guest;
    }
    _setLoading(false);
  }

  // --- Sign Up ---
  // Returns true if the UI should navigate to the verify-email screen.
  // That happens both for a brand-new signup AND for the
  // "user exists but is unconfirmed" case (we silently trigger a resend).
  Future<bool> signUp(String email, String password) async {
    _setLoading(true);
    _clearError();
    _needsVerification = false;
    final result = await _authService.signUp(email, password);
    _setLoading(false);
    _needsVerification = result.needsVerification;
    if (!result.success) {
      _errorMessage = result.errorMessage;
      notifyListeners();
      return false;
    }
    // Surface the info message ("Account exists but not verified...") even
    // on the success path so the user understands why they're being routed
    // to verify instead of being logged in.
    if (result.errorMessage != null) {
      _errorMessage = result.errorMessage;
    }
    notifyListeners();
    return true;
  }

  // --- Resend Sign Up Code ---
  Future<bool> resendSignUpCode(String email) async {
    _setLoading(true);
    _clearError();
    final result = await _authService.resendSignUpCode(email);
    _setLoading(false);
    if (!result.success) {
      _errorMessage = result.errorMessage;
      notifyListeners();
      return false;
    }
    return true;
  }

  // --- Confirm Sign Up (email verification code) ---
  Future<bool> confirmSignUp(String email, String code) async {
    _setLoading(true);
    _clearError();
    final result = await _authService.confirmSignUp(email, code);
    _setLoading(false);
    if (!result.success) {
      _errorMessage = result.errorMessage;
      notifyListeners();
      return false;
    }
    return true;
  }

  // --- Sign In ---
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();
    _needsVerification = false;
    final result = await _authService.signIn(email, password);
    if (result.success) {
      _currentUser = await _authService.getCurrentUser();
      _status = AuthStatus.loggedIn;
    } else {
      _errorMessage = result.errorMessage;
      _needsVerification = result.needsVerification;
    }
    _setLoading(false);
    return result.success;
  }

  // --- Sign Out ---
  // Clears session but does NOT delete local data
  Future<void> signOut() async {
    _setLoading(true);
    await _authService.signOut();
    _currentUser = null;
    _status = AuthStatus.guest;
    _setLoading(false);
  }

  // --- Continue as Guest ---
  void continueAsGuest() {
    _status = AuthStatus.skipped;
    notifyListeners();
  }

  void backToLogin() {
    _status = AuthStatus.guest;
    notifyListeners();
  }

  // --- Reset Password ---
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    final result = await _authService.resetPassword(email);
    _setLoading(false);
    if (!result.success) {
      _errorMessage = result.errorMessage;
      notifyListeners();
      return false;
    }
    return true;
  }

  // --- Confirm Reset Password ---
  Future<bool> confirmResetPassword(
    String email,
    String newPassword,
    String code,
  ) async {
    _setLoading(true);
    _clearError();
    final result = await _authService.confirmResetPassword(
      email,
      newPassword,
      code,
    );
    _setLoading(false);
    if (!result.success) {
      _errorMessage = result.errorMessage;
      notifyListeners();
      return false;
    }
    return true;
  }

  // --- Helpers ---
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  void clearNeedsVerification() {
    _needsVerification = false;
  }
}
