import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:plant_game/core/network_info/network_info.dart';
import 'package:plant_game/core/utils/size_config.dart';
import 'package:plant_game/features/home/data/repository/plant_local_repository.dart';
import 'package:plant_game/features/home/data/repository/scan_plants_repository.dart';
import 'package:plant_game/features/home/data/service/locale_database_service.dart';
import 'package:plant_game/features/home/data/service/scan_plants_remote_service.dart';

import '../database/api/api_conscumer.dart';
import '../database/api/dio_consumer.dart';
import '../utils/navigation_service.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<NavigationService>(() => NavigationService());
  sl.registerLazySingleton<SizeConfig>(() => SizeConfig());

  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: sl<Dio>()));
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(dataConnectionChecker: DataConnectionChecker()));

  sl.registerLazySingleton<ScanPlantsRemoteService>(
      () => ScanPlantsRemoteService(apiConsumer: sl<ApiConsumer>()));

  sl.registerLazySingleton<ScanPlantsRepository>(() => ScanPlantsRepository(
        scanPlantsRemoteService: sl<ScanPlantsRemoteService>(),
        networkInfo: sl<NetworkInfo>(),
      ));

  sl.registerLazySingleton<SQFLiteDataSource>(() => SQFLiteDataSource());

  sl.registerLazySingleton<PlantRepository>(
      () => PlantRepository(dataSource: sl<SQFLiteDataSource>()));
}
