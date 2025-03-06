import 'dart:io';

import 'package:aesd_app/models/ceremony.dart';
import 'package:aesd_app/requests/ceremony_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Ceremonies extends ChangeNotifier {
  final _handler = CeremonyRequest();
  final List<CeremonyModel> _ceremonies = [];

  get ceremonies => _ceremonies;

  Future all({required int churchId}) async {
    final response = await _handler.getAll();
    if (response.statusCode == 200){
      _ceremonies.clear();
      for (var element in response.data['data']){
        _ceremonies.add(CeremonyModel.fromJson(element));
      }
      notifyListeners();
    }
    else {
      throw HttpException("Impossible d'obtenir la liste des cérémonies");
    }
  }

  Future create(Map<String, dynamic> data) async {
    var body = FormData.fromMap({
      "title" : data['title'],
      "description" : data['description'],
      "event_date": data['date'],
      "media" : await MultipartFile.fromFile(data['movie']),
      "id_eglise": data['church_id'],
    });

    var response = await _handler.create(body);
    print(response);
    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw HttpException("erreur: ${response.data['message']}");
    }
  }
}