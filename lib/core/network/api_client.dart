import 'package:dio/dio.dart';

import '../utils/resluts.dart';


class ApiClient {
  ApiClient(this._dio, {required this.apiKey, required this.mockMode});

  final Dio _dio;
  final String apiKey;
  final bool mockMode;

  Future<AppResult<Map<String, dynamic>>> get(
      String path, {
        Map<String, dynamic>? query,
      }) async {
    if (mockMode) {
      // يرجّع mock json من هنا (هنحطه في DS)
      return const Failure(AppFailure("MOCK_MODE_USE_DS"));
    }

    try {
      final res = await _dio.get(path, queryParameters: {
        ...?query,
       "apiKey": apiKey,
      });

      return Success(Map<String, dynamic>.from(res.data));
    } catch (e) {
      return Failure(AppFailure(e.toString()));
    }
  }
}
