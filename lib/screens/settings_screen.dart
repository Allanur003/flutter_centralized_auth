import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../services/localization.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = provider.isDarkMode;
    final locale = provider.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.translate('settings', locale)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Setting
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: Colors.blue[700],
              ),
              title: Text(AppLocalizations.translate('theme', locale)),
              subtitle: Text(
                isDark
                    ? AppLocalizations.translate('dark_mode', locale)
                    : AppLocalizations.translate('light_mode', locale),
              ),
              trailing: Switch(
                value: isDark,
                onChanged: (_) => provider.toggleTheme(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Language Setting
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.language, color: Colors.blue[700]),
                  title: Text(AppLocalizations.translate('language', locale)),
                  subtitle: Text(AppLocalizations.getLanguageName(locale)),
                ),
                const Divider(height: 1),
                ...AppLocalizations.supportedLocales.map((loc) {
                  return RadioListTile<String>(
                    title: Text(AppLocalizations.getLanguageName(loc)),
                    value: loc,
                    groupValue: locale,
                    onChanged: (value) {
                      if (value != null) {
                        provider.changeLanguage(value);
                      }
                    },
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Profile Info
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.blue[700]),
              title: Text(AppLocalizations.translate('profile', locale)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}