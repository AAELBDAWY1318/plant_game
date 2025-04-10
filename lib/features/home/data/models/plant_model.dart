import 'dart:io';


class PlantModel {
  final String plantName;
  final String scientificName;
  final File image;

  PlantModel({
    required this.plantName,
    required this.scientificName,
    required this.image,
  });

  @override
  String toString() {
    return "PlantModel(plantName: $plantName, scientificName: $scientificName, image: $image)";
  }
}
