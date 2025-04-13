import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class SQFLiteDataSource {
  sqflite.Database? _database;

  Future<sqflite.Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<sqflite.Database> _initializeDatabase() async {
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
  }

  Future<String> _saveImageFile(File image) async {
    // Verify source file exists
    if (!await image.exists()) {
      throw FileSystemException('Source image does not exist: ${image.path}');
    }

    // Create destination directory
    final appDir = await getApplicationDocumentsDirectory();
    final plantsDir = Directory(join(appDir.path, 'plants'));
    if (!await plantsDir.exists()) {
      await plantsDir.create(recursive: true);
    }

    // Copy file
    final fileName = basename(image.path);
    final destinationPath = join(plantsDir.path, fileName);
    final savedImage = await image.copy(destinationPath);

    // Verify copy
    if (!await savedImage.exists()) {
      throw FileSystemException('Failed to copy image to: $destinationPath');
    }

    return savedImage.path;
  }

  Future<List<Map<String, dynamic>>> getPlants({
    Map<String, dynamic>? queryParameters,
  }) async {
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
  }

  Future<int> addPlant({
    required String plantName,
    String? scientificName,
    File? imageFile,
  }) async {
    final db = await database;
    final imagePath = imageFile != null ? await _saveImageFile(imageFile) : '';
    return await db.insert(
      'my_plants',
      {
        'plant_name': plantName,
        'scientific_name': scientificName,
        'image_file': imagePath,
      },
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
    );
  }

  Future<int> updatePlant({
    required String plantName,
    String? scientificName,
    File? imageFile,
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    final imagePath = imageFile != null ? await _saveImageFile(imageFile) : '';
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
  }

  Future<int> deletePlant({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(
      'my_plants',
      where: where,
      whereArgs: whereArgs,
    );
  }
}
