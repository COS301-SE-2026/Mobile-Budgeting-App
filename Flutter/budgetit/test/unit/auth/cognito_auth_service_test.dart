import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/auth/data/cognito_auth_service.dart';
import 'package:budgetit/auth/data/auth_service.dart';

void main() {
  group('CognitoAuthService - interface compliance', () {
    test('implements AuthService and can be instantiated', () {
      final AuthService service = CognitoAuthService();
      expect(service, isA<CognitoAuthService>());
      expect(service, isA<AuthService>());
    });
  });



  group('uncofigured Amilify fails loudly', () {
    test('signUp does not silently report success when Amplify is unconfigured', () async {
      final service = CognitoAuthService();
      await expectLater(
        service.signUp('Pav@test.com', 'Pavword123!'),
        throwsA(anything),
      );
    }); 

    test('signIn does not silently report success when Amplify is unconfigured', () async {
      final service = CognitoAuthService();
      await expectLater(
        service.signIn('Pav@test.com', 'Pavword123!'),
        throwsA(anything),
      );
    });

    test('confirmSignUp does not silently report success when Amplify is unconfigured', () async {
      final service = CognitoAuthService();
      await expectLater(
        service.confirmSignUp('Pav@test.com', '123456'),
        throwsA(anything),
      );
    });

    test('resendSignUpCode does not silently report success when Amplify is unconfigured', () async {
      final service = CognitoAuthService();
      await expectLater(
        service.resendSignUpCode('Pav@test.com'),
        throwsA(anything),
      );
    });

    test('signOut does not silently report success when Amplify is unconfigured', () async {
      final service = CognitoAuthService();
      await expectLater(service.signOut(), throwsA(anything));
    });

    test('resetPassword does not silently report success when Amplify is unconfigured', () async {
      final service = CognitoAuthService();
      await expectLater(
        service.resetPassword('Pav@test.com'),
        throwsA(anything),
      );
    });

    test('confirmResetPassword does not silently report success when Amplify is unconfigured', () async {
      final service = CognitoAuthService();
      await expectLater(
        service.confirmResetPassword('Pav@test.com', 'NewPavword123!', '123456'),
        throwsA(anything),
      );
    });

    test('getCurrentUser returns null when Amplify is unconfigured', () async {
      final service = CognitoAuthService();
      final user = await service.getCurrentUser();
      expect(user, isNull);
    });

  });
}
