import 'package:aesd_app/requests/dio_client.dart';

class PostRequest extends DioClient {
  all({dynamic queryParameters}) async {
    final client = await getApiClient();

    return client.get('/posts', queryParameters: queryParameters);
  }
}
