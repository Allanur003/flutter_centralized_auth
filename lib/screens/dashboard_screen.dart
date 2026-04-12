import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/app_provider.dart';
import '../services/localization.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

// ─── Popular app presets so users can add common apps quickly ─────────────────
const List<Map<String, dynamic>> kPopularApps = [
  {
    'name': 'YouTube',
    'icon': '▶️',
    'android_package': 'com.google.android.youtube',
    'ios_scheme': 'youtube://',
    'fallback_url': 'https://youtube.com',
  },
  {
    'name': 'Instagram',
    'icon': '📸',
    'android_package': 'com.instagram.android',
    'ios_scheme': 'instagram://',
    'fallback_url': 'https://instagram.com',
  },
  {
    'name': 'WhatsApp',
    'icon': '💬',
    'android_package': 'com.whatsapp',
    'ios_scheme': 'whatsapp://',
    'fallback_url': 'https://whatsapp.com',
  },
  {
    'name': 'TikTok',
    'icon': '🎵',
    'android_package': 'com.zhiliaoapp.musically',
    'ios_scheme': 'tiktok://',
    'fallback_url': 'https://tiktok.com',
  },
  {
    'name': 'Twitter/X',
    'icon': '🐦',
    'android_package': 'com.twitter.android',
    'ios_scheme': 'twitter://',
    'fallback_url': 'https://twitter.com',
  },
  {
    'name': 'Telegram',
    'icon': '✈️',
    'android_package': 'org.telegram.messenger',
    'ios_scheme': 'tg://',
    'fallback_url': 'https://telegram.org',
  },
  {
    'name': 'Google Maps',
    'icon': '🗺️',
    'android_package': 'com.google.android.apps.maps',
    'ios_scheme': 'comgooglemaps://',
    'fallback_url': 'https://maps.google.com',
  },
  {
    'name': 'Spotify',
    'icon': '🎧',
    'android_package': 'com.spotify.music',
    'ios_scheme': 'spotify://',
    'fallback_url': 'https://spotify.com',
  },
  {
    'name': 'Netflix',
    'icon': '🎬',
    'android_package': 'com.netflix.mediaclient',
    'ios_scheme': 'nflx://',
    'fallback_url': 'https://netflix.com',
  },
  {
    'name': 'Facebook',
    'icon': '👥',
    'android_package': 'com.facebook.katana',
    'ios_scheme': 'fb://',
    'fallback_url': 'https://facebook.com',
  },
  {
    'name': 'Gmail',
    'icon': '📧',
    'android_package': 'com.google.android.gm',
    'ios_scheme': 'googlegmail://',
    'fallback_url': 'https://mail.google.com',
  },
  {
    'name': 'Google Chrome',
    'icon': '🌐',
    'android_package': 'com.android.chrome',
    'ios_scheme': 'googlechrome://',
    'fallback_url': 'https://google.com',
  },
  {
    'name': 'Amazon',
    'icon': '🛍️',
    'android_package': 'com.amazon.mShop.android.shopping',
    'ios_scheme': 'com.amazon.mobile.shopping://',
    'fallback_url': 'https://amazon.com',
  },
  {
    'name': 'Snapchat',
    'icon': '👻',
    'android_package': 'com.snapchat.android',
    'ios_scheme': 'snapchat://',
    'fallback_url': 'https://snapchat.com',
  },
  {
    'name': 'LinkedIn',
    'icon': '💼',
    'android_package': 'com.linkedin.android',
    'ios_scheme': 'linkedin://',
    'fallback_url': 'https://linkedin.com',
  },
  {
    'name': 'Reddit',
    'icon': '🤖',
    'android_package': 'com.reddit.frontpage',
    'ios_scheme': 'reddit://',
    'fallback_url': 'https://reddit.com',
  },
];

