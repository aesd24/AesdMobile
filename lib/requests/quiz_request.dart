import 'package:aesd_app/requests/dio_client.dart';

class QuizRequest extends DioClient {
  all({dynamic queryParameters}) async {
    final client = await getApiClient();

    return client.get('/quizzes', queryParameters: queryParameters);
  }

  show(String slug) async {
    final client = await getApiClient();

    return client.get('/quizzes/$slug/show');
  }

  canPlay(String slug) async {
    final client = await getApiClient();

    return client.get('/quizzes/$slug/can-play');
  }

  sendResult({required String slug, required List<dynamic> results}) async {
    final client = await getApiClient();

    return client.post('/quizzes/$slug/send-results', data: {
      'results': results,
    });
  }

  participants({required String slug, required dynamic queryParameters}) async {
    final client = await getApiClient();

    return client.get('/quizzes/$slug/participants',
        queryParameters: queryParameters);
  }
}
