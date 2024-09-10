import 'package:aesd_app/requests/dio_client.dart';

class DonationRequest extends DioClient {
  all({dynamic queryParameters}) async {
    final client = await getApiClient();

    return client.get('/donations', queryParameters: queryParameters);
  }
}
