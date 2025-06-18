import 'dart:async';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(
      databasePath,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tblWatchlist (
        id INTEGER NOT NULL,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        mediaType TEXT,
        PRIMARY KEY (id, mediaType)
      );
    ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS $_tblWatchlist');
      _onCreate(db, newVersion);
    }
  }

  Future<int> insertWatchlist(Map<String, dynamic> item) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, item);
  }

  Future<int> removeWatchlist(int id, String mediaType) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ? AND mediaType = ?',
      whereArgs: [id, mediaType],
    );
  }

  Future<Map<String, dynamic>?> getItemById(int id, String mediaType) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ? AND mediaType = ?',
      whereArgs: [id, mediaType],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlist() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlist);
    return results;
  }
}
