
import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:note_app/core/models/note_model.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'notes';

  static Future<void> initDb() async {
    if (_db != null) {
      log("Database already initialized");
      return;
    }
    try {
      String path = join(await getDatabasesPath(), 'notes.db');
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) async {
          log('Creating $_tableName table');
          await db.execute(
            """
            CREATE TABLE $_tableName(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              content TEXT NOT NULL,
              createdAt TEXT NOT NULL
            )
            """,
          );


          log('Adding initial English sayings...');
          List<NoteModel> initialSayings = [
            NoteModel(
                title: "Optimism",
                content: "Optimism is the faith that leads to achievement. Nothing can be done without hope and confidence.",
                createdAt: DateTime.now().subtract(const Duration(minutes: 30))),
            NoteModel(
                title: "Action",
                content: "The best way to predict the future is to create it.",
                createdAt: DateTime.now().subtract(const Duration(minutes: 25))),
            NoteModel(
                title: "Knowledge",
                content: "The only true wisdom is in knowing you know nothing.",
                createdAt: DateTime.now().subtract(const Duration(minutes: 20))),
            NoteModel(
                title: "Success",
                content: "Success is not final, failure is not fatal: it is the courage to continue that counts.",
                createdAt: DateTime.now().subtract(const Duration(minutes: 15))),
            NoteModel(
                title: "Perseverance",
                content: "It always seems impossible until it's done.",
                createdAt: DateTime.now().subtract(const Duration(minutes: 10))),
            NoteModel(
                title: "Change",
                content: "The only constant in life is change.",
                createdAt: DateTime.now().subtract(const Duration(minutes: 5))),
            NoteModel(
                title: "Kindness",
                content: "Be kind whenever possible. It is always possible.",
                createdAt: DateTime.now()),
          ];

          for (var saying in initialSayings) {
            await db.insert(_tableName, saying.toJson());
          }
          log('Initial English sayings added.');
        },
        onUpgrade: (db, oldVersion, newVersion) {
          log('Upgrading database from version $oldVersion to $newVersion');
        },
      );
      log("Database initialized successfully at $path");
    } catch (e) {
      log('Error initializing database: $e');
    }
  }

  static Future<int> insert(NoteModel note) async {
    log('Inserting note: ${note.title}');
    try {
      if (_db == null) {
        await initDb();
      }
      return await _db!.insert(_tableName, note.toJson());
    } catch (e) {
      log('Error inserting note: $e');
      return -1;
    }
  }

  static Future<List<Map<String, dynamic>>> query() async {
    log('Querying all notes');
    try {
      if (_db == null) {
        await initDb();
      }
      return await _db!.query(_tableName, orderBy: 'createdAt DESC');
    } catch (e) {
      log('Error querying notes: $e');
      return [];
    }
  }

  static Future<int> delete(NoteModel note) async {
    log('Deleting note with ID: ${note.id}');
    try {
      if (_db == null) {
        await initDb();
      }
      return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [note.id]);
    } catch (e) {
      log('Error deleting note: $e');
      return -1;
    }
  }

  static Future<int> update(NoteModel note) async {
    log('Updating note with ID: ${note.id}');
    try {
      if (_db == null) {
        await initDb();
      }
      return await _db!.update(_tableName, note.toJson(), where: 'id = ?', whereArgs: [note.id]);
    } catch (e) {
      log('Error updating note: $e');
      return -1;
    }
  }

  static Future<void> closeDb() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
      log("Database closed.");
    }
  }
}