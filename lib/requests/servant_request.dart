import 'package:aesd_app/requests/dio_client.dart';

class ServantRequest extends DioClient {
  all({dynamic queryParameters}) async {
    final client = await getApiClient();

    return client.get('/servants', queryParameters: queryParameters);
  }

  one() async {
    final client = await getApiClient();
    return await client.get('servant/');
  }
}
