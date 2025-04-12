import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:plant_game/core/errors/sqflite_error_model.dart';

import '../../../../core/errors/sqflite_exceptions.dart';

class SQFLiteDataSource {
  sqflite.Database? _database;

  Future<sqflite.Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<sqflite.Database> _initializeDatabase() async {
    try {
      final databasePath = await sqflite.getDatabasesPath();
      final path = join(databasePath, 'plant_game.db');

      return await sqflite.openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE my_plants (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              plant_name TEXT NOT NULL,
              scientific_name TEXT,
              image_file TEXT
            )
          ''');
        },
      );
    } catch (e) {
      throw DatabaseException(
        SQFLiteErrorModel(
          status: 600,
          errorMessage: 'Failed to initialize database: $e',
        ),
      );
    }
  }

  Future<String> _saveImageFile(File? image) async {
    if (image == null) return '';
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = basename(image.path);
      final savedImage = await image.copy('${appDir.path}/plants/$fileName');
      return savedImage.path;
    } catch (e) {
      throw ImageSaveException(
        SQFLiteErrorModel(
          status: 607,
          errorMessage: 'Failed to save image: $e',
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getPlants({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final db = await database;
      String? where;
      List<dynamic>? whereArgs;
      if (queryParameters != null && queryParameters.isNotEmpty) {
        where = queryParameters.keys.map((key) => '$key = ?').join(' AND ');
        whereArgs = queryParameters.values.toList();
      }

      return await db.query(
        'my_plants',
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      handleSQFLiteException(e);
      rethrow;
    }
  }

  Future<int> addPlant({
    required String plantName,
    String? scientificName,
    File? imageFile,
  }) async {
    try {
      final db = await database;
      final imagePath = await _saveImageFile(imageFile);
      return await db.insert(
        'my_plants',
        {
          'plant_name': plantName,
          'scientific_name': scientificName,
          'image_file': imagePath,
        },
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
      );
    } catch (e) {
      handleSQFLiteException(e);
      rethrow;
    }
  }

  Future<int> updatePlant({
    required String plantName,
    String? scientificName,
    File? imageFile,
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final db = await database;
      final imagePath = await _saveImageFile(imageFile);
      final data = {
        'plant_name': plantName,
        if (scientificName != null) 'scientific_name': scientificName,
        if (imagePath.isNotEmpty) 'image_file': imagePath,
      };
      return await db.update(
        'my_plants',
        data,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
      );
    } catch (e) {
      handleSQFLiteException(e);
      rethrow;
    }
  }

  Future<int> deletePlant({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final db = await database;
      return await db.delete(
        'my_plants',
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      handleSQFLiteException(e);
      rethrow;
    }
  }
}