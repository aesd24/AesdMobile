import 'dart:io';
//import 'package:aesd_app/models/user_model.dart';
import 'package:aesd_app/requests/auth_request.dart';
import 'package:aesd_app/services/cache/un_expired_cache.dart';
//import 'package:aesd_app/services/session/storage_auth_token_session.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
/*   StorageAuthTokenSession _authToken =
      StorageAuthTokenSession(type: '', token: ''); */

  // Token d'accès

  final UnExpiredCache _unExpiredCache = UnExpiredCache();

  final request = AuthRequest();

  Future login({
    required String login,
    required String password,
  }) async {
    final response =
        await request.login(data: {'login': login, 'password': password});

    if (response.statusCode == 200) {
      setToken(
          type: response.data['token_type'],
          token: response.data['access_token']);
    } else {
      throw const HttpException(
          'Informations de connexion érronées. Rééssayez');
    }

    return response;
  }

  // Création du formulaire pour l'envoie des fichiers
  Future register({required Map data}) async {
    FormData formData = FormData.fromMap({
      "name": data["name"],
      "email": data["email"],
      "phone": data['phone'],
      "account_type": data['account_type'],
      "password": data["password"],
      "password_confirmation": data['password_confirmation'],
      "adresse": data['adress'],
      "appel": data['call'],
      "profile_photo": data["account_type"].toLowerCase() != "serviteur_de_dieu"
          ? await MultipartFile.fromFile(data['id_picture'].path,
              filename: "${data["name"]}_id_pic.jpg")
          : null,
      "id_card_recto": data["account_type"] == "serviteur_de_dieu"
          ? await MultipartFile.fromFile(data['id_card_recto'].path,
              filename: "${data["name"]}_card_recto.jpg")
          : null,
      "id_card_verso": data["account_type"] == "serviteur_de_dieu"
          ? await MultipartFile.fromFile(data['id_card_verso'].path,
              filename: "${data["name"]}_card_verso.jpg")
          : null
    });

    // envoie de la requête et le résultat est stocké dans la variable "response"
    final response = await request.register(data: formData);

    print(response.data);

    if (response.statusCode == 201) {
      return response;
    } else {
      String message = "";
      if (response.data['errors'] != null) {
        response.data['errors'].forEach((key, value) {
          message += "${value[0]}\n";
        });
      }
      throw HttpException("${response.data['message']} \n$message");
    }
  }

  // Enregistrer le token de l'utilisateur
  void setToken({required String type, required String token}) {
    ////print("$type $token");
    _unExpiredCache.put(key: "access_token", value: "$type $token");
    notifyListeners();
  }

  Future<void> logout() async {
    var response = await request.logout();
    if (response.statusCode == 200) {
      _unExpiredCache.remove("access_token");
    } else {
      throw const HttpException("La déconnexion à échoué n'a pu aboutir");
    }

    notifyListeners();
  }

  Future verifyOtp({required String otpCode}) async {
    var result = await request.verifyOtp(code: otpCode);
    if (result.data["errors"] != null){
      for (var error in result.data['errors']) {
        throw HttpException(error);
      }
    }
    if (result.statusCode >= 400){
      throw HttpException(result.data['message']);
    }
    return result;
  }

  Future forgotPassword({required String email}) async {
    var result = await request.forgotPassword(user_info: email);
    if (result.data['errors'] != null) {
      for (var error in result.data['errors']) {
        throw HttpException(error);
      }
    }
    if (result.statusCode >= 400){
      throw HttpException(result.data['message']);
    }
    return result;
  }

  Future changePassword({
    required String email,
    required String newPassword,
    required String newPasswordConfirmation
  }) async {
    final formData = FormData.fromMap({
      "email": email,
      "password": newPassword,
      "password_confirmation": newPasswordConfirmation
    });
    final result = await request.changePassword(formData);
    if (result.data['errors'] != null) {
      for (var error in result.data['errors']) {
        throw HttpException(error);
      }
    }
    if (result.statusCode >= 400){
      throw HttpException(result.data['message']);
    }
    return result;
  }

  Future modifyInformation(Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);
    final result = await request.modifyInformation(formData);
    if (result.data['errors'] != null) {
      for (var error in result.data['errors']) {
        throw HttpException(error);
      }
    }
    if (result.statusCode >= 400){
      throw HttpException(result.data['message']);
    }
    return result;
  }

  // Récupérer le token de l'utilisateur
  Future<String?> getToken() async {
    String? token;
    await _unExpiredCache.get(key: "access_token").then((value) {
      if (value != null) {
        token = value;
      }
    });

    return token;
  }
}
