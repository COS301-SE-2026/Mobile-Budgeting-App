import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/auth/providers/auth_provider.dart';
import 'package:budgetit/auth/data/auth_service.dart';

Future<AppAuthProvider> _freshProvider() async {
  final provider = AppAuthProvider(authService: MockAuthService());
  await Future.delayed(Duration.zero);
  return provider;
}

void main() {
  group('initial session check', () {
    test('starts as guest when no user is logged in', () async {
      final provider = await _freshProvider();
      expect(provider.status, equals(AuthStatus.guest));
      expect(provider.currentUser, isNull);
      expect(provider.isLoggedIn, isFalse);
    });
  });

  group('signUp', () {
    test('new email succceds with no verification flag', () async {
      final provider = await _freshProvider();
      final result = await provider.signUp('pav@example.com', 'pavword123');

      expect(result, isTrue);
      expect(provider.needsVerification, isFalse);
      expect(provider.errorMessage, isNull);
    });

    test('signing up the same unconfirmed email again triggers needsVerification', () async {
      final provider = await _freshProvider();
      await provider.signUp('pav@example.com', 'pavword123');
      final result = await provider.signUp('pav@example.com', 'pavword123');

      expect(result, isTrue);
      expect(provider.needsVerification, isTrue);
      expect(provider.errorMessage, contains('not verified'));
    });    

    test('signing up a fully confirmed email fails', () async {
      final provider = await _freshProvider();
      await provider.signUp('paverified@example.com', 'paverifiedword123');
      await provider.confirmSignUp('paverified@example.com', '123456');
      final result = await provider.signUp('paverified@example.com', 'paverifiedword123');

      expect(result, isFalse);
      expect(provider.errorMessage, contains('already exists'));
    });
  });


  group('confirmSignUp', () {
    test('valid 6-character code succeeds', () async {
      final provider = await _freshProvider();
      await provider.signUp('paverify@example.com', 'pavword123');
      final result = await provider.confirmSignUp('paverify@example.com', '123456');

      expect(result, isTrue);
      expect(provider.errorMessage, isNull);
    });

    test('invalid code length fails with an error message', () async {
      final provider = await _freshProvider();
      await provider.signUp('paverify2@example.com', 'pavword123');
      final result = await provider.confirmSignUp('paverify2@example.com', '123');
      expect(result, isFalse);
      expect(provider.errorMessage, equals('Invalid verification code.'));
    });
  });


  group('resendSignUpCode', () {
    test('unknown email fails', () async {
      final provider = await _freshProvider();
      final result = await provider.resendSignUpCode('unknownPav@example.com');
      expect(result, isFalse);
      expect(provider.errorMessage, contains('No account found'));
    });

    test('known email succeeds', () async {
      final provider = await _freshProvider();
      await provider.signUp('knownPav@example.com', 'pavword123');
      final result = await provider.resendSignUpCode('knownPav@example.com');
      expect(result, isTrue);
    });
  });



  group('signIn', () {
    test('unknown email fails without changing status', () async {
      final provider = await _freshProvider();
      final result = await provider.signIn('unknownPav@example.com', 'p');

      expect(result, isFalse);
      expect(provider.status, equals(AuthStatus.guest));
      expect(provider.errorMessage, contains('No account found'));
    });

    test('wrong password fails', () async {
      final provider = await _freshProvider();
      await provider.signUp('pav@example.com', 'correct-pavword');
      await provider.confirmSignUp('pav@example.com', '123456');
      final result = await provider.signIn('pav@example.com', 'wrong-pavword');

      expect(result, isFalse);
      expect(provider.errorMessage, equals('Incorrect password.'));
    });

    test('unconfirmed user fails with needsVerification set', () async {
      final provider = await _freshProvider();
      await provider.signUp('unconfirmedPAV@example.com', 'pavword123');
      final result = await provider.signIn('unconfirmedPAV@example.com', 'pavword123');

      expect(result, isFalse);
      expect(provider.needsVerification, isTrue);
      expect(provider.status, equals(AuthStatus.guest));
    });

    test('correct credentials for a confirmed user succeed and set loggedIn status', () async {
      final provider = await _freshProvider();
      await provider.signUp('goodPAV@example.com', 'pavword123');
      await provider.confirmSignUp('goodPAV@example.com', '123456');

      final result = await provider.signIn('goodPAV@example.com', 'pavword123');

      expect(result, isTrue);
      expect(provider.status, equals(AuthStatus.loggedIn));
      expect(provider.isLoggedIn, isTrue);
      expect(provider.currentUser?.email, equals('goodPAV@example.com'));
    });
  });


  group('signOut', () {
    test('resets status to guest and clears current user', () async {
      final provider = await _freshProvider();
      await provider.signUp('pavout@example.com', 'pavword123');
      await provider.confirmSignUp('pavout@example.com', '123456');
      await provider.signIn('pavout@example.com', 'pavword123');

      expect(provider.status, equals(AuthStatus.loggedIn));
      await provider.signOut();

      expect(provider.status, equals(AuthStatus.guest));
      expect(provider.currentUser, isNull);
      expect(provider.isLoggedIn, isFalse);
    });
  });

  group('guest and navigation helpers', () {
    test('continueAsGuest sets status to skipped', () async {
      final provider = await _freshProvider();
      provider.continueAsGuest();
      expect(provider.status, equals(AuthStatus.skipped));
    });

    test('backToLogin sets status to guest', () async {
      final provider = await _freshProvider();
      provider.continueAsGuest();
      provider.backToLogin();
      expect(provider.status, equals(AuthStatus.guest));
    });
  });


  group('password reset', () {
    test('resetPassword fails for an unknown email', () async {
      final provider = await _freshProvider();
      final result = await provider.resetPassword('fakePav@example.com');
      expect(result, isFalse);
    });

    test('resetPassword succeeds for a known email', () async {
      final provider = await _freshProvider();
      await provider.signUp('samePav@example.com', 'old-pavword');
      final result = await provider.resetPassword('samePav@example.com');

      expect(result, isTrue);
    });

    test('confirmResetPassword fails with an invalid code', () async {
      final provider = await _freshProvider();
      await provider.signUp('samePav@example.com', 'old-pavword');
      final result = await provider.confirmResetPassword('samePav@example.com', 'new-pavword', '12');

      expect(result, isFalse);
      expect(provider.errorMessage, equals('Invalid reset code.'));
    });

    test('confirmResetPassword with a valid code updates the password so a later sign-in works', () async {
      final provider = await _freshProvider();
      await provider.signUp('pavAgain@example.com', 'old-pavword');
      await provider.confirmSignUp('pavAgain@example.com', '123456');

      final confirmed = await provider.confirmResetPassword('pavAgain@example.com', 'brand-new-pavword', '123456');
      expect(confirmed, isTrue);

      final signInResult = await provider.signIn('pavAgain@example.com', 'brand-new-pavword');
      expect(signInResult, isTrue);
    });
  });

  group('error and verification state helpers', () {
    test('clearError removes the current error message', () async {
      final provider = await _freshProvider();
      await provider.signIn('fakePav@example.com', 'x');
      expect(provider.errorMessage, isNotNull);

      provider.clearError();

      expect(provider.errorMessage, isNull);
    });

    test('clearNeedsVerification resets the flag', () async {
      final provider = await _freshProvider();
      await provider.signUp('needsPavverify@example.com', 'pavword123');
      await provider.signIn('needsPaverify@example.com', 'pavword123');
      expect(provider.needsVerification, isTrue);

      provider.clearNeedsVerification();

      expect(provider.needsVerification, isFalse);
    });
  });


}