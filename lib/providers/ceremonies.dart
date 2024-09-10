import 'package:aesd_app/models/ceremony.dart';
import 'package:aesd_app/requests/ceremony_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Ceremonies extends ChangeNotifier {
  final _handler = CeremonyRequest();
  final List<CeremonyModel> _ceremonies = [];

  get ceremonies => _ceremonies;

  Future all() async {
    final response = await _handler.getAll();
    if (response.statusCode == 200){
      _ceremonies.clear();
      for (var element in response.data['data']){
        _ceremonies.add(CeremonyModel.fromJson(element));
      }
      notifyListeners();
      return _ceremonies;
    }
    else {
      throw Exception("Impossible d'obtenir la liste des cérémonies");
    }
  }

  Future create(Map<String, dynamic> data) async {
    var body = FormData.fromMap({
      "title" : data['title'],
      "description" : data['description'],
      "event_date": data['date'],
      "video" : await MultipartFile.fromFile(data['video'])
    });

    return _handler.create(body);
  }
}