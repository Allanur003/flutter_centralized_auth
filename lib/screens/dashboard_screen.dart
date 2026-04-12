import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_apps/device_apps.dart';
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
      final provider = Provider.of<AppProvider>(context, listen: false);
      final locale = provider.locale;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.translate('could_not_open', locale)} ${app['name']}'),
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

  // ── NEW: Pick from installed apps on the device ────────────────────────────

  void _showInstalledAppsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InstalledAppsSheet(
        onAdd: (app) async {
          final provider = Provider.of<AppProvider>(context, listen: false);
          final locale = provider.locale;
          await provider.addApp(
            name: app.appName,
            icon: '📱',
            androidPackage: app.packageName,
            iosScheme: null,
            fallbackUrl: null,
          );
          await _loadApps();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${app.appName} ${AppLocalizations.translate('app_added', locale)}'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }
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
                _isEditMode
                    ? AppLocalizations.translate('done', locale)
                    : AppLocalizations.translate('edit', locale),
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
                      ? _buildEmptyState(isDark, locale)
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
                // Button 1: Apps on My Phone (NEW)
                if (Platform.isAndroid)
                  FloatingActionButton.small(
                    heroTag: 'from_phone',
                    onPressed: _showInstalledAppsSheet,
                    backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                    foregroundColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    elevation: 2,
                    tooltip: AppLocalizations.translate('add_from_phone', locale),
                    child: const Icon(Icons.phone_android, size: 20),
                  ),
                if (Platform.isAndroid) const SizedBox(height: 10),
                // Button 2: Popular apps preset
                FloatingActionButton.small(
                  heroTag: 'quick_add',
                  onPressed: _showQuickAddSheet,
                  backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                  foregroundColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  elevation: 2,
                  child: const Icon(Icons.apps, size: 20),
                  tooltip: AppLocalizations.translate('popular_apps', locale),
                ),
                const SizedBox(height: 10),
                // Button 3: Add custom
                FloatingActionButton(
                  heroTag: 'add_custom',
                  onPressed: () => _showAddAppSheet(),
                  backgroundColor: const Color(0xFF1A1A1A),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  child: const Icon(Icons.add),
                  tooltip: AppLocalizations.translate('add_custom_app', locale),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(bool isDark, String locale) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📱', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.translate('no_apps_yet', locale),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.translate('add_apps_hint', locale),
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 32),
          if (Platform.isAndroid)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton.icon(
                onPressed: _showInstalledAppsSheet,
                icon: const Icon(Icons.phone_android, size: 18),
                label: Text(AppLocalizations.translate('add_from_phone', locale)),
              ),
            ),
          ElevatedButton.icon(
            onPressed: _showQuickAddSheet,
            icon: const Icon(Icons.apps, size: 18),
            label: Text(AppLocalizations.translate('browse_popular_apps', locale)),
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
    final locale = Provider.of<AppProvider>(context, listen: false).locale;
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
            title: Text(AppLocalizations.translate('edit', locale),
                style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1A1A))),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Color(0xFFFF3B30)),
            title: Text(AppLocalizations.translate('remove', locale),
                style: const TextStyle(color: Color(0xFFFF3B30))),
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
    final locale = provider.locale;
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
                    isEdit
                        ? AppLocalizations.translate('edit_app', locale)
                        : AppLocalizations.translate('add_custom_app', locale),
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
              _buildField(AppLocalizations.translate('app_name_required', locale), _nameCtrl, isDark,
                  hint: 'e.g. YouTube'),
              const SizedBox(height: 14),
              _buildField(AppLocalizations.translate('icon_emoji', locale), _iconCtrl, isDark,
                  hint: '📱'),
              const SizedBox(height: 14),
              _buildField(AppLocalizations.translate('android_package', locale), _androidCtrl, isDark,
                  hint: 'e.g. com.google.android.youtube'),
              const SizedBox(height: 14),
              _buildField(AppLocalizations.translate('ios_url_scheme', locale), _iosCtrl, isDark,
                  hint: 'e.g. youtube://'),
              const SizedBox(height: 14),
              _buildField(AppLocalizations.translate('fallback_url', locale), _urlCtrl, isDark,
                  hint: 'e.g. https://youtube.com'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(isEdit
                      ? AppLocalizations.translate('save_changes', locale)
                      : AppLocalizations.translate('add_app', locale)),
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
    final locale = provider.locale;

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
                  AppLocalizations.translate('popular_apps', locale),
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

// ─── NEW: Installed Apps Sheet ────────────────────────────────────────────────

class _InstalledAppsSheet extends StatefulWidget {
  final void Function(Application app) onAdd;

  const _InstalledAppsSheet({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<_InstalledAppsSheet> createState() => _InstalledAppsSheetState();
}

class _InstalledAppsSheetState extends State<_InstalledAppsSheet> {
  List<Application> _allApps = [];
  List<Application> _filteredApps = [];
  bool _isLoading = true;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInstalledApps();
    _searchCtrl.addListener(_filterApps);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_filterApps);
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadInstalledApps() async {
    // Only include apps that can be launched (excludes system services)
    final apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: false,
      onlyAppsWithLaunchIntent: true,
    );
    // Sort alphabetically
    apps.sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
    if (mounted) {
      setState(() {
        _allApps = apps;
        _filteredApps = apps;
        _isLoading = false;
      });
    }
  }

  void _filterApps() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredApps = _allApps
          .where((app) => app.appName.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final isDark = provider.isDarkMode;
    final locale = provider.locale;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scrollController) {
        return Container(
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.translate('add_from_phone', locale),
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
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  controller: _searchCtrl,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.translate('search_apps', locale),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              // Subtitle hint
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(
                  AppLocalizations.translate('select_to_add', locale),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF888888) : const Color(0xFF888888),
                  ),
                ),
              ),
              const Divider(height: 1),
              // App list
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.translate('loading_apps', locale),
                              style: TextStyle(
                                color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      )
                    : _filteredApps.isEmpty
                        ? Center(
                            child: Text(
                              AppLocalizations.translate('no_apps_found', locale),
                              style: TextStyle(
                                color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: _filteredApps.length,
                            itemBuilder: (ctx, i) {
                              final app = _filteredApps[i];
                              final appWithIcon = app is ApplicationWithIcon ? app : null;
                              return InkWell(
                                onTap: () {
                                  widget.onAdd(app);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    children: [
                                      // App icon
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: isDark
                                              ? const Color(0xFF2A2A2A)
                                              : const Color(0xFFF0F0F0),
                                        ),
                                        child: appWithIcon != null
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Image.memory(
                                                  appWithIcon.icon,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : const Icon(Icons.android, size: 28),
                                      ),
                                      const SizedBox(width: 14),
                                      // App info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              app.appName,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                                              ),
                                            ),
                                            Text(
                                              app.packageName,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isDark
                                                    ? const Color(0xFF666666)
                                                    : const Color(0xFF999999),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Add icon
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: isDark
                                            ? const Color(0xFF666666)
                                            : const Color(0xFFBBBBBB),
                                        size: 22,
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
      },
    );
  }
}
