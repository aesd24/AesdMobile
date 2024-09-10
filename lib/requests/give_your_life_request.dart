import 'package:aesd_app/requests/dio_client.dart';

class GiveYourLifeRequest extends DioClient {
  send({
    required String name,
    required String phone,
    required String address,
    required String subject,
  }) async {
    final client = await getApiClient();

    return client.post('/give-your-life', data: {
      'name': name,
      'phone': phone,
      'address': address,
      'subject': subject,
    });
  }
}
