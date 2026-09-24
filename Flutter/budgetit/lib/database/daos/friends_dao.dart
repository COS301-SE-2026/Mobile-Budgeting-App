// daos/friends_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../schema.dart';

part 'friends_dao.g.dart';

/// Data access object for friends, friend requests and user profiles.
///
/// Friend-code resolution and the request lifecycle (send/accept/decline) are
/// server-side via [FriendService]; this DAO reads the rows that PowerSync
/// syncs back down to the local database.
@DriftAccessor(tables: [UserProfiles, FriendRequests, Friendships])
class FriendsDao extends DatabaseAccessor<AppDatabase> with _$FriendsDaoMixin {
  FriendsDao(super.db);

  /// Active friendships involving this user.
  Future<List<Friendship>> getFriends() {
    return (select(friendships)..where((t) => t.deletedAt.isNull())).get();
  }

  /// All profiles synced to this device (own + friends' + request partners').
  Future<List<UserProfile>> getAllProfiles() {
    return (select(userProfiles)).get();
  }

  Future<UserProfile?> getProfileByUserId(String userId) {
    return (select(userProfiles)..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();
  }

  /// Pending requests where [currentUserId] is the recipient.
  Future<List<FriendRequest>> getIncomingRequests(String currentUserId) {
    return (select(friendRequests)
          ..where(
            (t) =>
                t.addresseeId.equals(currentUserId) &
                t.status.equalsValue(FriendRequestStatus.pending) &
                t.deletedAt.isNull(),
          ))
        .get();
  }

  /// Pending requests where [currentUserId] is the sender.
  Future<List<FriendRequest>> getOutgoingRequests(String currentUserId) {
    return (select(friendRequests)
          ..where(
            (t) =>
                t.requesterId.equals(currentUserId) &
                t.status.equalsValue(FriendRequestStatus.pending) &
                t.deletedAt.isNull(),
          ))
        .get();
  }
}
