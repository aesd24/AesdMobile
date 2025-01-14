import 'package:aesd_app/models/paginator.dart';
import 'package:aesd_app/models/quiz_model.dart';
import 'package:aesd_app/requests/quiz_request.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Quiz extends ChangeNotifier {
  final QuizRequest _quizService = QuizRequest();
  List<QuizModel> _quizzes = [];
  late Paginator _paginator;

  Future<Tuple2<List<QuizModel>, Paginator>> all(
      {dynamic queryParameters}) async {
    _quizzes = [];
    try {
      final data = await _quizService.all(queryParameters: queryParameters);

      data['data'].forEach((d) {
        _quizzes.add(QuizModel.fromJson(d));
      });

      _paginator = Paginator.fromJson(data);
    } catch (e) {
//
}

    return Tuple2(_quizzes, _paginator);
  }
}
