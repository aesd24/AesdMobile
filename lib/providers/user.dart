import 'dart:convert';

import 'package:aesd_app/models/user_model.dart';
import 'package:aesd_app/requests/user_request.dart';
import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  final _request = UserRequest();

  late UserModel _userData;
  get user => _userData;

  getUserData() async {
    var response = await _request.getUserData();
    if (response.statusCode == 200) {
      _userData = UserModel.fromJson(jsonDecode(response.data));
    }
  }

  // sauvegarde des données d'enregistrement ou de mise a jour d'utilisateur
  final Map _registerData = {};
  get registerData => _registerData; // getter

  // setter
  void setRegisterData(Map<String, dynamic> data) {
    data.forEach((key, value) {
      _registerData[key] = value;
    });
  }
}
