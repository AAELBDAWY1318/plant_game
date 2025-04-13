import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:plant_game/features/home/data/repository/plant_local_repository.dart';
import 'package:plant_game/features/home/data/repository/scan_plants_repository.dart';
import 'package:plant_game/features/home/presentation/cubit/state.dart';

import '../../../../core/dj/service_locator.dart';

class ScanPlantCubit extends Cubit<ScanPlatState> {
  ScanPlantCubit() : super(InitialState());

  getPlantInfo(File imageFile) async {
    emit(ScanImageLoading());
    var res = await sl<ScanPlantsRepository>().getPlantInfo(imageFile);
    res.fold((errorMessage) {
      emit(ScanImageFailure(errorMessage: errorMessage));
    }, (plantModel) {
      emit(ScanImageSuccess(plantModel: plantModel));
    });
  }

  Future<void> addPlant({
    required String plantName,
    String? scientificName,
    File? imageFile,
  }) async {
    emit(PlantLoading());
    final result = await sl<PlantRepository>().addPlant(
      plantName: plantName,
      scientificName: scientificName,
      imageFile: imageFile,
    );
    result.fold(
      (error) {
        log(error);
        emit(PlantError(error));
      },
      (_) {
        emit(PlantOperationSuccess('Plant saved successfully'));
      },
    );
  }


  Future<void> getPlants() async {
    emit(PlantLoading());
    final result = await sl<PlantRepository>().getPlants();
    result.fold(
          (error) => emit(PlantError(error)),
          (plants) => emit(PlantLoaded(plants)),
    );
  }

  Future<void> deletePlant({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    emit(PlantLoading());
    final result = await sl<PlantRepository>().deletePlant(
      where: where,
      whereArgs: whereArgs,
    );
    result.fold(
          (error) => emit(PlantError(error)),
          (_) {
        emit(PlantOperationSuccess('Plant deleted successfully'));
        getPlants();
      },
    );
  }
}
