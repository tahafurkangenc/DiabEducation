import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('my_database.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE module_logs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      module_name TEXT NOT NULL,
      category_name TEXT NOT NULL,
      entry_time TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
    )
  ''');
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE user_locations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users (id)
    )
  ''');
  }

  Future<int> insertModuleLog(String username, String moduleName, String categoryName, String entryTime) async {
    final db = await DatabaseHelper.instance.database;

    return await db.insert(
      'module_logs',
      {
        'username': username,
        'module_name': moduleName,
        'category_name': categoryName,
        'entry_time': entryTime,
      },
      //conflictAlgorithm: ConflictAlgorithm.replace, // Mevcut kaydı günceller
    );
  }

  Future<int> insertUser(String username) async {
    final db = await database;
    return await db.insert('users', {'username': username});
  }

  Future<int> insertUserLocation(int userId, double latitude, double longitude) async {
    final db = await database;
    return await db.insert('user_locations', {
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
    });
  }


  Future<void> upsertModuleLog(String username, String moduleName, String categoryName, DateTime timestamp) async {
    final db = await database;

    // Kullanıcının ID'sini al
    final userRecord = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );

    if (userRecord.isEmpty) {
      throw Exception('Kullanıcı bulunamadı: $username');
    }
    else{
      print("kullanici var");
      print(userRecord);
    }

    final userId = userRecord.first['id'];

    // Veritabanında aynı user_id, modül adı ve kategori adıyla bir kayıt olup olmadığını kontrol et
    final existingRecord = await db.query(
      'module_logs',
      where: 'user_id = ? AND module_name = ? AND category_name = ?',
      whereArgs: [userId, moduleName, categoryName],
    );

    if (existingRecord.isNotEmpty) {
      print("same logs are available");
      // Kayıt varsa, güncelle
      await db.update(
        'module_logs',
        {
          'entry_time': timestamp.toIso8601String(),
        },
        where: 'user_id = ? AND module_name = ? AND category_name = ?',
        whereArgs: [userId, moduleName, categoryName],
      );
      print("Kayıt güncellendi: $moduleName");
    } else {
      print("same logs are not available");
      // Kayıt yoksa, yeni kayıt ekle
      await db.insert(
        'module_logs',
        {
          'user_id': userId,
          'module_name': moduleName,
          'category_name': categoryName,
          'entry_time': timestamp.toIso8601String(),
        },
      );
      print("Yeni kayıt eklendi: $moduleName");
    }

    // Tüm kayıtları konsolda yazdır
    final List<Map<String, dynamic>> result = await db.query('module_logs');
    print(result);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  Future<Map<String, dynamic>?> getEarliestLog() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'module_logs',
      orderBy: 'entry_time ASC',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Tüm kullanıcıları ve konumlarını al
  Future<void> printAllUsersAndLocations() async {
    final db = await database;

    // Kullanıcı tablosunu sorgula
    final List<Map<String, dynamic>> users = await db.query('users');
    print('--- Tüm Kullanıcılar ---');
    for (var user in users) {
      print('ID: ${user['id']}, Username: ${user['username']}');
    }

    // Konum tablosunu sorgula
    final List<Map<String, dynamic>> locations = await db.query('user_locations');
    print('--- Tüm Konumlar ---');
    for (var location in locations) {
      print('UserID: ${location['user_id']}, Latitude: ${location['latitude']}, Longitude: ${location['longitude']}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllLogsWithLocation() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT 
      module_logs.user_id,
      module_logs.module_name,
      module_logs.category_name,
      module_logs.entry_time,
      user_locations.latitude,
      user_locations.longitude
    FROM module_logs
    INNER JOIN user_locations ON module_logs.user_id = user_locations.user_id
  ''');
  }

}
