import 'dart:io';
import 'package:dartz/dartz.dart';
import '../service/locale_database_service.dart';

class PlantRepository {
  final SQFLiteDataSource dataSource;

  PlantRepository({required this.dataSource});

  Future<Either<String, List<Map<String, dynamic>>>> getPlants({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result =
          await dataSource.getPlants(queryParameters: queryParameters);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, int>> addPlant({
    required String plantName,
    String? scientificName,
    File? imageFile,
  }) async {
    try {
      final id = await dataSource.addPlant(
        plantName: plantName,
        scientificName: scientificName,
        imageFile: imageFile,
      );
      return Right(id);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, int>> updatePlant({
    required String plantName,
    String? scientificName,
    File? imageFile,
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final count = await dataSource.updatePlant(
        plantName: plantName,
        scientificName: scientificName,
        imageFile: imageFile,
        where: where,
        whereArgs: whereArgs,
      );
      return Right(count);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, int>> deletePlant({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final count = await dataSource.deletePlant(
        where: where,
        whereArgs: whereArgs,
      );
      return Right(count);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
