import 'package:aesd_app/requests/dio_client.dart';

class JobRequest extends DioClient {
  all({dynamic queryParameters}) async {
    final client = await getApiClient();

    return client.get('/jobs', queryParameters: queryParameters);
  }
}
