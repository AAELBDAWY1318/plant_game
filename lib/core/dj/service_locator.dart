import 'package:get_it/get_it.dart';
import 'package:plant_game/core/utils/size_config.dart';

import '../utils/navigation_service.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<NavigationService>(() => NavigationService());
  sl.registerLazySingleton<SizeConfig>(() => SizeConfig());
}
