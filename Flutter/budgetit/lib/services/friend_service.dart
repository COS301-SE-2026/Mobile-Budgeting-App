import 'package:budgetit/auth/data/cognito_auth_service.dart';
import 'package:budgetit/config/app_config.dart';
import 'package:dio/dio.dart';

/// Thin client for the backend's friends/profile endpoints.
///
/// Friend-code resolution and request lifecycle are server-side, so these
/// operations go through the FastAPI backend rather than the PowerSync CRUD
/// queue. The resulting rows are synced back down to clients via PowerSync.
class FriendService {
  FriendService._();

  static final FriendService instance = FriendService._();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );
  final CognitoAuthService _auth = CognitoAuthService();

  Map<String, dynamic>? _myProfile;
  int _sessionVersion = 0;

  Map<String, dynamic>? get cachedProfile => _myProfile;

  /// Clears profile data that belongs to the previously authenticated user.
  void clearCachedProfile() {
    _sessionVersion++;
    _myProfile = null;
  }

  /// Returns the caller's profile, creating it (with a friend code) on the
  /// server if it does not yet exist. Cached in memory.
  Future<Map<String, dynamic>> getMyProfile({bool refresh = false}) async {
    if (_myProfile != null && !refresh) return _myProfile!;
    final sessionVersion = _sessionVersion;
    final token = await _auth.getJWT().timeout(const Duration(seconds: 10));
    final res = await _dio.get(
      '${AppConfig.apiUrl}/me/profile',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final profile = Map<String, dynamic>.from(res.data as Map);
    if (sessionVersion == _sessionVersion) _myProfile = profile;
    return profile;
  }

  Future<String> getMyUserId() async =>
      (await getMyProfile())['user_id'] as String;

  Future<String> getMyFriendCode() async =>
      (await getMyProfile())['friend_code'] as String;

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final token = await _auth.getJWT();
    final res = await _dio.post(
      '${AppConfig.apiUrl}$path',
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return Map<String, dynamic>.from(res.data as Map);
  }

  Future<void> sendFriendRequest(String friendCode) async {
    await _post('/friends/request', {'friend_code': friendCode});
  }

  Future<void> acceptFriendRequest(String requestId) async {
    await _post('/friends/accept', {'request_id': requestId});
  }

  Future<void> declineFriendRequest(String requestId) async {
    await _post('/friends/decline', {'request_id': requestId});
  }
}
