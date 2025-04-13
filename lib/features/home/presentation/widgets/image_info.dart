import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plant_game/features/home/presentation/widgets/custom_button.dart';

import '../../../../core/dj/service_locator.dart';
import '../../../../core/utils/size_config.dart';

class ImageInfoShower extends StatelessWidget {
  final File imageFile;
  final String? plantName, scientificName;
  const ImageInfoShower(
      {super.key,
      required this.imageFile,
      this.plantName,
      this.scientificName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: sl<SizeConfig>().screenWidth! * 0.6,
            height: sl<SizeConfig>().screenWidth! * 0.6,
            padding: EdgeInsets.symmetric(
              vertical: sl<SizeConfig>().screenHeight! * 0.08,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: FileImage(imageFile),
                fit: BoxFit.cover,
              ),
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
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Name: ${plantName ?? 'Unknown'}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Scientific Name: ${scientificName ?? 'Unknown'}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomSaveButton(
            plantName: plantName!,
            scientificName: scientificName!,
            imageFile: imageFile,
          ),
        ],
      ),
    );
  }
}
