import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/question_model.dart';
import 'package:aesd_app/screens/quiz/main.dart';
import 'package:flutter/material.dart';

class QuizModel {
  late int id;
  late String title;
  late DateTime date;
  late int participantsCount;
  late String description;
  List<QuestionModel> questions = [];
  late Duration time;

  QuizModel();

  QuizModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = DateTime.parse(json['date']);
    participantsCount = json['participantsCount'];
    description = json['description'];
    json['questions'].forEach(
        (question) => {questions.add(QuestionModel.fromJson(question))});
    time = Duration(seconds: json['time']);
  }
  
  toTile(context) => GestureDetector(
    onTap: () => pushForm(context, destination: QuizMainPage(quiz: this)),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(3),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$participantsCount Participations"),
            Text("${date.day}-${date.month}-${date.year}")
          ],
        ),
      ),
    ),
  );
}
