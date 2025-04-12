import 'dart:io';

import 'package:bloc/bloc.dart';
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
}
