import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:plant_game/core/dj/service_locator.dart';
import 'package:plant_game/core/utils/size_config.dart';

class CustomScannerButton extends StatelessWidget {
  const CustomScannerButton({super.key});

  @override
  Widget build(BuildContext context) {
    sl<SizeConfig>().init(context);
    return GestureDetector(
      onTap: (){
        log("Scanner Tapped");
      },
      child: Container(
        width: sl<SizeConfig>().screenWidth! * 0.6,
        height: sl<SizeConfig>().screenWidth! * 0.6,
        padding: EdgeInsets.symmetric(
          vertical: sl<SizeConfig>().screenHeight! * 0.08,
        ),
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.brown,
              blurRadius: 10.0,
              offset: Offset(-10, 0),
            ),
            BoxShadow(
              color: Colors.greenAccent,
              blurRadius: 10.0,
              offset: Offset(10, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "Start Scan",
                style: TextStyle(
                  fontSize: sl<SizeConfig>().screenWidth! * 0.065,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Expanded(
              child: Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
