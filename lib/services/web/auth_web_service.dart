import 'package:dio/dio.dart';
import 'package:aesd_app/exceptions/http_form_validation_exception.dart';
import 'package:aesd_app/requests/auth_request.dart';
import 'package:get/get.dart';

class AuthWebService {
  final AuthRequest _authRequest = AuthRequest();

  Future<dynamic> login(
      {required String email,
      required String password,
      required String deviceName}) async {
    try {
      final response = await _authRequest.login(
        email: email, password: password, deviceName: deviceName
      );
      return response.data;
    } on DioException catch (e) {
      //print(e.response);
      if (e.response?.statusCode == 422) {
        throw HttpFormValidationException(e.response?.data);
      }
    }
  }

  Future<dynamic> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String deviceName,
    required bool terms,
  }) async {
    try {
      var response = await _authRequest.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        deviceName: deviceName,
        terms: terms,
      );

      return response.data;
    } on DioException catch (e) {
      //print(e.response?.data);
      if (e.response?.statusCode == 422) {
        throw HttpFormValidationException(e.response?.data);
      }
    }
  }

  Future<void> logout() async {
    try{
      await _authRequest.logout();
    } on DioException catch(e){
      e.printError();
    }
  }
}
