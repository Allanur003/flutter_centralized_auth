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
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    // Users table
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

    // Sessions table
    await db.execute('''
      CREATE TABLE sessions (
        id $idType,
        user_id $intType,
        token $textType,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Apps table
    await db.execute('''
      CREATE TABLE apps (
        id $idType,
        name $textType,
        description TEXT,
        icon TEXT,
        min_age INTEGER DEFAULT 0
      )
    ''');

    // Insert default apps
    await db.insert('apps', {
      'name': 'FashionStore',
      'description': 'Online clothing shop',
      'icon': '👔',
      'min_age': 0
    });

    await db.insert('apps', {
      'name': 'StreamFlix',
      'description': 'Watch movies and series',
      'icon': '🎬',
      'min_age': 13
    });

    await db.insert('apps', {
      'name': 'SocialChat',
      'description': 'Connect with friends',
      'icon': '💬',
      'min_age': 10
    });

    // Create admin user
    final adminPassword = _hashPassword('admin123');
    await db.insert('users', {
      'name': 'Admin',
      'email': 'admin@auth.com',
      'password': adminPassword,
      'age': 25,
      'role': 'admin'
    });
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  // User operations
  Future<Map<String, dynamic>?> register(
      String name, String email, String password, int age) async {
    final db = await database;

    // Check if email exists
    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existing.isNotEmpty) {
      return null;
    }

    final hashedPassword = _hashPassword(password);

    final id = await db.insert('users', {
      'name': name,
      'email': email,
      'password': hashedPassword,
      'age': age,
      'role': 'user'
    });

    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'role': 'user'
    };
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
    );

    if (result.isEmpty) {
      return null;
    }

    final user = result.first;

    // Update last login
    await db.update(
      'users',
      {'last_login': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [user['id']],
    );

    // Create session
    final token = _generateToken(user['id'] as int);
    await db.insert('sessions', {
      'user_id': user['id'],
      'token': token,
    });

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
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isEmpty) return null;
    return result.first;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;
    return result.first;
  }

  Future<List<Map<String, dynamic>>> getAllApps() async {
    final db = await database;
    return await db.query('apps');
  }

  Future<List<Map<String, dynamic>>> getAppsForUser(int age) async {
    final db = await database;
    return await db.query(
      'apps',
      where: 'min_age <= ?',
      whereArgs: [age],
    );
  }

  Future<bool> verifyToken(String token) async {
    final db = await database;
    final result = await db.query(
      'sessions',
      where: 'token = ?',
      whereArgs: [token],
    );
    return result.isNotEmpty;
  }

  Future<void> deleteSession(String token) async {
    final db = await database;
    await db.delete(
      'sessions',
      where: 'token = ?',
      whereArgs: [token],
    );
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users', orderBy: 'id DESC');
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
    await db.delete('sessions', where: 'user_id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}