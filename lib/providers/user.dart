import 'package:flutter/material.dart';

class User extends ChangeNotifier{
  // sauvegarde des données d'enregistrement ou de mise a jour d'utilisateur
  final Map _registerData = {};

  get registerData => _registerData; // getter

  // setter
  void setRegisterData (Map<String, dynamic> data) {
    data.forEach((key, value){
      _registerData[key] = value;
    });
  }
}