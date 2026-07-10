import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:budgetit/auth/data/auth_service.dart';
import 'package:budgetit/auth/providers/auth_provider.dart';
import 'package:budgetit/screens/forgot_password_screen.dart';
import 'package:budgetit/screens/login_password_screen.dart';
import 'package:budgetit/screens/verify_email_screen.dart';

// Fake auth service — instant responses, fully configurable per test
class _FakeAuthService implements AuthService {
  AppAuthResult signUpResult = const AppAuthResult(success: true);
  AppAuthResult confirmResult = const AppAuthResult(success: true);
  AppAuthResult resendResult = const AppAuthResult(success: true);
  AppAuthResult signInResult = const AppAuthResult(success: true);
  AppAuthResult signOutResult = const AppAuthResult(success: true);
  AppAuthResult resetResult = const AppAuthResult(success: true);
  AppAuthResult confirmResetResult = const AppAuthResult(success: true);
  AppAuthUser? currentUserResult;

  @override
  Future<AppAuthResult> signUp(String email, String password) async =>
      signUpResult;

  @override
  Future<AppAuthResult> confirmSignUp(String email, String code) async =>
      confirmResult;

  @override
  Future<AppAuthResult> resendSignUpCode(String email) async => resendResult;

  @override
  Future<AppAuthResult> signIn(String email, String password) async =>
      signInResult;

  @override
  Future<AppAuthResult> signOut() async => signOutResult;

  @override
  Future<AppAuthResult> resetPassword(String email) async => resetResult;

  @override
  Future<AppAuthResult> confirmResetPassword(
    String email,
    String newPassword,
    String code,
  ) async => confirmResetResult;

  @override
  Future<AppAuthUser?> getCurrentUser() async => currentUserResult;
}

// Helpers
AppAuthProvider _makeProvider(_FakeAuthService fake) =>
    AppAuthProvider(authService: fake);

Widget _wrap(Widget child, AppAuthProvider provider) =>
    ChangeNotifierProvider<AppAuthProvider>.value(
      value: provider,
      child: MaterialApp(home: child),
    );

/// Lets the async constructor call (_checkCurrentSession) complete.
Future<void> _settleProvider() => Future<void>.delayed(Duration.zero);

// Tests

