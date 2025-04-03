import 'package:get_it/get_it.dart';

import '../utils/navigation_service.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<NavigationService>(() => NavigationService());
}
