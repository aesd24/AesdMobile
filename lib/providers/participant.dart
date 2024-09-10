import 'package:aesd_app/models/paginator.dart';
import 'package:aesd_app/models/participant_model.dart';
import 'package:aesd_app/services/web/quiz_service.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Participant extends ChangeNotifier {
  final QuizService _quizService = QuizService();
  List<ParticipantModel> _participants = [];
  late Paginator _paginator;

  Future<Tuple2<List<ParticipantModel>, Paginator>> all(
      {required String slug, required dynamic queryParameters}) async {
    _participants = [];
    try {
      final data = await _quizService.participants(
          slug: slug, queryParameters: queryParameters);

      data['data'].forEach((d) {
        _participants.add(ParticipantModel.fromJson(d));
      });

      _paginator = Paginator.fromJson(data);
    } catch (e) {
      //
    }

    return Tuple2(_participants, _paginator);
  }
}
