import 'package:aesd_app/requests/dio_client.dart';

class UserRequest extends DioClient {
  getUserData() async {
    final client = await getApiClient();
    return client.get('user_infos');
  }
}
