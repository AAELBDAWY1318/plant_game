import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:plant_game/core/database/api/end_points.dart';

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
      // إعداد FormData لـ PlantNet API
      FormData formData = FormData.fromMap({
        'images': await MultipartFile.fromFile(widget.imageFile.path, filename: 'plant_image.jpg'),
        'organs': 'leaf', // افتراضياً بنحدد إنه ورقة، ممكن تغيره لـ flower أو bark حسب الصورة
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
          plantName = jsonData['results'][0]['species']['commonNames'].isNotEmpty
              ? jsonData['results'][0]['species']['commonNames'][0]
              : 'Unknown';
          scientificName = jsonData['results'][0]['species']['scientificNameWithoutAuthor'];
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
        title: const Text("Plant Info"),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : errorMessage != null
              ? Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 18),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(widget.imageFile, width: 200, height: 200),
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
            ],
          ),
        ),
      ),
    );
  }
}