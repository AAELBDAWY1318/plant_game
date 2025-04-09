import 'package:flutter/material.dart';

import 'package:plant_game/features/home/presentation/widgets/custom_scanner_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Plant Scanner",
          style: TextStyle(
            color: Colors.brown,
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
            shadows: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 10.0,
                offset: Offset(0, 10),
              )
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/plant.png",
            ),
            opacity: 0.2,
          ),
          gradient: LinearGradient(
            colors: [
              Colors.greenAccent,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: CustomScannerButton(),
        ),
      ),
    );
  }
}
