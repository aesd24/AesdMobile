import 'package:aesd_app/components/text_field.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/screens/new_version/quiz/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class QuizzesList extends StatefulWidget {
  const QuizzesList({super.key});

  @override
  State<QuizzesList> createState() => _QuizzesListState();
}

class _QuizzesListState extends State<QuizzesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quizzes"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset(
              "assets/icons/quiz.png",
              height: 30,
              width: 30,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              customTextField(
                  label: "Recherche",
                  placeholder: "Entrez votre recherche ici",
                  prefixIcon: const Icon(Icons.search),
                  suffix: PopupMenuButton(
                      icon: const FaIcon(FontAwesomeIcons.sort,
                          size: 22, color: Colors.grey),
                      itemBuilder: (context) {
                        return const [
                          PopupMenuItem(value: 0, child: Text("Trier par nom")),
                          PopupMenuItem(
                              value: 0, child: Text("Trier par date")),
                          PopupMenuItem(
                              value: 0, child: Text("Trier par participant")),
                        ];
                      })),
              Column(
                children: List.generate(5, (index) {
                  return quizTile(
                    title: "Quiz numéro $index",
                    interventions: index + 1,
                    emitionDate: DateTime.now()
                        .subtract(Duration(days: (index + 1) * 7)),
                    onTap: () {
                      pushForm(context, destination: const QuizMainPage());
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector quizTile(
      {required String title,
      required int interventions,
      required DateTime emitionDate,
      required void Function()? onTap}) {
    String date = DateFormat("dd-MM-yyyy").format(emitionDate);
    return GestureDetector(
      onTap: onTap,
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
              Text("$interventions Participations"),
              Text(date.toString())
            ],
          ),
        ),
      ),
    );
  }
}
