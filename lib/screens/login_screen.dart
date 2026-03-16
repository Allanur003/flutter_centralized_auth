import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../services/localization.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final provider = Provider.of<AppProvider>(context, listen: false);
    final success = await provider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    setState(() => _isLoading = false);
    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.translate('invalid_credentials', provider.locale)),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = provider.isDarkMode;
    final locale = provider.locale;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  _buildHeader(isDark, locale),
                  const SizedBox(height: 40),
                  _buildForm(isDark, locale),
                  const SizedBox(height: 32),
                  _buildDivider(isDark),
                  const SizedBox(height: 24),
                  _buildLanguageSelector(provider, locale, isDark),
                  const SizedBox(height: 16),
                  _buildThemeToggle(provider, isDark, locale),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, String locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.lock_outline_rounded,
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          AppLocalizations.translate('welcome', locale),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppLocalizations.translate('sign_in_to_continue', locale),
          style: TextStyle(
            fontSize: 15,
            color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(bool isDark, String locale) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
            decoration: InputDecoration(
              labelText: AppLocalizations.translate('email', locale),
              prefixIcon: Icon(Icons.email_outlined, size: 20, color: isDark ? const Color(0xFF888888) : const Color(0xFF666666)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              if (!value.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
            decoration: InputDecoration(
              labelText: AppLocalizations.translate('password', locale),
              prefixIcon: Icon(Icons.lock_outline, size: 20, color: isDark ? const Color(0xFF888888) : const Color(0xFF666666)),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 20,
                  color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              if (value.length < 6) return 'Min. 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                      ),
                    )
                  : Text(AppLocalizations.translate('login', locale)),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
            child: Center(
              child: Text(
                AppLocalizations.translate('no_account', locale),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? const Color(0xFFAAAAAA) : const Color(0xFF555555),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0));
  }

  Widget _buildLanguageSelector(AppProvider provider, String locale, bool isDark) {
    return Row(
      children: [
        Text(
          AppLocalizations.translate('language', locale),
          style: TextStyle(
            fontSize: 13,
            color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
          ),
        ),
        const SizedBox(width: 12),
        ...AppLocalizations.supportedLocales.map((loc) {
          final isSelected = locale == loc;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => provider.changeLanguage(loc),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF1A1A1A))
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDDDDDD)),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  AppLocalizations.getLanguageName(loc),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? (isDark ? const Color(0xFF1A1A1A) : Colors.white)
                        : (isDark ? const Color(0xFF888888) : const Color(0xFF666666)),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildThemeToggle(AppProvider provider, bool isDark, String locale) {
    return Row(
      children: [
        Text(
          AppLocalizations.translate('theme', locale),
          style: TextStyle(
            fontSize: 13,
            color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => provider.toggleTheme(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDDDDDD)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  size: 16,
                  color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
                ),
                const SizedBox(width: 6),
                Text(
                  isDark ? AppLocalizations.translate('dark_mode', locale) : AppLocalizations.translate('light_mode', locale),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
