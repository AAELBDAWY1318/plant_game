import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:plant_game/core/network_info/network_info.dart';
import 'package:plant_game/features/home/data/models/plant_model.dart';
import 'package:plant_game/features/home/data/service/scan_plants_remote_service.dart';

import '../../../../core/errors/exception.dart';

class ScanPlantsRepository {
  final ScanPlantsRemoteService scanPlantsRemoteService;
  final NetworkInfo networkInfo;

  ScanPlantsRepository({
    required this.scanPlantsRemoteService,
    required this.networkInfo,
  });

  Future<Either<String, PlantModel>> getPlantInfo(File imageFile) async {
    if (await networkInfo.isConnect!) {
      try {
        Response response =
            await scanPlantsRemoteService.getPlantInfo(imageFile);
        var jsonData = response.data;
        if (jsonData['results'] != null && jsonData['results'].isNotEmpty) {
          String plantName =
              jsonData['results'][0]['species']['commonNames'].isNotEmpty
                  ? jsonData['results'][0]['species']['commonNames'][0]
                  : 'Unknown';
          String scientificName =
              jsonData['results'][0]['species']['scientificNameWithoutAuthor'];
          return Right(PlantModel(
            plantName: plantName,
            scientificName: scientificName,
            image: imageFile,
          ));
        } else {
          return const Left(" plant identified.");
        }
      } on ServerException catch (e) {
        return Left(e.toString());
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return const Left("Check your internet connection");
    }
  }
}
