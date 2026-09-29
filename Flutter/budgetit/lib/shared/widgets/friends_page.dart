import 'package:budgetit/auth/providers/auth_provider.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/services/friend_service.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

/// Friends list: shows the user's friend code, friends, and pending requests.
class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  bool _loading = true;
  String _myCode = '';
  String _currentUserId = '';
  List<Friendship> _friends = [];
  Map<String, String> _codeByUserId = {};
  List<FriendRequest> _incoming = [];
  List<FriendRequest> _outgoing = [];
  bool? _wasLoggedIn;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isLoggedIn = context.watch<AppAuthProvider>().isLoggedIn;
    if (_wasLoggedIn == isLoggedIn) return;
    _wasLoggedIn = isLoggedIn;

    if (isLoggedIn) {
      _loading = true;
      Future<void>.microtask(_load);
    } else {
      FriendService.instance.clearCachedProfile();
      _loading = false;
      _myCode = '';
      _currentUserId = '';
      _friends = [];
      _codeByUserId = {};
      _incoming = [];
      _outgoing = [];
    }
  }

  Future<void> _load() async {
    if (!context.read<AppAuthProvider>().isLoggedIn) return;
    final db = context.read<AppDatabase>();
    try {
      final profile = await FriendService.instance.getMyProfile(refresh: true);
      final userId = profile['user_id'] as String;
      final code = profile['friend_code'] as String;
      final friends = await db.friendsDao.getFriends();
      final profiles = await db.friendsDao.getAllProfiles();
      final incoming = await db.friendsDao.getIncomingRequests(userId);
      final outgoing = await db.friendsDao.getOutgoingRequests(userId);

      if (!mounted || !context.read<AppAuthProvider>().isLoggedIn) return;
      setState(() {
        _currentUserId = userId;
        _myCode = code;
        _friends = friends;
        _codeByUserId = {
          for (final p in profiles)
            if (p.userId != null) p.userId!: p.friendCode,
        };
        _incoming = incoming;
        _outgoing = outgoing;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not load friends: $e')));
    }
  }

  String _otherUserId(Friendship f) =>
      f.userA == _currentUserId ? f.userB : f.userA;

  String _codeFor(String userId) => _codeByUserId[userId] ?? 'Unknown';

  Future<void> _showAddFriendDialog() async {
    if (!context.read<AppAuthProvider>().isLoggedIn) return;
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final colours = dialogContext.colours;
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        final fieldColor = isDark ? colours.background : colours.cardText;
        final fieldTextColor = isDark ? colours.cardText : colours.primary;
        return AlertDialog(
          backgroundColor: isDark ? colours.blendedprimary : colours.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: colours.category, width: 4),
          ),
          title: Text('ADD FRIEND', style: colours.h2),
          content: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            style: colours.b1.copyWith(color: fieldTextColor),
            cursorColor: fieldTextColor,
            decoration: InputDecoration(
              labelText: "Friend's code",
              hintText: 'e.g. AB3DEFG2',
              labelStyle: colours.b1.copyWith(color: fieldTextColor),
              hintStyle: colours.b1.copyWith(
                color: fieldTextColor.withValues(alpha: 0.7),
              ),
              filled: true,
              fillColor: fieldColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: colours.category, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: colours.category, width: 3),
              ),
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: colours.textPrimary,
                side: BorderSide(color: colours.category, width: 3),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text('Cancel', style: colours.b1),
            ),
            OutlinedButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              style: OutlinedButton.styleFrom(
                backgroundColor: isDark ? colours.cardText : colours.primary,
                foregroundColor: isDark ? colours.primary : colours.cardText,
                side: BorderSide(color: colours.category, width: 3),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text(
                'Send',
                style: colours.b1.copyWith(
                  color: isDark ? colours.primary : colours.cardText,
                ),
              ),
            ),
          ],
        );
      },
    );
    controller.dispose();

    if (code == null ||
        code.isEmpty ||
        !context.read<AppAuthProvider>().isLoggedIn)
      return;
    try {
      await FriendService.instance.sendFriendRequest(code);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Friend request sent to $code')));
      await _load();
    } catch (e) {
      if (!mounted) return;
      final message = _friendlyError(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _respond(FriendRequest request, bool accept) async {
    if (!context.read<AppAuthProvider>().isLoggedIn) return;
    try {
      if (accept) {
        await FriendService.instance.acceptFriendRequest(request.id);
      } else {
        await FriendService.instance.declineFriendRequest(request.id);
      }
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: ${_friendlyError(e)}')));
    }
  }

  String _friendlyError(Object e) {
    if (e is DioException) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      if (status == 400) return _apiMessage(data) ?? 'Invalid friend request';
      if (status == 401 || status == 403) {
        return _apiMessage(data) ??
            'Your session has expired. Please log in again.';
      }
      if (status == 404) return _apiMessage(data) ?? 'Friend code not found';
      if (status == 409) {
        return _apiMessage(data) ?? 'Already friends or request pending';
      }
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return 'Cannot reach the Friends server. On a physical phone, set '
            'API_URL to your computer\'s network address.';
      }
    }
    final s = e.toString();
    if (s.contains('404')) return 'Friend code not found';
    if (s.contains('409')) return 'Already friends or request pending';
    return s;
  }

  String? _apiMessage(Object? data) {
    if (data is Map && data['detail'] is String)
      return data['detail'] as String;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final isLoggedIn = context.watch<AppAuthProvider>().isLoggedIn;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? colours.blendedprimary : colours.primary;
    final cardTextColor = colours.cardText;
    return Scaffold(
      backgroundColor: colours.background,
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: colours.background,
              foregroundColor: colours.textPrimary,
              elevation: 0,
              title: Text('Friends', style: colours.h2),
            )
          : null,
      body: !isLoggedIn
          ? _guestPrompt(context)
          : _loading
          ? Center(child: CircularProgressIndicator(color: colours.textPrimary))
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  if (!widget.showAppBar) ...[
                    Text('Friends', style: colours.h2),
                    const SizedBox(height: 16),
                  ],
                  _myCodeCard(context),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _showAddFriendDialog,
                    icon: const Icon(Icons.person_add_outlined),
                    label: const Text('Add friend by code'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: cardColor,
                      foregroundColor: cardTextColor,
                      textStyle: colours.b1,
                      side: BorderSide(color: colours.category, width: 3),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _section('Requests'),
                  if (_incoming.isEmpty && _outgoing.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('No pending requests.', style: colours.b1),
                    )
                  else ...[
                    ..._incoming.map(
                      (r) => _friendTile(
                        icon: Icons.person_add_alt_1,
                        title: '${_codeFor(r.requesterId)} wants to be friends',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.check,
                                color: colours.greenAccents,
                              ),
                              onPressed: () => _respond(r, true),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: colours.error),
                              onPressed: () => _respond(r, false),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ..._outgoing.map(
                      (r) => _friendTile(
                        icon: Icons.schedule,
                        title: 'Request sent to ${_codeFor(r.addresseeId)}',
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  _section('Your friends'),
                  if (_friends.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No friends yet. Add a friend to get started.',
                        style: colours.b1,
                      ),
                    )
                  else
                    ..._friends.map(
                      (f) => _friendTile(
                        icon: Icons.person_outline,
                        title: 'Friend code: ${_codeFor(_otherUserId(f))}',
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _guestPrompt(BuildContext context) {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (!widget.showAppBar) ...[
          Text('Friends', style: colours.h2),
          const SizedBox(height: 16),
        ],
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? colours.blendedprimary : colours.primary,
            border: Border.all(color: colours.category, width: 3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.people_outline, color: colours.cardText, size: 32),
              const SizedBox(height: 12),
              Text(
                'Log in to use Friends',
                style: colours.h2.copyWith(color: colours.cardText),
              ),
              const SizedBox(height: 8),
              Text(
                'You need to log in to get a friend code, add friends, or see friend requests.',
                style: colours.b1.copyWith(color: colours.cardText),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => context.read<AppAuthProvider>().backToLogin(),
                icon: const Icon(Icons.login),
                label: const Text('Log in or sign up'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: colours.cardText,
                  foregroundColor: colours.primary,
                  textStyle: colours.b1,
                  side: BorderSide(color: colours.category, width: 3),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: context.colours.h2),
    );
  }

  Widget _friendTile({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? colours.background : colours.cardText,
        border: Border.all(color: colours.category, width: 3),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(6),
          color: isDark ? colours.blendedprimary : colours.primary,
          child: Icon(icon, color: colours.cardText),
        ),
        title: Text(
          title,
          style: colours.b1.copyWith(
            color: isDark ? colours.cardText : colours.primary,
          ),
        ),
        trailing: trailing,
      ),
    );
  }

  Widget _myCodeCard(BuildContext context) {
    final colours = context.colours;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? colours.blendedprimary
            : colours.primary,
        border: Border.all(color: colours.category, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your friend code',
            style: colours.h4.copyWith(color: colours.cardText),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  _myCode.isEmpty ? '—' : _myCode,
                  style: TextStyle(
                    color: colours.cardText,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontFamily: 'SpaceGrotesk',
                  ),
                ),
              ),
              IconButton(
                onPressed: _myCode.isEmpty
                    ? null
                    : () {
                        Clipboard.setData(ClipboardData(text: _myCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to clipboard')),
                        );
                      },
                icon: Icon(Icons.copy, color: colours.cardText),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Share this code with friends so they can add you.',
            style: colours.b1.copyWith(color: colours.cardText),
          ),
        ],
      ),
    );
  }
}
