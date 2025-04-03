import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Plant Scanner",
          style: TextStyle(
            color: Colors.green,
            fontSize: 22.0,
            fontWeight: FontWeight.w700,

          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
