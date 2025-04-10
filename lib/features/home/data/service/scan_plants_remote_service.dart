import 'dart:io';

import 'package:dio/dio.dart';
import 'package:plant_game/core/database/api/api_conscumer.dart';
import 'package:plant_game/core/database/api/end_points.dart';

class ScanPlantsRemoteService {
  final ApiConsumer apiConsumer;

  ScanPlantsRemoteService({required this.apiConsumer});

  Future<Response> getPlantInfo(File imageFile) async {
    final url = EndPoints.baseUrl;

    FormData formData = FormData.fromMap({
      'images': await MultipartFile.fromFile(imageFile.path,
          filename: 'plant_image.jpg'),
      'organs': 'leaf',
    });

    Map<String, dynamic> headers = {
      'Content-Type': 'multipart/form-data',
    };

    Response response =
        await apiConsumer.post(url, queryParameters: headers, data: formData);

    return response;
  }
}
