import 'package:aesd_app/requests/dio_client.dart';

class CourseRequest extends DioClient {
  deferred({dynamic queryParameters}) async {
    final client = await getApiClient();

    return client.get('/deferred-courses', queryParameters: queryParameters);
  }

  streams({dynamic queryParameters}) async {
    final client = await getApiClient();

    return client.get('/streams', queryParameters: queryParameters);
  }

  playStream(String slug) async {
    final client = await getApiClient();

    return client.get('/streams/$slug/play');
  }

  create({required String title, required String description}) async {
    final client = await getApiClient();

    return client.post('/streams/create', data: {
      'title': title,
      'description': description,
    });
  }


  sendCoin({required String slug, required int coinId}) async {
    final client = await getApiClient();

    return client.post('/streams/$slug/send-coin', data: {
      'coin_id': coinId
    });
  }
}
