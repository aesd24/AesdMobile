import 'dart:async';

import 'package:aesd_app/models/church_model.dart';
import 'package:aesd_app/models/paginator.dart';
import 'package:aesd_app/requests/church_request.dart';
import 'package:aesd_app/services/web/church_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Church extends ChangeNotifier {
  final ChurchService _churchService = ChurchService();
  List<ChurchModel> _churchs = [];
  Paginator _paginator = Paginator();

  Future<Tuple2<List<ChurchModel>, Paginator>> all(
      {dynamic queryParameters}) async {
    _churchs = [];
    try {
      final data = await _churchService.all(queryParameters: queryParameters);

      data['data'].forEach((d) {
        _churchs.add(ChurchModel.fromJson(d));
      });

      _paginator = Paginator.fromJson(data);
    } catch (e) {
      //print(e);
    }

    notifyListeners();

    return Tuple2(_churchs, _paginator);
  }

  Future one() async {
    try{
      var response = await ChurchRequest().one();
      return response;
    } catch (e){
      print("Une erreur est survenue lors de la récupération de l'église");
    }
  }

  Future create({required Map<String, dynamic> data}) async {
    FormData formData = FormData.fromMap({
      'name': data['name'],
      'address': data['location'],
      'phone': data['phone'],
      'email': data['email'],
      'description': data['description'],
      'type' : data['churchType'],
      'logo': await MultipartFile.fromFile(data['image'].path),
      'main': data['isMain'],
      'main_church_id' : data['mainChurchId']
    });

    return ChurchRequest().create(formData);
  }
}
