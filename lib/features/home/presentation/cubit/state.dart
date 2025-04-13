import 'package:plant_game/features/home/data/models/plant_model.dart';

class ScanPlatState {}

class InitialState extends ScanPlatState {}

class ScanImageLoading extends ScanPlatState {}

class ScanImageFailure extends ScanPlatState {
  final String errorMessage;

  ScanImageFailure({required this.errorMessage});
}

class ScanImageSuccess extends ScanPlatState {
  final PlantModel plantModel;

  ScanImageSuccess({required this.plantModel});
}

class PlantLoading extends ScanPlatState {}

class PlantOperationSuccess extends ScanPlatState {
  final String message;

  PlantOperationSuccess(this.message);
}

class PlantError extends ScanPlatState {
  final String message;

  PlantError(this.message);
}

class PlantLoaded extends ScanPlatState {
  final List<Map<String, dynamic>> plants;

  PlantLoaded(this.plants);
}
