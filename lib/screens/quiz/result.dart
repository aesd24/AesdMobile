import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuizResultPage extends StatefulWidget {
  QuizResultPage({super.key, required this.quiz, required this.answers});

  QuizModel quiz;
  Map answers;

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  @override
  Widget build(BuildContext context) {
    var questions = widget.quiz.questions;
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Résultats",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Score",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Colors.green.withOpacity(.7),
                                      fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "200",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: List.generate(widget.answers.length, (index) {
                          var currentAnswer = widget.answers[questions[index]];
                          return ListTile(
                              title: Text(
                                currentAnswer.option,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: currentAnswer.isCorrect
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                questions[index].text,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                              trailing: currentAnswer.isCorrect
                                  ? const FaIcon(
                                      FontAwesomeIcons.check,
                                      color: Colors.green,
                                    )
                                  : const FaIcon(
                                      FontAwesomeIcons.xmark,
                                      color: Colors.red,
                                    ));
                        }),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: customButton(
                        context: context,
                        text: "Terminer",
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                        trailing: const FaIcon(
                          FontAwesomeIcons.check,
                          color: Colors.green,
                        ),
                        onPressed: () => closeForm(context)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
