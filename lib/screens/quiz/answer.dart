import 'dart:async';
import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/option_model.dart';
import 'package:aesd_app/models/question_model.dart';
import 'package:aesd_app/models/quiz_model.dart';
import 'package:aesd_app/screens/quiz/result.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnswerPage extends StatefulWidget {
  AnswerPage({super.key, required this.quiz});

  QuizModel quiz;

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  // gestion du quiz
  int questionIndex = 0;
  Map<QuestionModel, OptionModel> answers = {};

  bool isFinish = false;
  int score = 0;
  late Timer _timer;
  dynamic choice;

  late int secondsLeft;
  getTimeLeft() {
    int minutes = 0;
    int seconds = secondsLeft;
    while (seconds > 60) {
      seconds -= 60;
      minutes++;
    }
    if (seconds == 0) {
      return "0s";
    }
    return "$minutes m : $seconds s";
  }

  @override
  void initState() {
    super.initState();

    // initialiser le temps de reponse
    secondsLeft = widget.quiz.time.inSeconds;

    // Réduire le temps restant à chaque seconde écoulé
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 0) {
        setState(() {
          secondsLeft--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isFinish = secondsLeft <= 0;

    Color timeColor;
    if (secondsLeft > (secondsLeft * 2) / 3) {
      timeColor = Colors.green;
    } else if (secondsLeft > secondsLeft / 3) {
      timeColor = Colors.yellow;
    } else {
      timeColor = Colors.red;
    }

    // récupérer toutes les questions du quiz
    List<QuestionModel> questions = widget.quiz.questions;

    return PopScope(
      canPop: isFinish,
      onPopInvoked: (v) {
        if (!isFinish) {
          showSnackBar(
              context: context,
              message: "Finissez le quiz avant de fermer la fenêtre",
              type: SnackBarType.warning);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Temps restant:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.grey),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              getTimeLeft(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: timeColor,
                                  ),
                            )
                          ],
                        ),
                        Text(
                          "Question ${questionIndex + 1}/${questions.length}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey),
                        )
                      ],
                    ),
                    Builder(builder: (context) {
                      var currentQuestion = questions[questionIndex];
                      var propositions = currentQuestion.options;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                currentQuestion.text,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                                children:
                                    List.generate(propositions.length, (index) {
                              var current = propositions[index];
                              return questionProposition(
                                  title: current.option,
                                  value: current,
                                  groupValue: choice,
                                  onChange: (value) {
                                    setState(() {
                                      choice = value;
                                    });
                                  });
                            })),
                          ),
                          const SizedBox(height: 30),
                          customButton(
                              context: context,
                              text: "Suivant",
                              trailing: const FaIcon(
                                FontAwesomeIcons.arrowRight,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (choice != null) {
                                  // Enregistrer la reponse du joueur
                                  answers[questions[questionIndex]] = choice;

                                  if (questionIndex < questions.length - 1) {
                                    // Increment the question index
                                    setState(() {
                                      questionIndex++;
                                    });

                                    choice = null;
                                  } else {
                                    isFinish = true;
                                    print(answers.toString());
                                    pushReplaceForm(context,
                                        destination: QuizResultPage(
                                            quiz: widget.quiz,
                                            answers: answers));
                                  }
                                } else {
                                  showSnackBar(
                                      context: context,
                                      message: "Veuillez choisir une option",
                                      type: SnackBarType.warning);
                                }
                              })
                        ],
                      );
                    })
                  ]),
            )),
      ),
    );
  }

  AnimatedContainer questionProposition(
      {required String title,
      required void Function(dynamic) onChange,
      required dynamic value,
      required dynamic groupValue}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: value == groupValue ? Colors.green.shade100 : null,
      ),
      child: ListTile(
        onTap: () => onChange(value),
        title: Text(title),
      ),
    );
  }
}
