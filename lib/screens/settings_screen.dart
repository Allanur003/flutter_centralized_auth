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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppLocalizations.translate('settings', locale)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionLabel(AppLocalizations.translate('appearance', locale), isDark),
          const SizedBox(height: 8),
          _buildCard(
            isDark,
            children: [
              _buildSwitchTile(
                isDark: isDark,
                icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                title: AppLocalizations.translate('theme', locale),
                subtitle: isDark
                    ? AppLocalizations.translate('dark_mode', locale)
                    : AppLocalizations.translate('light_mode', locale),
                value: isDark,
                onChanged: (_) => provider.toggleTheme(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionLabel(AppLocalizations.translate('language', locale), isDark),
          const SizedBox(height: 8),
          _buildCard(
            isDark,
            children: AppLocalizations.supportedLocales.asMap().entries.map((entry) {
              final index = entry.key;
              final loc = entry.value;
              final isLast = index == AppLocalizations.supportedLocales.length - 1;
              return Column(
                children: [
                  InkWell(
                    onTap: () => provider.changeLanguage(loc),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.getLanguageName(loc),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.getFullLanguageName(loc),
                            style: TextStyle(
                              fontSize: 15,
                              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                            ),
                          ),
                          const Spacer(),
                          if (locale == loc)
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                size: 13,
                                color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                              ),
                            )
                          else
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDDDDDD),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(height: 1, color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label, bool isDark) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: isDark ? const Color(0xFF666666) : const Color(0xFF888888),
      ),
    );
  }

  Widget _buildCard(bool isDark, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isDark ? const Color(0xFF888888) : const Color(0xFF666666)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF888888) : const Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ],
      ),
    );
  }
}
