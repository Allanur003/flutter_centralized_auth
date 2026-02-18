import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../services/localization.dart';

class SocialChatApp extends StatefulWidget {
  const SocialChatApp({Key? key}) : super(key: key);

  @override
  State<SocialChatApp> createState() => _SocialChatAppState();
}

class _SocialChatAppState extends State<SocialChatApp> {
  int _selectedTab = 0;

  final List<Map<String, dynamic>> _chats = [
    {
      'name': 'John Doe',
      'message': 'Hey! How are you?',
      'time': '10:30 AM',
      'unread': 2,
      'avatar': '👨',
      'online': true,
    },
    {
      'name': 'Sarah Smith',
      'message': 'Let\'s meet tomorrow',
      'time': '9:15 AM',
      'unread': 0,
      'avatar': '👩',
      'online': true,
    },
    {
      'name': 'Mike Johnson',
      'message': 'Thanks for your help!',
      'time': 'Yesterday',
      'unread': 0,
      'avatar': '👨‍💼',
      'online': false,
    },
    {
      'name': 'Emily Brown',
      'message': 'See you soon 😊',
      'time': 'Yesterday',
      'unread': 1,
      'avatar': '👩‍🦰',
      'online': true,
    },
    {
      'name': 'David Wilson',
      'message': 'Great work on the project',
      'time': '2 days ago',
      'unread': 0,
      'avatar': '👨‍🔬',
      'online': false,
    },
  ];

  final List<Map<String, dynamic>> _friends = [
    {'name': 'John Doe', 'status': 'Online', 'avatar': '👨', 'online': true},
    {'name': 'Sarah Smith', 'status': 'Working...', 'avatar': '👩', 'online': true},
    {'name': 'Mike Johnson', 'status': 'Offline', 'avatar': '👨‍💼', 'online': false},
    {'name': 'Emily Brown', 'status': 'Busy', 'avatar': '👩‍🦰', 'online': true},
    {'name': 'David Wilson', 'status': 'Offline', 'avatar': '👨‍🔬', 'online': false},
    {'name': 'Lisa Anderson', 'status': 'Online', 'avatar': '👩‍💻', 'online': true},
    {'name': 'Tom Harris', 'status': 'Away', 'avatar': '👨‍🎓', 'online': true},
  ];

  final List<Map<String, dynamic>> _groups = [
    {'name': 'Family Group', 'members': 8, 'icon': '👨‍👩‍👧‍👦', 'lastMessage': 'Mom: Dinner at 7?'},
    {'name': 'Work Team', 'members': 15, 'icon': '💼', 'lastMessage': 'Boss: Meeting tomorrow'},
    {'name': 'College Friends', 'members': 25, 'icon': '🎓', 'lastMessage': 'Tom: Party this weekend!'},
    {'name': 'Gaming Squad', 'members': 10, 'icon': '🎮', 'lastMessage': 'Mike: Let\'s play tonight'},
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = provider.isDarkMode;
    final locale = provider.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.translate('social_chat', locale)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildTab(0, 'messages', locale, isDark),
                _buildTab(1, 'friends', locale, isDark),
                _buildTab(2, 'groups', locale, isDark),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _selectedTab == 0
                ? _buildChatsTab()
                : _selectedTab == 1
                    ? _buildFriendsTab()
                    : _buildGroupsTab(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.translate('send_message', locale)),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTab(int index, String key, String locale, bool isDark) {
    final isSelected = _selectedTab == index;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            AppLocalizations.translate(key, locale),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? Colors.blue
                  : (isDark ? Colors.white70 : Colors.grey[600]),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatsTab() {
    return ListView.builder(
      itemCount: _chats.length,
      itemBuilder: (ctx, index) {
        final chat = _chats[index];
        return ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue[100],
                child: Text(
                  chat['avatar'],
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              if (chat['online'])
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            chat['name'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            chat['message'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat['time'],
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              if (chat['unread'] > 0) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    chat['unread'].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          onTap: () {
            _showChatDialog(context, chat['name'], chat['avatar']);
          },
        );
      },
    );
  }

  Widget _buildFriendsTab() {
    return ListView.builder(
      itemCount: _friends.length,
      itemBuilder: (ctx, index) {
        final friend = _friends[index];
        return ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.purple[100],
                child: Text(
                  friend['avatar'],
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              if (friend['online'])
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            friend['name'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            friend['status'],
            style: TextStyle(
              color: friend['online'] ? Colors.green : Colors.grey,
              fontSize: 13,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.message, color: Colors.blue),
                onPressed: () {
                  _showChatDialog(context, friend['name'], friend['avatar']);
                },
              ),
              IconButton(
                icon: const Icon(Icons.video_call, color: Colors.green),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGroupsTab() {
    return ListView.builder(
      itemCount: _groups.length,
      itemBuilder: (ctx, index) {
        final group = _groups[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.orange[100],
            child: Text(
              group['icon'],
              style: const TextStyle(fontSize: 28),
            ),
          ),
          title: Text(
            group['name'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            group['lastMessage'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.people, size: 16, color: Colors.grey),
              Text(
                '${group['members']}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          onTap: () {
            _showGroupDialog(context, group['name'], group['icon']);
          },
        );
      },
    );
  }

  void _showChatDialog(BuildContext context, String name, String avatar) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Text(avatar, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(name),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('This is a demo chat interface'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showGroupDialog(BuildContext context, String name, String icon) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(name),
          ],
        ),
        content: const Text('This is a demo group chat interface'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}