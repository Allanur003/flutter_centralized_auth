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
        title: Text(AppLocalizations.translate('profile', locale)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 60,
              backgroundColor: isDark ? Colors.blue[700] : Colors.purple[700],
              child: Text(
                user['name'][0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // User Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _ProfileField(
                      label: AppLocalizations.translate('name', locale),
                      value: user['name'],
                      icon: Icons.person,
                    ),
                    const Divider(height: 32),
                    _ProfileField(
                      label: AppLocalizations.translate('email', locale),
                      value: user['email'],
                      icon: Icons.email,
                    ),
                    const Divider(height: 32),
                    _ProfileField(
                      label: AppLocalizations.translate('age', locale),
                      value: user['age'].toString(),
                      icon: Icons.cake,
                    ),
                    const Divider(height: 32),
                    _ProfileField(
                      label: AppLocalizations.translate('account_created', locale),
                      value: user['created_at'] ?? 'N/A',
                      icon: Icons.calendar_today,
                    ),
                    if (user['last_login'] != null) ...[
                      const Divider(height: 32),
                      _ProfileField(
                        label: AppLocalizations.translate('last_login', locale),
                        value: user['last_login'],
                        icon: Icons.access_time,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileField({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[700]),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}