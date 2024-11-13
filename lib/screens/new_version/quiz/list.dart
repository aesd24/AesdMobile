import 'package:aesd_app/components/text_field.dart';
import 'package:aesd_app/models/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuizzesList extends StatefulWidget {
  const QuizzesList({super.key});

  @override
  State<QuizzesList> createState() => _QuizzesListState();
}

class _QuizzesListState extends State<QuizzesList> {
  // liste des quiz
  final List<QuizModel> _quizzes = List.generate(5, (index) {
    return QuizModel.fromJson({
      'id': index,
      'title': "Quiz numéro ${index + 1}",
      'date': "200$index-0${index + 1}-0${index + 1}",
      'participantsCount': index + 2,
      'description': "Description du quiz numéro $index",
      'time': (index + 1) * 100,
      'questions': List.generate(3, (index) {
        return {
          'id': index,
          'question_text': "Intitulé de la question ${index + 1}",
          'options': List.generate(3, (index) {
            return {
              'id': index,
              'option': "Possibilité de reponse ${index + 1}",
              'isCorrect': index == 3,
            };
          })
        };
      })
    });
  });

  // controller de recherche
  final TextEditingController _searchController = TextEditingController();

  // variable de control du trie (trier par)
  String sortBy = "title";

  List quizFilter() {
    if (_searchController.text.isEmpty) {
      return _quizzes;
    } else {
      List returned = [];
      for (var element in _quizzes) {
        if (element.title
          .toString()
          .toLowerCase()
          .contains(_searchController.text.toLowerCase())) {
        returned.add(element);
        }
      }
      return returned;
    }
  }

  List sortedQuizzes() {
    List returned = quizFilter();
    if (sortBy == "title") {
      // trier par titres
      returned.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortBy == "date") {
      // trier par date (de la plus récente à la plus ancienne)
      returned.sort((a, b) => b.date.compareTo(a.date));
    } else if (sortBy == "actors") {
      // trier par participants
      returned
          .sort((a, b) => b.participantsCount.compareTo(a.participantsCount));
    }
    return returned;
  }

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
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  suffix: PopupMenuButton(
                      icon: const FaIcon(FontAwesomeIcons.sort,
                          size: 22, color: Colors.grey),
                      onSelected: (value) {
                        setState(() {
                          sortBy = value;
                        });
                      },
                      itemBuilder: (context) {
                        return const [
                          PopupMenuItem(
                              value: 'title', child: Text("Trier par titre")),
                          PopupMenuItem(
                              value: 'date', child: Text("Trier par date")),
                          PopupMenuItem(
                              value: 'actors',
                              child: Text("Trier par participant")),
                        ];
                      })),
              Column(
                children: List.generate(sortedQuizzes().length, (index) {
                  var current = sortedQuizzes()[index];
                  return current.toTile(context);
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
