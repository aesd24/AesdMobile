import 'package:aesd_app/requests/dio_client.dart';

class ForumRequest extends DioClient {
  all({dynamic queryParameters}) async {
    final client = await getApiClient();

    return client.get('/forums', queryParameters: queryParameters);
  }

  addComment({required String slug, required String message}) async {
    final client = await getApiClient();

    return client
        .post('/forums/$slug/add-comment', data: {'comment': message});
  }
}
