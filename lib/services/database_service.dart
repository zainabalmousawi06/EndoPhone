import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'endophone.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE diary_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        note TEXT,
        mood TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE food_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        category TEXT,
        notes TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE yoga_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        url TEXT,
        duration INTEGER,
        created_at TEXT
      )
    ''');
  }

  // Diary CRUD
  Future<int> insertDiaryEntry(Map<String, dynamic> entry) async {
    final db = await database;
    return db.insert('diary_entries', entry,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getDiaryEntries() async {
    final db = await database;
    return db.query('diary_entries', orderBy: 'created_at DESC');
  }

  Future<int> updateDiaryEntry(int id, Map<String, dynamic> entry) async {
    final db = await database;
    return db.update('diary_entries', entry, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteDiaryEntry(int id) async {
    final db = await database;
    return db.delete('diary_entries', where: 'id = ?', whereArgs: [id]);
  }

  // Food CRUD
  Future<int> insertFood(Map<String, dynamic> food) async {
    final db = await database;
    return db.insert('food_items', food,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getFoods() async {
    final db = await database;
    return db.query('food_items', orderBy: 'created_at DESC');
  }

  Future<int> updateFood(int id, Map<String, dynamic> food) async {
    final db = await database;
    return db.update('food_items', food, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteFood(int id) async {
    final db = await database;
    return db.delete('food_items', where: 'id = ?', whereArgs: [id]);
  }

  // Yoga CRUD
  Future<int> insertYogaSession(Map<String, dynamic> session) async {
    final db = await database;
    return db.insert('yoga_sessions', session,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getYogaSessions() async {
    final db = await database;
    return db.query('yoga_sessions', orderBy: 'created_at DESC');
  }

  Future<int> updateYogaSession(int id, Map<String, dynamic> session) async {
    final db = await database;
    return db.update('yoga_sessions', session, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteYogaSession(int id) async {
    final db = await database;
    return db.delete('yoga_sessions', where: 'id = ?', whereArgs: [id]);
  }
}
