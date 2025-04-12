import 'package:sqflite/sqflite.dart';

import '../../errors/sqflite_exceptions.dart';

abstract class DatabaseConsumer {
  Future<List<Map<String, dynamic>>> get(
    String table, {
    Map<String, dynamic>? queryParameters,
    String? where,
    List<dynamic>? whereArgs,
  });

  Future<int> post(
    String table, {
    required Map<String, dynamic> data,
  });

  Future<int> patch(
    String table, {
    required Map<String, dynamic> data,
    String? where,
    List<dynamic>? whereArgs,
  });

  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  });
}

class SQFLiteConsumer extends DatabaseConsumer {
  final Database database;

  SQFLiteConsumer({required this.database});

  @override
  Future<List<Map<String, dynamic>>> get(
    String table, {
    Map<String, dynamic>? queryParameters,
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      if (queryParameters != null && queryParameters.isNotEmpty) {
        where = queryParameters.keys.map((key) => '$key = ?').join(' AND ');
        whereArgs = queryParameters.values.toList();
      }

      final result = await database.query(
        table,
        where: where,
        whereArgs: whereArgs,
      );
      return result;
    } catch (e) {
      handleSQFLiteException(e);
      rethrow; // Propagate the custom exception
    }
  }

  @override
  Future<int> post(
    String table, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final result = await database.insert(
        table,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      handleSQFLiteException(e);
      rethrow;
    }
  }

  @override
  Future<int> patch(
    String table, {
    required Map<String, dynamic> data,
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final result = await database.update(
        table,
        data,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      handleSQFLiteException(e);
      rethrow;
    }
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final result = await database.delete(
        table,
        where: where,
        whereArgs: whereArgs,
      );
      return result;
    } catch (e) {
      handleSQFLiteException(e);
      rethrow;
    }
  }
}
