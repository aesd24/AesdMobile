import 'package:aesd_app/models/user_model.dart';

class ParticipantModel {
  late int id;
  late UserModel user;
  late int correctQuestionTotal;
  late String time;

  ParticipantModel();

  ParticipantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = UserModel.fromJson(json['user']);
    correctQuestionTotal = json['correct_question_total'];
    time = json['timer'].toString();
  }
}
