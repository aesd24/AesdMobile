import 'package:aesd_app/requests/dio_client.dart';

class ChatRequest extends DioClient {
  inbox({dynamic queryParameters}) async {
    final client = await getApiClient();

    return client.get('/inbox', queryParameters: queryParameters);
  }

  message({required int id, dynamic queryParameters}) async {
    final client = await getApiClient();

    return client.get('/inbox/$id/messages',
        queryParameters: queryParameters);
  }

  sendMessage({required int id, required String message}) async {
    final client = await getApiClient();

    return client.post('/inbox/$id/messages', data: {
      'message': message,
    });
  }
}
