import 'dart:io';
import 'package:aesd_app/models/user_model.dart';
import 'package:aesd_app/requests/dio_client.dart';
import 'package:aesd_app/services/cache/un_expired_cache.dart';
import 'package:aesd_app/services/session/storage_auth_token_session.dart';
import 'package:aesd_app/services/web/auth_web_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';

class Auth extends ChangeNotifier {
  StorageAuthTokenSession _authToken = StorageAuthTokenSession(type: '', token: '');
  final UnExpiredCache _unExpiredCache = UnExpiredCache();
  final AuthWebService _authService = AuthWebService();
  late UserModel user;

  Future<Map<String, dynamic>> login(
    {
      required String email,
      required String password,
    }) async {
    Map<String, dynamic> returned = {};

    var client = await DioClient().getApiClient();
    final response = await client.post("auth/token", data: {
      "email": email,
      "password": password,
      "device_name": "xxxxx"
    });

    final data = response.data;

    if (response.statusCode == 200){
      if (data['success']){
        setUserData(UserModel.fromJson(data['user']));

        _authToken.storeOnSecureStorage(
          type: data['token_type'],
          token: data['token']
        ).then((StorageAuthTokenSession authToken) => {
          setToken(type: authToken.type, token: authToken.token)
        });

        returned["success"] = true;
        returned["message"] = "C'est partit 😉 !!";
      }
    } else if (response.statusCode! >= 400){
      returned["success"] = false;
      returned["message"] = "Information de connexion incorrects !";
    }

    return returned;
  }

  Future register({required Map data}) async {
    // Création du formulaire pour l'envoie des fichiers
    FormData formData = FormData.fromMap({
      "account_type": data['account_type'],
      "name": data["name"],
      "email": data["email"],
      "phone": data['phone'],
      "password": data["password"],
      "password_confirmation": data["password_confirmation"],
      "device_name": "xxxxx",
      "terms": data["terms"],
      "call": data['call'],
      "id_picture": data["account_type"].toLowerCase() != "ftf" ? await MultipartFile.fromFile(data['id_picture'].path, filename: "${data["name"]}_id_pic.jpg") : null,
      "id_card_recto": data["account_type"].toLowerCase() != "ftf" ? await MultipartFile.fromFile(data['id_card_recto'].path, filename: "${data["name"]}_card_recto.jpg") : null,
      "id_card_verso": data["account_type"].toLowerCase() != "ftf" ? await MultipartFile.fromFile(data['id_card_verso'].path, filename: "${data["name"]}_card_verso.jpg") : null
    });
    
    var client = await DioClient().getApiClient(
      contentType: "multipart/form-data; boundary=${formData.boundary}"
    );

    // envoie de la requête et le résultat est stocké dans la variable "response"
    final response = await client.post("auth/register", data : formData);

    return response.data;
  }

  Future sendFileTest(File image) async {
    final formData = FormData.fromMap({
      "image" : await MultipartFile.fromFile(image.path, filename: "image.jpg")
    });

    var client = await DioClient().getApiClient(
      contentType: "multipart/form-data; boundary=${formData.boundary}"
    );

    return client.post("auth/test", data: formData);
  }

  void setToken({required String type, required String token}) {
    _authToken = StorageAuthTokenSession(type: type, token: token);
    notifyListeners();
  }

  StorageAuthTokenSession getAuthToken() {
    return _authToken;
  }

  bool isLogged() {
    return _authToken.token != '';
  }

  Future<void> logout() async {
    await _authService.logout().then((value) async {
      await Future.wait([
        _unExpiredCache.remove('user_info'),
        _authToken.deleteOnSecureStorage().then(
          (v) => {setToken(type: '', token: '')}
        )
      ]);
    });

    notifyListeners();
  }

  Future<void> setUserData(UserModel userModel) async {
    user = userModel;

    await _unExpiredCache.put(key: 'user_info', value: user.toJson());

    notifyListeners();
  }

  Future<UserModel> getUserInfoFromCache() async {
    await _unExpiredCache.get(key: 'user_info').then((value) async {
      if (value != null){
        user = UserModel.fromJson(value);
        await _unExpiredCache.put(key: 'user_info', value: user.toJson());
      }
    });

    notifyListeners();

    return user;
  }
}
