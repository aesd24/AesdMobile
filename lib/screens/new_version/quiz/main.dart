import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/quiz_model.dart';
import 'package:aesd_app/screens/new_version/quiz/answer.dart';
import 'package:flutter/material.dart';

class QuizMainPage extends StatefulWidget {
  QuizMainPage({super.key, required this.quiz});

  QuizModel quiz;

  @override
  State<QuizMainPage> createState() => _QuizMainPageState();
}

class _QuizMainPageState extends State<QuizMainPage> {
  @override
  Widget build(BuildContext context) {
    int minutes = 0;
    int seconds = widget.quiz.time.inSeconds;
    while (seconds >= 60) {
      minutes++;
      seconds -= 60;
    }
    String responseTime = "$minutes:$seconds";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${widget.quiz.date.day}-${widget.quiz.date.month}-${widget.quiz.date.year}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "${widget.quiz.participantsCount} Participations",
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                widget.quiz.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(),
            ),
            parametersTile(context,
                label: "Nombre de questions",
                value: widget.quiz.questions.length),
            parametersTile(context,
                label: "Temps de réponse", value: responseTime),
            parametersTile(context, label: "J'ai participé", value: "Non"),
            parametersTile(context, label: "Mon score", value: "--"),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: customButton(
                  context: context,
                  text: "Commencer",
                  onPressed: () =>
                      pushForm(context, destination: AnswerPage(quiz: widget.quiz))),
            )
          ],
        ),
      ),
    );
  }

  Widget parametersTile(BuildContext context,
      {required String label, required dynamic value}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            value.toString(),
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
