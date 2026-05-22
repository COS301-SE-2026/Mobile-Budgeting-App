import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'auth_service.dart';

class CognitoAuthService implements AuthService {
  @override
  Future<AppAuthResult> signUp(String email, String password) async {
    try {
      await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            AuthUserAttributeKey.email: email,
          },
        ),
      );
      return const AppAuthResult(success: true);
    } on UsernameExistsException {
      // User exists in Cognito. They may be UNCONFIRMED (signup was started
      // but verification never completed) or fully registered. Attempt to
      // resend a confirmation code — if Cognito accepts it, the user is
      // unconfirmed and we route them to the verify screen. If it throws,
      // they are fully registered.
      try {
        await Amplify.Auth.resendSignUpCode(username: email);
        return const AppAuthResult(
          success: true,
          needsVerification: true,
          errorMessage:
              'Account exists but is not verified. A new code was sent.',
        );
      } on AuthException {
        return const AppAuthResult(
          success: false,
          errorMessage: 'An account with this email already exists.',
        );
      }
    } on InvalidPasswordException catch (e) {
      return AppAuthResult(success: false, errorMessage: e.message);
    } on AuthException catch (e) {
      return AppAuthResult(success: false, errorMessage: e.message);
    }
  }

  @override
  Future<AppAuthResult> confirmSignUp(String email, String code) async {
    try {
      await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: code,
      );
      return const AppAuthResult(success: true);
    } on CodeMismatchException {
      return const AppAuthResult(
        success: false,
        errorMessage: 'Invalid verification code. Please try again.',
      );
    } on ExpiredCodeException {
      return const AppAuthResult(
        success: false,
        errorMessage: 'Code has expired. Please request a new one.',
      );
    } on AuthException catch (e) {
      return AppAuthResult(success: false, errorMessage: e.message);
    }
  }

  @override
  Future<AppAuthResult> resendSignUpCode(String email) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);
      return const AppAuthResult(success: true);
    } on LimitExceededException {
      return const AppAuthResult(
        success: false,
        errorMessage: 'Too many requests. Please wait a moment and try again.',
      );
    } on UserNotFoundException {
      return const AppAuthResult(
        success: false,
        errorMessage: 'No account found with this email.',
      );
    } on AuthException catch (e) {
      return AppAuthResult(success: false, errorMessage: e.message);
    }
  }

  @override
  Future<AppAuthResult> signIn(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      if (result.isSignedIn) {
        return const AppAuthResult(success: true);
      }
      return const AppAuthResult(
        success: false,
        errorMessage: 'Sign in could not be completed.',
      );
    } on UserNotFoundException {
      return const AppAuthResult(
        success: false,
        errorMessage: 'No account found with this email.',
      );
    } on NotAuthorizedServiceException {
      return const AppAuthResult(
        success: false,
        errorMessage: 'Incorrect password.',
      );
    } on UserNotConfirmedException {
      // User registered but never confirmed their email. Send a fresh code
      // and let the UI route them to the verify screen.
      try {
        await Amplify.Auth.resendSignUpCode(username: email);
      } on AuthException {
        // Resend failure isn't fatal here — the user can still hit "Resend"
        // on the verify screen. Swallow and continue.
      }
      return const AppAuthResult(
        success: false,
        needsVerification: true,
        errorMessage: 'Please verify your email before signing in.',
      );
    } on AuthException catch (e) {
      return AppAuthResult(success: false, errorMessage: e.message);
    }
  }

  @override
  Future<AppAuthResult> signOut() async {
    try {
      await Amplify.Auth.signOut();
      return const AppAuthResult(success: true);
    } on AuthException catch (e) {
      return AppAuthResult(success: false, errorMessage: e.message);
    }
  }

  @override
  Future<AppAuthResult> resetPassword(String email) async {
    try {
      await Amplify.Auth.resetPassword(username: email);
      return const AppAuthResult(success: true);
    } on UserNotFoundException {
      return const AppAuthResult(
        success: false,
        errorMessage: 'No account found with this email.',
      );
    } on AuthException catch (e) {
      return AppAuthResult(success: false, errorMessage: e.message);
    }
  }

  @override
  Future<AppAuthResult> confirmResetPassword(
      String email, String newPassword, String code) async {
    try {
      await Amplify.Auth.confirmResetPassword(
        username: email,
        newPassword: newPassword,
        confirmationCode: code,
      );
      return const AppAuthResult(success: true);
    } on CodeMismatchException {
      return const AppAuthResult(
        success: false,
        errorMessage: 'Invalid reset code. Please try again.',
      );
    } on ExpiredCodeException {
      return const AppAuthResult(
        success: false,
        errorMessage: 'Code has expired. Please request a new one.',
      );
    } on AuthException catch (e) {
      return AppAuthResult(success: false, errorMessage: e.message);
    }
  }

  @override
  Future<AppAuthUser?> getCurrentUser() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final emailAttrs = attributes.where(
        (attr) => attr.userAttributeKey == AuthUserAttributeKey.email,
      );
      if (emailAttrs.isNotEmpty) {
        return AppAuthUser(email: emailAttrs.first.value);
      }
      // Fallback — username is the sub (UUID) when no email attribute found
      final user = await Amplify.Auth.getCurrentUser();
      return AppAuthUser(email: user.username);
    } on AuthException {
      return null;
    }
  }
}
