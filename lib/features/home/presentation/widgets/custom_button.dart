import 'package:flutter/material.dart';
import 'package:plant_game/core/utils/size_config.dart';

import '../../../../core/dj/service_locator.dart';

class CustomSaveButton extends StatelessWidget {
  const CustomSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sl<SizeConfig>().screenWidth! * 0.5,
      height: sl<SizeConfig>().screenHeight! * 0.05,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
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
      child: const Center(
        child: Text(
          "Save Plant",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
