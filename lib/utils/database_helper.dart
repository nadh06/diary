import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('diary.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE diary_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT,
        mood TEXT,
        date TEXT NOT NULL,
        imagePath TEXT
      )
    ''');
  }

  Future<int> insertEntry(Map<String, dynamic> entry) async {
    final db = await instance.database;
    return await db.insert('diary_entries', entry);
  }

  Future<List<Map<String, dynamic>>> getAllEntries() async {
    final db = await instance.database;
    return await db.query('diary_entries', orderBy: 'date DESC');
  }

  Future<int> deleteEntry(int id) async {
    final db = await instance.database;
    return await db.delete('diary_entries', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = DatabaseHelper._database;
    if (db != null) {
      await db.close();
    }
  }
}
