import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../services/localization.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = provider.isDarkMode;
    final locale = provider.locale;
    final user = provider.currentUser!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppLocalizations.translate('profile', locale)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  user['name'][0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user['name'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user['email'],
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoCard(isDark, locale, user),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDark, String locale, Map<String, dynamic> user) {
    final fields = [
      {'label': AppLocalizations.translate('name', locale), 'value': user['name'], 'icon': Icons.person_outline},
      {'label': AppLocalizations.translate('email', locale), 'value': user['email'], 'icon': Icons.email_outlined},
      {'label': AppLocalizations.translate('age', locale), 'value': user['age'].toString(), 'icon': Icons.calendar_today_outlined},
      {'label': AppLocalizations.translate('account_created', locale), 'value': user['created_at'] ?? 'N/A', 'icon': Icons.access_time_outlined},
      if (user['last_login'] != null)
        {'label': AppLocalizations.translate('last_login', locale), 'value': user['last_login'], 'icon': Icons.login_outlined},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: fields.asMap().entries.map((entry) {
          final index = entry.key;
          final field = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Icon(
                      field['icon'] as IconData,
                      size: 18,
                      color: isDark ? const Color(0xFF888888) : const Color(0xFF888888),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            field['label'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF888888) : const Color(0xFF888888),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            field['value'] as String,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (index < fields.length - 1)
                Divider(height: 1, color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
