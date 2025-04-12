import 'package:flutter/material.dart';
import 'package:plant_game/core/utils/size_config.dart';

import '../../../../core/dj/service_locator.dart';

class CustomErrorMessage extends StatelessWidget {
  final String errorMessage;
  const CustomErrorMessage({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/error.png",
          width: sl<SizeConfig>().screenWidth! * 0.7,
          height: sl<SizeConfig>().screenHeight! *0.3,
          fit: BoxFit.cover,
        ),
        Text(
          errorMessage,
          textAlign: TextAlign.center,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
