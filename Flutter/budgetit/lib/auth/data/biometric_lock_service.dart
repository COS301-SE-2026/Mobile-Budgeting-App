import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

abstract class BiometricLockService {
  Future<bool> isEnabled(String userId);
  Future<void> setEnabled(String userId, bool enabled);
  Future<bool> canAuthenticate();
  Future<bool> authenticate();
}

class DeviceBiometricLockService implements BiometricLockService {
  DeviceBiometricLockService({
    LocalAuthentication? localAuth,
    FlutterSecureStorage? storage,
  }) : _localAuth = localAuth ?? LocalAuthentication(),
       _storage = storage ?? const FlutterSecureStorage();

  final LocalAuthentication _localAuth;
  final FlutterSecureStorage _storage;

  String _key(String userId) => 'biometric_lock:$userId';

  @override
  Future<bool> isEnabled(String userId) async =>
      await _storage.read(key: _key(userId)) == 'true';

  @override
  Future<void> setEnabled(String userId, bool enabled) async {
    if (enabled) {
      await _storage.write(key: _key(userId), value: 'true');
    } else {
      await _storage.delete(key: _key(userId));
    }
  }

  @override
  Future<bool> canAuthenticate() => _localAuth.canCheckBiometrics;

  @override
  Future<bool> authenticate() => _localAuth.authenticate(
    localizedReason: 'Unlock your Budgetit account',
    biometricOnly: true,
  );
}
