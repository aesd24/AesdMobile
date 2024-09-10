import 'package:aesd_app/models/question_model.dart';

class QuizModel {
  late int id;
  late String title;
  late String slug;
  late String participantsCount;
  late String description;
  late List<QuestionModel> questions = [];

  QuizModel();

  QuizModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    participantsCount = json['participants_count'].toString();

    json['questions'].forEach(
        (question) => {questions.add(QuestionModel.fromJson(question))});
  }
}
