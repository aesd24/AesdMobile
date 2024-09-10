import 'dio_client.dart';

class AuthRequest extends DioClient {
  login({
    required String email,
    required String password,
    required String deviceName
  }) async {
    final client = await getApiClient();

    client.post('/auth/token', data: {
      'email': email,
      'password': password,
      'device_name': deviceName
    }).then((response){
      return response;
    });
  }

  register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String deviceName,
    required bool terms,
  }) async {
    final client = await getApiClient();

    return client.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'device_name': deviceName,
      'terms': terms
    });
  }


  getUserInfo() async {
    final client = await getApiClient();

    return client.get('/auth/info');
  }

  logout() async {
    final client = await getApiClient();
    return client.delete('/auth/token/destroy');
  }
}