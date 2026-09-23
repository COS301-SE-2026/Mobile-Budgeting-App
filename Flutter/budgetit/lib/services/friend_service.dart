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

  final Dio _dio = Dio();
  final CognitoAuthService _auth = CognitoAuthService();

  Map<String, dynamic>? _myProfile;

  /// Returns the caller's profile, creating it (with a friend code) on the
  /// server if it does not yet exist. Cached in memory.
  Future<Map<String, dynamic>> getMyProfile({bool refresh = false}) async {
    if (_myProfile != null && !refresh) return _myProfile!;
    final token = await _auth.getJWT();
    final res = await _dio.get(
      '${AppConfig.apiUrl}/me/profile',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    _myProfile = Map<String, dynamic>.from(res.data as Map);
    return _myProfile!;
  }

  Future<String> getMyUserId() async => (await getMyProfile())['user_id'] as String;

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
