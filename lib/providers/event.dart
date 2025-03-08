import 'dart:io';

import 'package:aesd_app/models/event.dart';
import 'package:aesd_app/requests/event.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Event extends ChangeNotifier {
  final _request = EventRequest();
  final List<EventModel> _eventList = [];

  List<EventModel> get events => _eventList;

  Future createEvent(Map<String, dynamic> data) async {
    final formData = FormData.fromMap({
      'titre': data['title'],
      'description': data['description'],
      'date_debut': data['startDate'],
      'date_fin': data['endDate'],
      'lieu': data['location'],
      'file': await MultipartFile.fromFile(data['file']),
      'type_evenement': data['type'],
      'categorie_evenement': data['category'],
      'organisateur': data['organizer'],
      'est_public': data['is_public'] ? 1 : 0
    });
    final response = await _request.create(formData);
    print(response);
    if (response.statusCode == 201) {
      _eventList.add(EventModel.fromJson(response.data['evenement']));
      notifyListeners();
      return response.data;
    } else {
      throw HttpException("erreur: ${response.data['message']}");
    }
  }

  Future delete(int id) async {
    final response = await _request.delete(id);
    if (response.statusCode == 200) {
      _eventList.removeWhere((element) => element.id == id);
    }
  }

  Future updateEvent(Map<String, dynamic> data, {required int id}) async {
    final formData = FormData.fromMap({
      'titre': data['title'],
      'description': data['description'],
      'date_debut': data['startDate'],
      'date_fin': data['endDate'],
      'lieu': data['location'],
      if(data['file'] != null) 'file': await MultipartFile.fromFile(data['file']),
      'type_evenement': data['type'],
      'categorie_evenement': data['category'],
      'organisateur': data['organizer'],
      'est_public': data['is_public'] ? 1 : 0
    });
    final response = await _request.update(id, formData);
    print(response);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw HttpException("erreur: ${response.data['message']}");
    }
  }

  Future getEvents({required int churchId}) async {
    final response = await _request.getEvents(churchId);
    print(response);
    if (response.statusCode == 200) {
      List events = response.data["evenements"];
      _eventList.clear();
      events.map((e) => _eventList.add(EventModel.fromJson(e))).toList();
      notifyListeners();
    } else {
      throw HttpException("erreur: ${response.data['message']}");
    }
  }
}