import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:plant_game/core/database/api/end_points.dart';
import 'package:plant_game/features/home/presentation/widgets/image_info.dart';

class PlantInfoScreen extends StatefulWidget {
  final File imageFile;

  const PlantInfoScreen({super.key, required this.imageFile});

  @override
  State<PlantInfoScreen> createState() => _PlantInfoScreenState();
}

class _PlantInfoScreenState extends State<PlantInfoScreen> {
  String? plantName;
  String? scientificName;
  String? errorMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlantInfo();
  }

  Future<void> _fetchPlantInfo() async {
    final dio = Dio();
    final url = EndPoints.baseUrl;

    log("API URL: $url");

    try {
      FormData formData = FormData.fromMap({
        'images': await MultipartFile.fromFile(widget.imageFile.path,
            filename: 'plant_image.jpg'),
        'organs':
            'leaf', // افتراضياً بنحدد إنه ورقة، ممكن تغيره لـ flower أو bark حسب الصورة
      });

      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      var jsonData = response.data;
      log("API Response: $jsonData");

      setState(() {
        // PlantNet بيرجع النتايج في حقل "results"
        if (jsonData['results'] != null && jsonData['results'].isNotEmpty) {
          plantName =
              jsonData['results'][0]['species']['commonNames'].isNotEmpty
                  ? jsonData['results'][0]['species']['commonNames'][0]
                  : 'Unknown';
          scientificName =
              jsonData['results'][0]['species']['scientificNameWithoutAuthor'];
        } else {
          errorMessage = "No plant identified.";
        }
        isLoading = false;
      });
    } catch (e) {
      log("API Error: $e");
      setState(() {
        errorMessage = "Failed to identify plant: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Plant Info",
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
        child: Center(
          child: ImageInfoShower(
            imageFile: widget.imageFile,
            plantName: plantName,
            scientificName: scientificName,
          ),
        ),
      ),
    );
  }
}
