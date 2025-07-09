import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/note.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    return await initDB();
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            updatedAt TEXT,
            isSynced INTEGER
          )
        ''');
      },
    );
  }

  static Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  static Future<List<Note>> getNotes() async {
    final db = await database;
    final data = await db.query('notes', orderBy: 'updatedAt DESC');
    return data.map((e) => Note.fromMap(e)).toList();
  }

  static Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  static Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Note>> getUnsyncedNotes() async {
    final db = await database;
    final data = await db.query('notes', where: 'isSynced = 0');
    return data.map((e) => Note.fromMap(e)).toList();
  }
}
