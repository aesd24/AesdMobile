import 'package:aesd_app/services/session/storage_auth_token_session.dart';
import 'package:dio/dio.dart';

// sur android le localhost n'est pas (127.0.0.1) mais (10.0.2.2)
// http://127.0.0.1:8000/api/v1/
// String host = "https://eglisesetserviteursdedieu.com" 


class DioClient {
  final String baseUrl = "https://eglisesetserviteursdedieu.com/api/v1/";
  final connectTimeout = const Duration(seconds: 10);
  final receiveTimeout = const Duration(seconds: 15);
  final sendTimeout = const Duration(seconds: 10);

  Future<Dio> getApiClient({String? contentType}) async {
    final Dio dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      validateStatus: (status){
        return status! < 500;
      },
      headers: {
        'accept': "application/json",
      }
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          // Si le code de statut est supérieur à 500, nous considérons la réponse comme réussie
          if (response.statusCode != null && response.statusCode! >= 500) {
            //print(response);
            handler.next(response); // Continuer sans lever d'exception
          } else {
            handler.next(response); // Continuer normalement
          }
        },
        onError: (DioException e, ErrorInterceptorHandler handler) {
          // Gérer les autres erreurs normalement
          handler.next(e);
        },
      ),
    );

    final authToken = await StorageAuthTokenSession.getFormSecureStorage();

    if (authToken.token != '' && authToken.type != '') {
      dio.options.headers['Authorization'] = '${authToken.type} ${authToken.token}';
    }

    return dio;
  }
}
