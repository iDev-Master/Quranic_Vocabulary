

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';
import 'words.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'words_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words (
        level INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        ru TEXT NOT NULL,
        tj TEXT NOT NULL,
        uz TEXT NOT NULL,
        ir TEXT NOT NULL,
        type TEXT CHECK(type IN ('noun', 'verb', 'particle')) NOT NULL,
        occurrence INTEGER,
        percentage REAL,
        exampleAr TEXT,
        exampleRu TEXT,
        exampleTj TEXT,
        exampleUz TEXT,
        exampleIr TEXT,
        combinations TEXT,
        counter INTEGER
      )
    ''');

    // Insert bulk data
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    // List of words to be inserted
    List<Map<String, dynamic>> initialData = words;

    // List<Map<String, dynamic>> initialData = [
    //   {'word':'رَحِيم' , 'translation': 'Милосердие', 'type':'noun', 'occurrence': 73, 'example':'-example', 'translationOfExample':'-translation-', 'combinations': 'combo'},
    //   {'word':'كَرِيم' , 'translation': 'Великодушие', 'type':'noun', 'occurrence': 77, 'example':'-example', 'translationOfExample':'-translation-', 'combinations': 'combo'}
    //   // Add more words here...
    // ];

    // Insert the data into the table
    for (var word in initialData) {
      await db.insert('words', word);
    }
  }

  // Future<List<Map<String, dynamic>>> getWords() async {
  //   Database db = await database;
  //   return await db.query('words');
  // }

  Future<List<Word>> getWords() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('words');

    // Convert List<Map<String, dynamic>> to List<Word>
    return List.generate(maps.length, (i) {
      return Word.fromMap(maps[i]);
    });
  }


  // Fetch a single word based on its level
  Future<Word?> getWord(int level) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'words',
      where: 'level = ?',
      whereArgs: [level],
    );

    if (maps.isNotEmpty) {
      return Word.fromMap(maps.first);
    } else {
      return null;
    }
  }


  Future<void> close() async {
    Database db = await database;
    await db.close();
  }
}






