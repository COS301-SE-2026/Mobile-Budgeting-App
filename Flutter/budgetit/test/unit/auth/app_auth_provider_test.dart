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


  group('AppAuthProvider - resendSignUpCode', () {
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

}