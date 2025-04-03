import 'package:flutter/material.dart';
import 'package:plant_game/core/dj/service_locator.dart';
import 'package:plant_game/core/utils/navigation_service.dart';
import 'package:plant_game/features/splash/presentation/view/splash_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: sl<NavigationService>().navigatorKey,
      home: const SplashView(),
    );
  }
}
