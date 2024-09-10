import 'package:aesd_app/models/option_model.dart';

class QuestionModel {
  late int id;
  late String text;
  late List<OptionModel> options = [];

  QuestionModel();

  QuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['question_text'];

    json['options'].forEach((option) {
      options.add(OptionModel.fromJson(option));
    });
  }
}