void main() {
  // AppAuthProvider — unit tests
  group('AppAuthProvider', () {
    test('starts as unknown then resolves to guest when no session', () async {
      final fake = _FakeAuthService()..currentUserResult = null;
      final provider = _makeProvider(fake);
      await _settleProvider();
      expect(provider.status, AuthStatus.guest);
      expect(provider.isLoading, isFalse);
      expect(provider.currentUser, isNull);
    });

    test('resolves to loggedIn when a session already exists', () async {
      final fake = _FakeAuthService()
        ..currentUserResult = const AppAuthUser(email: 'user@test.com');
      final provider = _makeProvider(fake);
      await _settleProvider();
      expect(provider.status, AuthStatus.loggedIn);
      expect(provider.currentUser?.email, 'user@test.com');
    });

    test('signUp success returns true with no error', () async {
      final fake = _FakeAuthService()
        ..currentUserResult = null
        ..signUpResult = const AppAuthResult(success: true);
      final provider = _makeProvider(fake);
      await _settleProvider();

      final result = await provider.signUp('new@test.com', 'password123');
      expect(result, isTrue);
      expect(provider.errorMessage, isNull);
      expect(provider.needsVerification, isFalse);
    });

    test('signUp failure returns false and sets errorMessage', () async {
      final fake = _FakeAuthService()
        ..currentUserResult = null
        ..signUpResult = const AppAuthResult(
          success: false,
          errorMessage: 'An account with this email already exists.',
        );
      final provider = _makeProvider(fake);
      await _settleProvider();

      final result = await provider.signUp('taken@test.com', 'password123');
      expect(result, isFalse);
      expect(
        provider.errorMessage,
        'An account with this email already exists.',
      );
    });

    test(
      'signUp sets needsVerification when account exists but unconfirmed',
      () async {
        final fake = _FakeAuthService()
          ..currentUserResult = null
          ..signUpResult = const AppAuthResult(
            success: true,
            needsVerification: true,
            errorMessage:
                'Account exists but is not verified. A new code was sent.',
          );
        final provider = _makeProvider(fake);
        await _settleProvider();

        final result = await provider.signUp('unconfirmed@test.com', 'pass');
        expect(result, isTrue);
        expect(provider.needsVerification, isTrue);
      },
    );

    test(
      'signIn success sets status to loggedIn and populates currentUser',
      () async {
        final fake = _FakeAuthService()..currentUserResult = null;
        final provider = _makeProvider(fake);
        await _settleProvider();
        expect(provider.status, AuthStatus.guest);

        fake.signInResult = const AppAuthResult(success: true);
        fake.currentUserResult = const AppAuthUser(email: 'user@test.com');

        final ok = await provider.signIn('user@test.com', 'password123');
        expect(ok, isTrue);
        expect(provider.status, AuthStatus.loggedIn);
        expect(provider.currentUser?.email, 'user@test.com');
        expect(provider.errorMessage, isNull);
      },
    );

    test('signIn failure sets errorMessage and keeps guest status', () async {
      final fake = _FakeAuthService()
        ..currentUserResult = null
        ..signInResult = const AppAuthResult(
          success: false,
          errorMessage: 'Incorrect password.',
        );
      final provider = _makeProvider(fake);
      await _settleProvider();

      final ok = await provider.signIn('user@test.com', 'wrongpass');
      expect(ok, isFalse);
      expect(provider.status, AuthStatus.guest);
      expect(provider.errorMessage, 'Incorrect password.');
    });

    test('signIn with needsVerification sets the flag', () async {
      final fake = _FakeAuthService()
        ..currentUserResult = null
        ..signInResult = const AppAuthResult(
          success: false,
          needsVerification: true,
          errorMessage: 'Please verify your email before signing in.',
        );
      final provider = _makeProvider(fake);
      await _settleProvider();

      await provider.signIn('unverified@test.com', 'password123');
      expect(provider.needsVerification, isTrue);
      expect(provider.status, AuthStatus.guest);
    });

    test('confirmSignUp success returns true', () async {
      final fake = _FakeAuthService()
        ..currentUserResult = null
        ..confirmResult = const AppAuthResult(success: true);
      final provider = _makeProvider(fake);
      await _settleProvider();

      final ok = await provider.confirmSignUp('user@test.com', '123456');
      expect(ok, isTrue);
      expect(provider.errorMessage, isNull);
    });

    test('confirmSignUp failure returns false and sets errorMessage', () async {
      final fake = _FakeAuthService()
        ..currentUserResult = null
        ..confirmResult = const AppAuthResult(
          success: false,
          errorMessage: 'Invalid verification code. Please try again.',
        );
      final provider = _makeProvider(fake);
      await _settleProvider();

      final ok = await provider.confirmSignUp('user@test.com', '000000');
      expect(ok, isFalse);
      expect(
        provider.errorMessage,
        'Invalid verification code. Please try again.',
      );
    });

    test('resendSignUpCode success returns true', () async {
      final fake = _FakeAuthService()
        ..currentUserResult = null
        ..resendResult = const AppAuthResult(success: true);
      final provider = _makeProvider(fake);
      await _settleProvider();

      final ok = await provider.resendSignUpCode('user@test.com');
      expect(ok, isTrue);
    });

    test(
      'resendSignUpCode failure returns false and sets errorMessage',
      () async {
        final fake = _FakeAuthService()
          ..currentUserResult = null
          ..resendResult = const AppAuthResult(
            success: false,
            errorMessage: 'No account found with this email.',
          );
        final provider = _makeProvider(fake);
        await _settleProvider();

        final ok = await provider.resendSignUpCode('nobody@test.com');
        expect(ok, isFalse);
        expect(provider.errorMessage, 'No account found with this email.');
      },
    );

    test('signOut clears currentUser and reverts status to guest', () async {
      final fake = _FakeAuthService()
        ..currentUserResult = const AppAuthUser(email: 'user@test.com');
      final provider = _makeProvider(fake);
      await _settleProvider();
      expect(provider.status, AuthStatus.loggedIn);

      await provider.signOut();
      expect(provider.status, AuthStatus.guest);
      expect(provider.currentUser, isNull);
    });

    test('continueAsGuest sets status to skipped', () async {
      final fake = _FakeAuthService()..currentUserResult = null;
      final provider = _makeProvider(fake);
      await _settleProvider();

      provider.continueAsGuest();
      expect(provider.status, AuthStatus.skipped);
    });

    test('backToLogin reverts status from skipped to guest', () async {
      final fake = _FakeAuthService()..currentUserResult = null;
      final provider = _makeProvider(fake);
      await _settleProvider();

      provider.continueAsGuest();
      expect(provider.status, AuthStatus.skipped);

      provider.backToLogin();
      expect(provider.status, AuthStatus.guest);
    });

    test('resetPassword success returns true', () async {
      final fake = _FakeAuthService()
        ..currentUserResult = null
        ..resetResult = const AppAuthResult(success: true);
      final provider = _makeProvider(fake);
      await _settleProvider();

      final ok = await provider.resetPassword('user@test.com');
      expect(ok, isTrue);
      expect(provider.errorMessage, isNull);
    });

    test('resetPassword failure returns false and sets errorMessage', () async {
      final fake = _FakeAuthService()
        ..currentUserResult = null
        ..resetResult = const AppAuthResult(
          success: false,
          errorMessage: 'No account found with this email.',
        );
      final provider = _makeProvider(fake);
      await _settleProvider();

      final ok = await provider.resetPassword('nobody@test.com');
      expect(ok, isFalse);
      expect(provider.errorMessage, 'No account found with this email.');
    });

    test('confirmResetPassword success returns true', () async {
      final fake = _FakeAuthService()
        ..currentUserResult = null
        ..confirmResetResult = const AppAuthResult(success: true);
      final provider = _makeProvider(fake);
      await _settleProvider();

      final ok = await provider.confirmResetPassword(
        'user@test.com',
        'NewPassword1',
        '123456',
      );
      expect(ok, isTrue);
    });

    test(
      'confirmResetPassword failure returns false and sets errorMessage',
      () async {
        final fake = _FakeAuthService()
          ..currentUserResult = null
          ..confirmResetResult = const AppAuthResult(
            success: false,
            errorMessage: 'Invalid reset code. Please try again.',
          );
        final provider = _makeProvider(fake);
        await _settleProvider();

        final ok = await provider.confirmResetPassword(
          'user@test.com',
          'NewPassword1',
          '000000',
        );
        expect(ok, isFalse);
        expect(provider.errorMessage, 'Invalid reset code. Please try again.');
      },
    );

    test('clearError resets errorMessage to null', () async {
      final fake = _FakeAuthService()
        ..currentUserResult = null
        ..signInResult = const AppAuthResult(
          success: false,
          errorMessage: 'Incorrect password.',
        );
      final provider = _makeProvider(fake);
      await _settleProvider();

      await provider.signIn('user@test.com', 'wrong');
      expect(provider.errorMessage, isNotNull);

      provider.clearError();
      expect(provider.errorMessage, isNull);
    });
  });

  // LoginRegisterScreen — widget tests

  group('LoginRegisterScreen', () {
    late _FakeAuthService fake;
    late AppAuthProvider provider;

    setUp(() {
      fake = _FakeAuthService()..currentUserResult = null;
      provider = _makeProvider(fake);
    });

    testWidgets('renders login tab selected by default with correct header', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const LoginRegisterScreen(), provider));
      await tester.pump();

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Login →'), findsOneWidget);
      expect(find.text('Confirm password'), findsNothing);
    });

    testWidgets(
      'switching to Register tab shows Create Account header and confirm field',
      (tester) async {
        await tester.pumpWidget(_wrap(const LoginRegisterScreen(), provider));
        await tester.pump();

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(find.text('Create Account'), findsOneWidget);
        expect(find.text('Register →'), findsOneWidget);
        expect(find.text('Confirm password'), findsOneWidget);
      },
    );

    testWidgets('submitting with empty fields shows snackbar', (tester) async {
      await tester.pumpWidget(_wrap(const LoginRegisterScreen(), provider));
      await tester.pump();

      await tester.tap(find.text('Login →'));
      await tester.pumpAndSettle();

      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('register with mismatched passwords shows snackbar', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const LoginRegisterScreen(), provider));
      await tester.pump();

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'test@test.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.enterText(find.byType(TextField).at(2), 'different456');

      await tester.tap(find.text('Register →'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('register with short password shows snackbar', (tester) async {
      await tester.pumpWidget(_wrap(const LoginRegisterScreen(), provider));
      await tester.pump();

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'test@test.com');
      await tester.enterText(find.byType(TextField).at(1), 'short');
      await tester.enterText(find.byType(TextField).at(2), 'short');

      await tester.tap(find.text('Register →'));
      await tester.pumpAndSettle();

      expect(
        find.text('Password must be at least 8 characters'),
        findsOneWidget,
      );
    });

    testWidgets('Continue as Guest sets provider status to skipped', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const LoginRegisterScreen(), provider));
      await tester.pump();

      await tester.tap(find.text('Continue as Guest'));
      await tester.pumpAndSettle();

      expect(provider.status, AuthStatus.skipped);
    });

    testWidgets('sign-in failure shows error message from provider', (
      tester,
    ) async {
      fake.signInResult = const AppAuthResult(
        success: false,
        errorMessage: 'Incorrect password.',
      );

      await tester.pumpWidget(_wrap(const LoginRegisterScreen(), provider));
      await tester.pump();

      await tester.enterText(find.byType(TextField).at(0), 'user@test.com');
      await tester.enterText(find.byType(TextField).at(1), 'wrongpassword');

      await tester.tap(find.text('Login →'));
      await tester.pumpAndSettle();

      expect(find.text('Incorrect password.'), findsOneWidget);
    });

    testWidgets('successful sign-in updates provider status to loggedIn', (
      tester,
    ) async {
      fake.signInResult = const AppAuthResult(success: true);

      await tester.pumpWidget(_wrap(const LoginRegisterScreen(), provider));
      await tester.pump();

      // Set currentUser so that the post-signIn getCurrentUser call succeeds
      fake.currentUserResult = const AppAuthUser(email: 'user@test.com');

      await tester.enterText(find.byType(TextField).at(0), 'user@test.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');

      await tester.tap(find.text('Login →'));
      await tester.pumpAndSettle();

      expect(provider.status, AuthStatus.loggedIn);
    });
  });

  // VerifyEmailScreen — widget tests

  group('VerifyEmailScreen', () {
    const testEmail = 'verify@test.com';

    AppAuthProvider makeVerifyProvider([_FakeAuthService? s]) {
      final fake = s ?? (_FakeAuthService()..currentUserResult = null);
      return _makeProvider(fake);
    }

    testWidgets('displays the email passed to it', (tester) async {
      final provider = makeVerifyProvider();
      await tester.pumpWidget(
        _wrap(const VerifyEmailScreen(email: testEmail), provider),
      );
      await tester.pump();

      expect(find.text('Verify your email'), findsOneWidget);
      // Email is rendered inside a RichText span, so check via widget predicate
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains(testEmail),
        ),
        findsOneWidget,
      );
    });

    testWidgets('tapping Verify with incomplete code shows snackbar', (
      tester,
    ) async {
      final provider = makeVerifyProvider();
      await tester.pumpWidget(
        _wrap(const VerifyEmailScreen(email: testEmail), provider),
      );
      await tester.pump();

      // Only fill 3 of 6 boxes
      await tester.enterText(find.byType(TextField).at(0), '1');
      await tester.enterText(find.byType(TextField).at(1), '2');
      await tester.enterText(find.byType(TextField).at(2), '3');

      await tester.tap(find.text('Verify →'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter the full 6-digit code'), findsOneWidget);
    });

    testWidgets('tapping Resend shows success snackbar', (tester) async {
      final fake = _FakeAuthService()
        ..currentUserResult = null
        ..resendResult = const AppAuthResult(success: true);
      final provider = makeVerifyProvider(fake);
      await tester.pumpWidget(
        _wrap(const VerifyEmailScreen(email: testEmail), provider),
      );
      await tester.pump();

      // The Resend text is inside a RichText; find its GestureDetector
      final resendGesture = find.ancestor(
        of: find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('Resend'),
        ),
        matching: find.byType(GestureDetector),
      );
      await tester.tap(resendGesture);
      await tester.pumpAndSettle();

      expect(
        find.text('Verification code resent to $testEmail'),
        findsOneWidget,
      );
    });

    testWidgets('valid 6-digit code triggers confirmSignUp success', (
      tester,
    ) async {
      final fake = _FakeAuthService()
        ..currentUserResult = null
        ..confirmResult = const AppAuthResult(success: true);
      final provider = makeVerifyProvider(fake);
      await tester.pumpWidget(
        _wrap(const VerifyEmailScreen(email: testEmail), provider),
      );
      await tester.pump();

      for (int i = 0; i < 6; i++) {
        await tester.enterText(find.byType(TextField).at(i), '${i + 1}');
      }

      await tester.tap(find.text('Verify →'));
      await tester.pumpAndSettle();

      expect(find.text('Email verified! Please log in.'), findsOneWidget);
    });

    testWidgets('failed confirmSignUp shows error from provider', (
      tester,
    ) async {
      final fake = _FakeAuthService()
        ..currentUserResult = null
        ..confirmResult = const AppAuthResult(
          success: false,
          errorMessage: 'Invalid verification code. Please try again.',
        );
      final provider = makeVerifyProvider(fake);
      await tester.pumpWidget(
        _wrap(const VerifyEmailScreen(email: testEmail), provider),
      );
      await tester.pump();

      for (int i = 0; i < 6; i++) {
        await tester.enterText(find.byType(TextField).at(i), '0');
      }

      await tester.tap(find.text('Verify →'));
      await tester.pumpAndSettle();

      expect(
        find.text('Invalid verification code. Please try again.'),
        findsOneWidget,
      );
    });
  });

  // ForgotPasswordScreen — widget tests

  group('ForgotPasswordScreen', () {
    late _FakeAuthService fake;
    late AppAuthProvider provider;

    setUp(() {
      fake = _FakeAuthService()..currentUserResult = null;
      provider = _makeProvider(fake);
    });

    testWidgets('shows Reset Password header and send button initially', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const ForgotPasswordScreen(), provider));
      await tester.pump();

      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.text('Send Reset Code →'), findsOneWidget);
    });

    testWidgets('submitting empty email shows snackbar', (tester) async {
      await tester.pumpWidget(_wrap(const ForgotPasswordScreen(), provider));
      await tester.pump();

      await tester.tap(find.text('Send Reset Code →'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('successful code send transitions to step 1', (tester) async {
      fake.resetResult = const AppAuthResult(success: true);
      await tester.pumpWidget(_wrap(const ForgotPasswordScreen(), provider));
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'user@test.com');
      await tester.tap(find.text('Send Reset Code →'));
      await tester.pumpAndSettle();

      expect(find.text('Enter New Password'), findsOneWidget);
      expect(find.text('Reset Password →'), findsOneWidget);
    });

    testWidgets('short reset code in step 1 shows snackbar', (tester) async {
      fake.resetResult = const AppAuthResult(success: true);
      await tester.pumpWidget(_wrap(const ForgotPasswordScreen(), provider));
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'user@test.com');
      await tester.tap(find.text('Send Reset Code →'));
      await tester.pumpAndSettle();

      // Leave code blank, attempt submit
      await tester.tap(find.text('Reset Password →'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter the 6-digit code'), findsOneWidget);
    });

    testWidgets('mismatched new passwords in step 1 shows snackbar', (
      tester,
    ) async {
      fake.resetResult = const AppAuthResult(success: true);
      await tester.pumpWidget(_wrap(const ForgotPasswordScreen(), provider));
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'user@test.com');
      await tester.tap(find.text('Send Reset Code →'));
      await tester.pumpAndSettle();

      // Step 1: code=0, newPassword=1, confirmPassword=2
      await tester.enterText(find.byType(TextField).at(0), '123456');
      await tester.enterText(find.byType(TextField).at(1), 'NewPassword1');
      await tester.enterText(find.byType(TextField).at(2), 'DifferentPass2');

      await tester.tap(find.text('Reset Password →'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('short new password in step 1 shows snackbar', (tester) async {
      fake.resetResult = const AppAuthResult(success: true);
      await tester.pumpWidget(_wrap(const ForgotPasswordScreen(), provider));
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'user@test.com');
      await tester.tap(find.text('Send Reset Code →'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), '123456');
      await tester.enterText(find.byType(TextField).at(1), 'short');
      await tester.enterText(find.byType(TextField).at(2), 'short');

      await tester.tap(find.text('Reset Password →'));
      await tester.pumpAndSettle();

      expect(
        find.text('Password must be at least 8 characters'),
        findsOneWidget,
      );
    });

    testWidgets('successful password reset shows success snackbar', (
      tester,
    ) async {
      fake.resetResult = const AppAuthResult(success: true);
      fake.confirmResetResult = const AppAuthResult(success: true);
      await tester.pumpWidget(_wrap(const ForgotPasswordScreen(), provider));
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'user@test.com');
      await tester.tap(find.text('Send Reset Code →'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), '123456');
      await tester.enterText(find.byType(TextField).at(1), 'NewPassword1');
      await tester.enterText(find.byType(TextField).at(2), 'NewPassword1');

      await tester.tap(find.text('Reset Password →'));
      await tester.pumpAndSettle();

      expect(
        find.text('Password reset successfully. Please log in.'),
        findsOneWidget,
      );
    });
  });
}
