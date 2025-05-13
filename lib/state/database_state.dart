import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseState {
  static final DatabaseState instance = DatabaseState._();
  DatabaseState._();

  Database? _database;
  late String documentsDirectory;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    throw Exception('Database not initialized. Call init() first.');
  }

  // Initialize the database
  Future<void> init() async {
    // Simulate a delay to show loading state
    await Future.delayed(const Duration(seconds: 1));
    if (_database != null) return;
    _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      print('Database path: $databasesPath');
      final path = join(databasesPath, 'devolver-digital.db');
      await _copyDatabase(); // Ensure the database is copied before opening it
      _database = await openDatabase(path);
      return _database!;
    } catch (e) {
      print('Failed to connect to the database: $e');
      rethrow; // Rethrow error to handle it elsewhere
    }
  }

  // Function to copy the database from assets to the device if it doesn't exist
  Future<void> _copyDatabase() async {
    documentsDirectory = await getApplicationDocumentsDirectory().then((value) => value.path);
    String dbPath = join(documentsDirectory, 'devolver-digital.db');
    
    bool exists = await databaseExists(dbPath);
    if (!exists) {
      try {
        await Directory(dirname(dbPath)).create(recursive: true);
        ByteData data = await rootBundle.load("assets/database/devolver-digital.db");
        List<int> bytes = data.buffer.asUint8List();
        await File(dbPath).writeAsBytes(bytes, flush: true);
        print('Database copied successfully');
      } catch (e) {
        print('Error copying the database: $e');
        rethrow; // Rethrow error if needed
      }
    } else {
      print('Database already exists, no need to copy');
    }
  }

  Future<List<Map<String, dynamic>>> get({String? table }) async {
    final db = await database;
    final result = await db.query(table!);
    return result;
  }

  Future<void> insert({String? table, String? key, String? value}) async {
    final db = await database;
    await db.insert(
      table!,
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update({ String? table, String? key, String? value}) async {
    final db = await database;
    await db.update(
      table!, { 'value': value },
      where: 'key = ?',
      whereArgs: [key],
    );
  }

  Future<void> remove({String? table, String? key}) async {
    final db = await database;
    await db.delete(table!, where: 'key = ?', whereArgs: [key]);
  }

  Future<void> clear() async {
    final db = await database;
    await db.delete('games');
  }

}
