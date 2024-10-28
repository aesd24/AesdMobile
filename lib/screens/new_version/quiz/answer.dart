import 'dart:async';

import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:flutter/material.dart';

class AnswerPage extends StatefulWidget {
  const AnswerPage({super.key});

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  bool isFinish = false;
  int questionNumber = 1;
  int score = 0;
  late Timer _timer;
  dynamic choice;

  int secondsLeft = const Duration(seconds: 5).inSeconds;
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
        appBar: AppBar(
          title: Text('Question $questionNumber'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Temps restant:',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          getTimeLeft(),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: timeColor,
                                  ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Intitulé de la question",
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
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          children: List.generate(3, (index) {
                        return questionProposition(
                            title: "Proposition de reponse $index",
                            value: index,
                            groupValue: choice,
                            onChange: (value) {
                              setState(() {
                                choice = value;
                              });
                            });
                      })),
                    ),
                    const SizedBox(height: 30),
                    Row(children: [
                      Expanded(
                        child: customButton(
                            context: context,
                            text: "Annuler",
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            trailing: const Icon(
                              Icons.cancel,
                              color: Colors.white,
                            ),
                            onPressed: () {}),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: customButton(
                            context: context,
                            text: "Suivant",
                            trailing: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                            onPressed: () {}),
                      )
                    ])
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
