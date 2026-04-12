import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('centralized_auth.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE users (
        id $idType,
        name $textType,
        email $textType UNIQUE,
        password $textType,
        age $intType,
        role TEXT DEFAULT 'user',
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        last_login TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE sessions (
        id $idType,
        user_id $intType,
        token $textType,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Per-user app launcher table
    // android_package: e.g. "com.google.android.youtube"
    // ios_scheme: e.g. "youtube://"
    // fallback_url: e.g. "https://youtube.com"
    await db.execute('''
      CREATE TABLE user_apps (
        id $idType,
        user_id $intType,
        name $textType,
        icon TEXT DEFAULT '📱',
        android_package TEXT,
        ios_scheme TEXT,
        fallback_url TEXT,
        sort_order INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    final adminPassword = _hashPassword('admin123');
    await db.insert('users', {
      'name': 'Admin',
      'email': 'admin@auth.com',
      'password': adminPassword,
      'age': 25,
      'role': 'admin'
    });
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS apps');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_apps (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          name TEXT NOT NULL,
          icon TEXT DEFAULT '📱',
          android_package TEXT,
          ios_scheme TEXT,
          fallback_url TEXT,
          sort_order INTEGER DEFAULT 0,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (user_id) REFERENCES users (id)
        )
      ''');
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<Map<String, dynamic>?> register(
      String name, String email, String password, int age) async {
    final db = await database;
    final existing = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (existing.isNotEmpty) return null;
    final hashedPassword = _hashPassword(password);
    final id = await db.insert('users', {
      'name': name,
      'email': email,
      'password': hashedPassword,
      'age': age,
      'role': 'user'
    });
    return {'id': id, 'name': name, 'email': email, 'age': age, 'role': 'user'};
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);
    final result = await db.query('users',
        where: 'email = ? AND password = ?', whereArgs: [email, hashedPassword]);
    if (result.isEmpty) return null;
    final user = result.first;
    await db.update('users', {'last_login': DateTime.now().toIso8601String()},
        where: 'id = ?', whereArgs: [user['id']]);
    final token = _generateToken(user['id'] as int);
    await db.insert('sessions', {'user_id': user['id'], 'token': token});
    return {
      'id': user['id'],
      'name': user['name'],
      'email': user['email'],
      'age': user['age'],
      'role': user['role'],
      'token': token
    };
  }

  String _generateToken(int userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final data = '$userId-$timestamp';
    final bytes = utf8.encode(data);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users', orderBy: 'id DESC');
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
    await db.delete('sessions', where: 'user_id = ?', whereArgs: [id]);
    await db.delete('user_apps', where: 'user_id = ?', whereArgs: [id]);
  }

  Future<bool> verifyToken(String token) async {
    final db = await database;
    final result = await db.query('sessions', where: 'token = ?', whereArgs: [token]);
    return result.isNotEmpty;
  }

  Future<void> deleteSession(String token) async {
    final db = await database;
    await db.delete('sessions', where: 'token = ?', whereArgs: [token]);
  }

  // ─── User App Operations ──────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getAppsForUser(int userId) async {
    final db = await database;
    return await db.query('user_apps',
        where: 'user_id = ?', whereArgs: [userId], orderBy: 'sort_order ASC, id ASC');
  }

  Future<int> addAppForUser({
    required int userId,
    required String name,
    required String icon,
    String? androidPackage,
    String? iosScheme,
    String? fallbackUrl,
  }) async {
    final db = await database;
    final maxResult = await db.rawQuery(
        'SELECT MAX(sort_order) as max_order FROM user_apps WHERE user_id = ?', [userId]);
    final maxOrder = (maxResult.first['max_order'] as int?) ?? -1;
    return await db.insert('user_apps', {
      'user_id': userId,
      'name': name,
      'icon': icon,
      'android_package': androidPackage,
      'ios_scheme': iosScheme,
      'fallback_url': fallbackUrl,
      'sort_order': maxOrder + 1,
    });
  }

  Future<void> removeAppForUser(int appId, int userId) async {
    final db = await database;
    await db.delete('user_apps', where: 'id = ? AND user_id = ?', whereArgs: [appId, userId]);
  }

  Future<void> updateAppForUser({
    required int appId,
    required int userId,
    required String name,
    required String icon,
    String? androidPackage,
    String? iosScheme,
    String? fallbackUrl,
  }) async {
    final db = await database;
    await db.update(
      'user_apps',
      {
        'name': name,
        'icon': icon,
        'android_package': androidPackage,
        'ios_scheme': iosScheme,
        'fallback_url': fallbackUrl,
      },
      where: 'id = ? AND user_id = ?',
      whereArgs: [appId, userId],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
