import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void navigateToWithReplacement(Widget page) {
    navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void navigateTo(Widget page) {
    navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void navigateToAndClearAll(Widget page) {
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }

  void goBack() {
    navigatorKey.currentState!.pop();
  }
}