// ─── Dashboard Screen ─────────────────────────────────────────────────────────

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _apps = [];
  bool _isLoading = true;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final apps = await provider.getUserApps();
    if (mounted) {
      setState(() {
        _apps = apps;
        _isLoading = false;
      });
    }
  }

  // ── Launch an app ──────────────────────────────────────────────────────────

  Future<void> _launchApp(Map<String, dynamic> app) async {
    final String? androidPackage = app['android_package'];
    final String? iosScheme = app['ios_scheme'];
    final String? fallbackUrl = app['fallback_url'];

    bool launched = false;

    try {
      if (Platform.isAndroid && androidPackage != null && androidPackage.isNotEmpty) {
        // Try to open via Android intent (market scheme or direct intent)
        final intentUri = Uri.parse('intent://#Intent;package=$androidPackage;end');
        // Simpler approach: use android-app scheme
        final androidUri = Uri.parse('android-app://$androidPackage');
        if (await canLaunchUrl(androidUri)) {
          launched = await launchUrl(androidUri, mode: LaunchMode.externalApplication);
        }
      } else if (Platform.isIOS && iosScheme != null && iosScheme.isNotEmpty) {
        final iosUri = Uri.parse(iosScheme);
        if (await canLaunchUrl(iosUri)) {
          launched = await launchUrl(iosUri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (_) {}

    // Fallback: open in browser
    if (!launched && fallbackUrl != null && fallbackUrl.isNotEmpty) {
      try {
        final uri = Uri.parse(fallbackUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          launched = true;
        }
      } catch (_) {}
    }

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open ${app['name']}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  Future<void> _handleLogout() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    await provider.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  // ── Add / Edit Sheet ───────────────────────────────────────────────────────

  void _showAddAppSheet({Map<String, dynamic>? existingApp}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddAppSheet(
        existingApp: existingApp,
        onSave: (name, icon, androidPkg, iosScheme, fallbackUrl) async {
          final provider = Provider.of<AppProvider>(context, listen: false);
          if (existingApp != null) {
            await provider.updateApp(
              appId: existingApp['id'],
              name: name,
              icon: icon,
              androidPackage: androidPkg,
              iosScheme: iosScheme,
              fallbackUrl: fallbackUrl,
            );
          } else {
            await provider.addApp(
              name: name,
              icon: icon,
              androidPackage: androidPkg,
              iosScheme: iosScheme,
              fallbackUrl: fallbackUrl,
            );
          }
          await _loadApps();
        },
      ),
    );
  }

  void _showQuickAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _QuickAddSheet(
        onAdd: (preset) async {
          final provider = Provider.of<AppProvider>(context, listen: false);
          await provider.addApp(
            name: preset['name'],
            icon: preset['icon'],
            androidPackage: preset['android_package'],
            iosScheme: preset['ios_scheme'],
            fallbackUrl: preset['fallback_url'],
          );
          await _loadApps();
        },
      ),
    );
  }

  Future<void> _deleteApp(Map<String, dynamic> app) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    await provider.removeApp(app['id']);
    await _loadApps();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

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
          if (_apps.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => _isEditMode = !_isEditMode),
              child: Text(
                _isEditMode ? 'Done' : 'Edit',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 22),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
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
                      ? _buildEmptyState(isDark)
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.88,
                          ),
                          itemCount: _apps.length,
                          itemBuilder: (ctx, index) {
                            final app = _apps[index];
                            return _AppTile(
                              app: app,
                              isDark: isDark,
                              isEditMode: _isEditMode,
                              onTap: () => _launchApp(app),
                              onEdit: () => _showAddAppSheet(existingApp: app),
                              onDelete: () => _deleteApp(app),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: _isEditMode
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.small(
                  heroTag: 'quick_add',
                  onPressed: _showQuickAddSheet,
                  backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                  foregroundColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  elevation: 2,
                  child: const Icon(Icons.apps, size: 20),
                  tooltip: 'Popular Apps',
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'add_custom',
                  onPressed: () => _showAddAppSheet(),
                  backgroundColor: const Color(0xFF1A1A1A),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  child: const Icon(Icons.add),
                  tooltip: 'Add Custom App',
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('📱', style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 20),
          Text(
            'No apps yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add apps from your phone',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showQuickAddSheet,
            icon: const Icon(Icons.apps, size: 18),
            label: const Text('Browse Popular Apps'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, bool isDark, String locale) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                user['name'][0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  user['email'],
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                    color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDDDDDD)),
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

// ─── App Tile ─────────────────────────────────────────────────────────────────

class _AppTile extends StatelessWidget {
  final Map<String, dynamic> app;
  final bool isDark;
  final bool isEditMode;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AppTile({
    Key? key,
    required this.app,
    required this.isDark,
    required this.isEditMode,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEditMode ? onEdit : onTap,
      onLongPress: isEditMode ? null : () {
        // Long press = edit mode shortcut
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => _AppActionSheet(
            app: app,
            isDark: isDark,
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  app['icon'] ?? '📱',
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  app['name'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (isEditMode)
            Positioned(
              top: -6,
              right: -6,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF3B30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── App Action Sheet (long press) ───────────────────────────────────────────

class _AppActionSheet extends StatelessWidget {
  final Map<String, dynamic> app;
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AppActionSheet({
    Key? key,
    required this.app,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(app['icon'] ?? '📱', style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Text(
                  app['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.edit_outlined,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
            title: Text('Edit',
                style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1A1A))),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Color(0xFFFF3B30)),
            title: const Text('Remove', style: TextStyle(color: Color(0xFFFF3B30))),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─── Add / Edit App Sheet ─────────────────────────────────────────────────────

typedef _OnSaveApp = void Function(
    String name, String icon, String? androidPkg, String? iosScheme, String? fallbackUrl);

class _AddAppSheet extends StatefulWidget {
  final Map<String, dynamic>? existingApp;
  final _OnSaveApp onSave;

  const _AddAppSheet({Key? key, this.existingApp, required this.onSave}) : super(key: key);

  @override
  State<_AddAppSheet> createState() => _AddAppSheetState();
}

class _AddAppSheetState extends State<_AddAppSheet> {
  final _nameCtrl = TextEditingController();
  final _iconCtrl = TextEditingController();
  final _androidCtrl = TextEditingController();
  final _iosCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingApp != null) {
      final a = widget.existingApp!;
      _nameCtrl.text = a['name'] ?? '';
      _iconCtrl.text = a['icon'] ?? '📱';
      _androidCtrl.text = a['android_package'] ?? '';
      _iosCtrl.text = a['ios_scheme'] ?? '';
      _urlCtrl.text = a['fallback_url'] ?? '';
    } else {
      _iconCtrl.text = '📱';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _iconCtrl.dispose();
    _androidCtrl.dispose();
    _iosCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) return;
    widget.onSave(
      _nameCtrl.text.trim(),
      _iconCtrl.text.trim().isEmpty ? '📱' : _iconCtrl.text.trim(),
      _androidCtrl.text.trim().isEmpty ? null : _androidCtrl.text.trim(),
      _iosCtrl.text.trim().isEmpty ? null : _iosCtrl.text.trim(),
      _urlCtrl.text.trim().isEmpty ? null : _urlCtrl.text.trim(),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final isDark = provider.isDarkMode;
    final isEdit = widget.existingApp != null;

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEdit ? 'Edit App' : 'Add Custom App',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close,
                        color: isDark ? const Color(0xFF888888) : const Color(0xFF666666)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildField('App Name *', _nameCtrl, isDark, hint: 'e.g. YouTube'),
              const SizedBox(height: 14),
              _buildField('Icon (emoji)', _iconCtrl, isDark, hint: '📱'),
              const SizedBox(height: 14),
              _buildField('Android Package', _androidCtrl, isDark,
                  hint: 'e.g. com.google.android.youtube'),
              const SizedBox(height: 14),
              _buildField('iOS URL Scheme', _iosCtrl, isDark,
                  hint: 'e.g. youtube://'),
              const SizedBox(height: 14),
              _buildField('Fallback URL', _urlCtrl, isDark,
                  hint: 'e.g. https://youtube.com'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(isEdit ? 'Save Changes' : 'Add App'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, bool isDark,
      {String hint = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFFAAAAAA) : const Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

// ─── Quick Add Sheet (popular apps) ──────────────────────────────────────────

class _QuickAddSheet extends StatelessWidget {
  final void Function(Map<String, dynamic> preset) onAdd;

  const _QuickAddSheet({Key? key, required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final isDark = provider.isDarkMode;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Apps',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close,
                      color: isDark ? const Color(0xFF888888) : const Color(0xFF666666)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: kPopularApps.length,
              itemBuilder: (ctx, i) {
                final app = kPopularApps[i];
                return GestureDetector(
                  onTap: () {
                    onAdd(app);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(app['icon'], style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 6),
                        Text(
                          app['name'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
