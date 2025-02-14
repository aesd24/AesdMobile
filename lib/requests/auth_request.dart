import 'package:dio/dio.dart';

import 'dio_client.dart';

class AuthRequest extends DioClient {
  
  Future login({required Map data}) async {
    final client = await getApiClient();
    return client.post('login', data: {
      'user_info': data['login'],
      'password': data['password'],
    });
  }

  Future register({required Object data}) async {
    final client = await getApiClient();
    return await client.post('register', data: data);
  }

  Future logout() async {
    final client = await getApiClient();
    return client.post('logout');
  }

  Future forgotPassword({required String user_info}) async {
    final client = await getApiClient();
    return await client.post('password/forgot', data: {'user_info': user_info});
  }

  Future changePassword(FormData formdata) async {
    final client = await getApiClient();
    return await client.post('password/reset', data: formdata);
  }

  Future verifyOtp({required String code}) async {
    final client = await getApiClient();
    return client.post('verify-Otp', data: {'otp_code': code});
  }

  Future modifyInformation(FormData formData) async {
    final client = await getApiClient();
    return await client.post('update-profile', data: formData);
  }
}
