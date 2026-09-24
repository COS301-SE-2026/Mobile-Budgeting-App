import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/services/friend_service.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Friends list: shows the user's friend code, friends, and pending requests.
class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = context.read<AppDatabase>();
    try {
      final userId = await FriendService.instance.getMyUserId();
      final code = await FriendService.instance.getMyFriendCode();
      final friends = await db.friendsDao.getFriends();
      final profiles = await db.friendsDao.getAllProfiles();
      final incoming = await db.friendsDao.getIncomingRequests(userId);
      final outgoing = await db.friendsDao.getOutgoingRequests(userId);

      if (!mounted) return;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load friends: $e')),
      );
    }
  }

  String _otherUserId(Friendship f) =>
      f.userA == _currentUserId ? f.userB : f.userA;

  String _codeFor(String userId) => _codeByUserId[userId] ?? 'Unknown';

  Future<void> _showAddFriendDialog() async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add friend'),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: "Friend's code",
            hintText: 'e.g. AB3DEFG2',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(controller.text.trim()),
            child: const Text('Send'),
          ),
        ],
      ),
    );

    if (code == null || code.isEmpty) return;
    try {
      await FriendService.instance.sendFriendRequest(code);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request sent to $code')),
      );
      await _load();
    } catch (e) {
      if (!mounted) return;
      final message = _friendlyError(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _respond(FriendRequest request, bool accept) async {
    try {
      if (accept) {
        await FriendService.instance.acceptFriendRequest(request.id);
      } else {
        await FriendService.instance.declineFriendRequest(request.id);
      }
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${_friendlyError(e)}')),
      );
    }
  }

  String _friendlyError(Object e) {
    final s = e.toString();
    if (s.contains('404')) return 'Friend code not found';
    if (s.contains('409')) return 'Already friends or request pending';
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    return Scaffold(
      backgroundColor: colours.background,
      appBar: AppBar(
        backgroundColor: colours.background,
        foregroundColor: colours.textPrimary,
        elevation: 0,
        title: const Text('Friends'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _myCodeCard(context),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _showAddFriendDialog,
                    icon: const Icon(Icons.person_add_outlined),
                    label: const Text('Add friend by code'),
                  ),
                  const SizedBox(height: 24),
                  _section('Requests'),
                  if (_incoming.isEmpty && _outgoing.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('No pending requests.'),
                    )
                  else ...[
                    ..._incoming.map(
                      (r) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.person_add_alt_1),
                        title: Text('${_codeFor(r.requesterId)} wants to be friends'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => _respond(r, true),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _respond(r, false),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ..._outgoing.map(
                      (r) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.schedule),
                        title: Text('Request sent to ${_codeFor(r.addresseeId)}'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  _section('Your friends'),
                  if (_friends.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('No friends yet. Add a friend to get started.'),
                    )
                  else
                    ..._friends.map(
                      (f) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.person_outline),
                        title: Text('Friend code: ${_codeFor(_otherUserId(f))}'),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _myCodeCard(BuildContext context) {
    final colours = context.colours;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colours.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colours.secondary.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your friend code',
            style: TextStyle(color: colours.textPrimary, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  _myCode.isEmpty ? '—' : _myCode,
                  style: TextStyle(
                    color: colours.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
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
                icon: const Icon(Icons.copy),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Share this code with friends so they can add you.',
            style: TextStyle(
              color: colours.textPrimary.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
