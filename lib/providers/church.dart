import 'dart:async';
import 'dart:io';
import 'package:aesd_app/models/church_model.dart';
import 'package:aesd_app/requests/church_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Church extends ChangeNotifier {
  final int _currentPage = 0;
  late ChurchPaginator _paginator;
  final ChurchRequest _request = ChurchRequest();
  final List<ChurchModel> _churches = [];

  List<ChurchModel> get churches => _churches;

  Future fetchChurches() async {
    final response = await _request.all(page: _currentPage);
    if (response.statusCode == 200) {
      final data = response.data;
      //print(data);
      _paginator = ChurchPaginator.fromJson(data);
      if (_churches.isNotEmpty && _currentPage == 0) {
        _churches.clear();
      }
      _churches.addAll(_paginator.churches);
    }
  }

  Future one() async {
    try {
      var response = await _request.one();
      return response;
    } catch (e) {
      //print("Une erreur est survenue lors de la récupération de l'église");
    }
  }

  Future create({required Map<String, dynamic> data}) async {
    FormData formData = FormData.fromMap({
      'name': data['name'],
      'adresse': data['location'],
      'phone': data['phone'],
      'email': data['email'],
      'description': data['description'],
      'type_church': data['churchType'],
      'logo': await MultipartFile.fromFile(data['image'].path),
      'attestation_file_path':
          await MultipartFile.fromFile(data['attestation_file'].path),
      'is_main': data['isMain'],
      'main_church_id': data['mainChurchId']
    });

    var response = await ChurchRequest().create(formData);
    print(response);
    if (response.statusCode == 201) {
      return true;
    } else {
      throw const HttpException("La création de l'église à échoué. Rééssayez");
    }
  }
}
