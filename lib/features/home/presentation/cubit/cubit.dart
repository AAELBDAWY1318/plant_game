import 'package:bloc/bloc.dart';
import 'package:plant_game/features/home/presentation/cubit/state.dart';

class ScanPlantCubit extends Cubit<ScanPlatState> {
  ScanPlantCubit() : super(InitialState());
}
