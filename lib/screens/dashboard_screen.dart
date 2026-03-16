import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../services/localization.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import '../apps/fashion_store_app.dart';
import '../apps/streamflix_app.dart';
import '../apps/socialchat_app.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _apps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final apps = await provider.getAvailableApps();
    setState(() {
      _apps = apps;
      _isLoading = false;
    });
  }

  void _openApp(String appName, int minAge) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final userAge = provider.currentUser!['age'] as int;
    if (userAge < minAge) {
      _showAgeRestriction(minAge);
      return;
    }
    Widget screen;
    switch (appName) {
      case 'FashionStore':
        screen = const FashionStoreApp();
        break;
      case 'StreamFlix':
        screen = StreamFlixApp(userAge: userAge);
        break;
      case 'SocialChat':
        screen = const SocialChatApp();
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _showAgeRestriction(int minAge) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final locale = provider.locale;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppLocalizations.translate('age_restricted', locale)),
        content: Text('${AppLocalizations.translate('min_age_required', locale)} $minAge'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    await provider.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = provider.isDarkMode;
    final locale = provider.locale;
    final user = provider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.translate('my_apps', locale)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 22),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined, size: 22),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildUserCard(user!, isDark, locale),
                Expanded(
                  child: _apps.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.translate('age_restricted', locale),
                            style: TextStyle(color: isDark ? const Color(0xFF888888) : const Color(0xFF666666)),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.95,
                          ),
                          itemCount: _apps.length,
                          itemBuilder: (ctx, index) {
                            final app = _apps[index];
                            return _AppCard(
                              icon: app['icon'],
                              name: app['name'],
                              description: AppLocalizations.translate(
                                '${app['name'].toLowerCase().replaceAll(' ', '_')}_desc',
                                locale,
                              ),
                              minAge: app['min_age'],
                              isDark: isDark,
                              onTap: () => _openApp(app['name'], app['min_age']),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, bool isDark, String locale) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                user['name'][0].toUpperCase(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user['email'],
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDDDDDD)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                AppLocalizations.translate('profile', locale),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFFAAAAAA) : const Color(0xFF555555),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppCard extends StatelessWidget {
  final String icon;
  final String name;
  final String description;
  final int minAge;
  final bool isDark;
  final VoidCallback onTap;

  const _AppCard({
    Key? key,
    required this.icon,
    required this.name,
    required this.description,
    required this.minAge,
    required this.isDark,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 36)),
            const Spacer(),
            Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF888888) : const Color(0xFF888888),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (minAge > 0) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$minAge+',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFAAAAAA) : const Color(0xFF666666),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
