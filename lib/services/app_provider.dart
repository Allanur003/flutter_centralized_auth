import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';

class AppProvider with ChangeNotifier {
  // Theme
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // Language
  String _locale = 'en';
  String get locale => _locale;

  // User
  Map<String, dynamic>? _currentUser;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Token
  String? _token;
  String? get token => _token;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  AppProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _locale = prefs.getString('locale') ?? 'en';
    _token = prefs.getString('token');

    if (_token != null) {
      final isValid = await _dbHelper.verifyToken(_token!);
      if (isValid) {
        final userId = prefs.getInt('userId');
        if (userId != null) {
          _currentUser = await _dbHelper.getUserById(userId);
        }
      } else {
        _token = null;
        await prefs.remove('token');
        await prefs.remove('userId');
      }
    }

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> changeLanguage(String newLocale) async {
    _locale = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', newLocale);
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final result = await _dbHelper.login(email, password);
    
    if (result != null) {
      _currentUser = result;
      _token = result['token'];
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setInt('userId', result['id']);
      
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<bool> register(String name, String email, String password, int age) async {
    final result = await _dbHelper.register(name, email, password, age);
    return result != null;
  }

  Future<void> logout() async {
    if (_token != null) {
      await _dbHelper.deleteSession(_token!);
    }
    
    _currentUser = null;
    _token = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    
    notifyListeners();
  }

  Future<String?> getEmailByPassword(String email) async {
    final user = await _dbHelper.getUserByEmail(email);
    return user?['email'];
  }

  Future<List<Map<String, dynamic>>> getAvailableApps() async {
    if (_currentUser == null) return [];
    
    final age = _currentUser!['age'] as int;
    return await _dbHelper.getAppsForUser(age);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await _dbHelper.getAllUsers();
  }

  Future<void> deleteUser(int id) async {
    await _dbHelper.deleteUser(id);
    notifyListeners();
  }
}