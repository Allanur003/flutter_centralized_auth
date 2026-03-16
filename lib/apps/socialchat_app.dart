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
    {'name': 'John Doe', 'message': 'Hey! How are you?', 'time': '10:30', 'unread': 2, 'avatar': '👨', 'online': true},
    {'name': 'Sarah Smith', 'message': 'Let\'s meet tomorrow', 'time': '9:15', 'unread': 0, 'avatar': '👩', 'online': true},
    {'name': 'Mike Johnson', 'message': 'Thanks for your help!', 'time': 'Yesterday', 'unread': 0, 'avatar': '👨‍💼', 'online': false},
    {'name': 'Emily Brown', 'message': 'See you soon 😊', 'time': 'Yesterday', 'unread': 1, 'avatar': '👩‍🦰', 'online': true},
    {'name': 'David Wilson', 'message': 'Great work on the project', 'time': '2d ago', 'unread': 0, 'avatar': '👨‍🔬', 'online': false},
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppLocalizations.translate('social_chat', locale)),
        actions: [
          IconButton(icon: const Icon(Icons.search_outlined, size: 22), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert_outlined, size: 22), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(isDark, locale),
          Expanded(
            child: _selectedTab == 0
                ? _buildChatsTab(isDark)
                : _selectedTab == 1
                    ? _buildFriendsTab(isDark)
                    : _buildGroupsTab(isDark),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.translate('send_message', locale)),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        backgroundColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
        foregroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        elevation: 2,
        child: const Icon(Icons.edit_outlined, size: 22),
      ),
    );
  }

  Widget _buildTabBar(bool isDark, String locale) {
    final tabs = ['messages', 'friends', 'groups'];
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? (isDark ? Colors.white : const Color(0xFF1A1A1A))
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  AppLocalizations.translate(tab, locale),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? (isDark ? Colors.white : const Color(0xFF1A1A1A))
                        : (isDark ? const Color(0xFF888888) : const Color(0xFF888888)),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChatsTab(bool isDark) {
    return ListView.separated(
      itemCount: _chats.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        indent: 80,
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE),
      ),
      itemBuilder: (ctx, index) {
        final chat = _chats[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: _buildAvatar(chat['avatar'] as String, chat['online'] as bool, isDark),
          title: Text(
            chat['name'] as String,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          subtitle: Text(
            chat['message'] as String,
            style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF888888) : const Color(0xFF888888)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat['time'] as String,
                style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF888888) : const Color(0xFF888888)),
              ),
              if ((chat['unread'] as int) > 0) ...[
                const SizedBox(height: 4),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${chat['unread']}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          onTap: () => _showChatDialog(context, chat['name'] as String, chat['avatar'] as String, isDark),
        );
      },
    );
  }

  Widget _buildFriendsTab(bool isDark) {
    return ListView.separated(
      itemCount: _friends.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        indent: 80,
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE),
      ),
      itemBuilder: (ctx, index) {
        final friend = _friends[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: _buildAvatar(friend['avatar'] as String, friend['online'] as bool, isDark),
          title: Text(
            friend['name'] as String,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          subtitle: Text(
            friend['status'] as String,
            style: TextStyle(
              fontSize: 13,
              color: (friend['online'] as bool) ? const Color(0xFF2E7D32) : (isDark ? const Color(0xFF888888) : const Color(0xFF888888)),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionIcon(Icons.chat_bubble_outline, isDark, () => _showChatDialog(context, friend['name'] as String, friend['avatar'] as String, isDark)),
              const SizedBox(width: 4),
              _buildActionIcon(Icons.videocam_outlined, isDark, () {}),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGroupsTab(bool isDark) {
    return ListView.separated(
      itemCount: _groups.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        indent: 80,
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE),
      ),
      itemBuilder: (ctx, index) {
        final group = _groups[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(group['icon'] as String, style: const TextStyle(fontSize: 24)),
            ),
          ),
          title: Text(
            group['name'] as String,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          subtitle: Text(
            group['lastMessage'] as String,
            style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF888888) : const Color(0xFF888888)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.group_outlined, size: 16, color: isDark ? const Color(0xFF888888) : const Color(0xFF888888)),
              const SizedBox(height: 2),
              Text(
                '${group['members']}',
                style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF888888) : const Color(0xFF888888)),
              ),
            ],
          ),
          onTap: () => _showGroupDialog(context, group['name'] as String, group['icon'] as String, isDark),
        );
      },
    );
  }

  Widget _buildAvatar(String emoji, bool online, bool isDark) {
    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
        ),
        if (online)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? const Color(0xFF121212) : Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon, bool isDark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: isDark ? const Color(0xFF888888) : const Color(0xFF666666)),
      ),
    );
  }

  void _showChatDialog(BuildContext context, String name, String avatar, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Text(avatar, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Text(name, style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1A1A), fontSize: 17)),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'This is a demo chat interface.',
            style: TextStyle(color: isDark ? const Color(0xFFAAAAAA) : const Color(0xFF555555)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: isDark ? const Color(0xFF888888) : const Color(0xFF666666))),
          ),
        ],
      ),
    );
  }

  void _showGroupDialog(BuildContext context, String name, String icon, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Text(name, style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1A1A), fontSize: 17)),
          ],
        ),
        content: Text(
          'This is a demo group chat interface.',
          style: TextStyle(color: isDark ? const Color(0xFFAAAAAA) : const Color(0xFF555555)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: isDark ? const Color(0xFF888888) : const Color(0xFF666666))),
          ),
        ],
      ),
    );
  }
}
