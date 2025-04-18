import 'package:aesd_app/services/cache/un_expired_cache.dart';
import 'package:dio/dio.dart';

// sur android le localhost n'est pas (127.0.0.1) mais (10.0.2.2)
// http://127.0.0.1:8000/api/v1/
// String host = "https://eglisesetserviteursdedieu.com"
// https://api.eglisesetserviteursdedieu.com/api/

class DioClient {
  final Dio _dio = Dio(BaseOptions(
      baseUrl: "https://api.eglisesetserviteursdedieu.com/api/",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(minutes: 5),
      sendTimeout: const Duration(minutes: 5),
      validateStatus: (status) {
        return status! < 500;
      },
      headers: {
        'accept': "application/json",
      }));

  Future<Dio> getApiClient({String? contentType}) async {
    final authToken = await UnExpiredCache().get(key: 'access_token');
    if (authToken != '') {
      _dio.options.headers['Authorization'] = authToken;
    }

    return _dio;
  }
}