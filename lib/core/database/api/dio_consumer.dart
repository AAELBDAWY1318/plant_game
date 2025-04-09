import 'package:dio/dio.dart';
import 'package:plant_game/core/database/api/api_conscumer.dart';
import 'package:plant_game/core/database/api/end_points.dart';
import 'package:plant_game/core/errors/exception.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoints.baseUrl;
  }
  @override
  Future delete(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      var res = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future get(String path,
      {Object? data, Map<String, dynamic>? queryParameter}) async {
    try {
      var res =
      await dio.get(path, data: data, queryParameters: queryParameter);
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future patch(String path,
      {data,
        Map<String, dynamic>? queryParameters,
        bool isFormData = false}) async {
    try {
      var res = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future post(String path,
      {data,
        Map<String, dynamic>? queryParameters,

        bool isFormData = false}) async {
    try {
      final options = Options(headers: queryParameters);
      Response res = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        options: options,
      );

      return res;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}