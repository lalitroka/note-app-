import 'dart:developer';
import 'package:notekeeping/core/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteDatabase {
  NoteDatabase._internal();
  static final NoteDatabase _noteDatabase = NoteDatabase._internal();

  factory NoteDatabase() => _noteDatabase;

  static Database? _database;
  final String _dbName = 'Note_database.db';
  final String _tableName = 'noteTable';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _dbName);
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            timestamp INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('ALTER TABLE $_tableName ADD COLUMN timestamp INTEGER');
        }
      },
    );
  }

  Future<void> insertNote(Note note) async {
    try {
      final db = await _noteDatabase.database;
      await db.insert(
        _tableName,
        {
          'title': note.title,
          'description': note.description,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      log('Error inserting note: $e');
    }
  }

  Future<List<Note>> getNote() async {
    try {
      final db = await _noteDatabase.database;
      final List<Map<String, Object?>> getnoteAsMap = await db.query(
        _tableName,
        orderBy: 'timestamp DESC',
      );
      return getnoteAsMap.map((e) => Note.fromMap(e)).toList();
    } catch (e) {
      log('Error fetching notes: $e');
    }
    return [];
  }

  Future<void> deleteNote(int id) async {
    try {
      final db = await _noteDatabase.database;
      await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      log('Error deleting note: $e');
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      final db = await _noteDatabase.database;
      await db.update(
        _tableName,
        {
          'title': note.title,
          'description': note.description,
          'timestamp': note.timestamp,
        },
        where: 'id = ?',
        whereArgs: [note.id],
      );
    } catch (e) {
      log('Error updating note: $e');
    }
  }

  Future<void> deleteDatabaseFile() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _dbName);
    await deleteDatabase(path);
    log('Database deleted: $path');
  }
}
