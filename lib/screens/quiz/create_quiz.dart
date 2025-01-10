import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/components/field.dart';
import 'package:flutter/material.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  // controllers
  final _titleController = TextEditingController();

  // clé de formulaire
  final _formKey = GlobalKey<FormState>();

  // Liste des questions et leurs reponses
  List<Map<String, dynamic>> questionFields = [];

  @override
  void initState() {
    super.initState();
    createQuestionEntry(1);
  }

  createQuestionEntry(int nombre) {
    for (var i = 0; i < nombre; i++) {
      questionFields.add({
        "question": "",
        "propositions": ["", "", ""],
        "answer": 0,
      });
    }
    setState(() {});
  }

  addPropositionEntry(int questionIndex) {
    questionFields[questionIndex]["propositions"].add("");
    setState(() {});
  }

  removePropositionEntry(int index, int questionIndex) {
    questionFields[questionIndex]["propositions"].removeAt(index);
    setState(() {});
  }

  removeQuestionEntry(int index) {
    questionFields.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(children: [
              customTextField(
                  label: "Titre du quiz",
                  placeholder: "Ex: La vie de Christ",
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez donner un titre a votre quiz";
                    }
                    return null;
                  }),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    // les questions du quiz
                    Column(
                        children: List.generate(questionFields.length, (value) {
                      return questionGroupBox(
                          index: value, removable: value > 0);
                    })),

                    const SizedBox(height: 15),

                    // Les boutons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // bouton pour ajouter une nouvelle entrée
                        IconButton(
                          onPressed: () => createQuestionEntry(1),
                          icon: const Icon(
                            Icons.add,
                            color: Colors.green,
                          ),
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Colors.green.shade100),
                              overlayColor:
                                  WidgetStateProperty.all(Colors.white12)),
                        ),

                        // bouton pour envoyer les données
                        ElevatedButton.icon(
                          onPressed: () {
                            print(questionFields);
                            if (_formKey.currentState!.validate()) {
                              for (var field in questionFields) {
                                if (field["question"] == null ||
                                    field["question"]!.isEmpty) {
                                  showSnackBar(
                                      context: context,
                                      message:
                                          "Tout les champs de question existants doivent être remplis",
                                      type: SnackBarType.warning);
                                  return;
                                }

                                if (field["answer"] == null ||
                                    field["answer"]!.isEmpty) {
                                  showSnackBar(
                                      context: context,
                                      message:
                                          "Donnez les réponses à toutes les questions s'il vous plaît",
                                      type: SnackBarType.warning);
                                  return;
                                }
                              }
                            }
                          },
                          icon: const Icon(Icons.send),
                          iconAlignment: IconAlignment.end,
                          label: const Text("Envoyer"),
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.green),
                              foregroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              overlayColor:
                                  WidgetStateProperty.all(Colors.white12)),
                        )
                      ],
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget questionGroupBox({required int index, bool removable = true}) {
    // controllers
    final questionController = TextEditingController();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Question ${index + 1}",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              if (removable)
                TextButton.icon(
                  onPressed: () => removeQuestionEntry(index),
                  label: const Text("Effacer"),
                  icon: const Icon(Icons.remove_circle),
                  iconAlignment: IconAlignment.end,
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.red.shade100),
                      foregroundColor: WidgetStateProperty.all(Colors.red)),
                )
            ],
          ),
          customTextField(
              label: "Question",
              controller: questionController,
              onChanged: (value) {
                questionFields[index]['question'] = questionController.text;
              }),
          propositionGroupBox(
              questionIndex: index,
              propositions: questionFields[index]['propositions'])
        ],
      ),
    );
  }

  Widget propositionBox(
      {required int index,
      required int questionIndex,
      bool removable = false}) {
    return Row(
      children: [
        Expanded(child: customTextField(label: "Proposition ${index + 1}")),
        if (removable)
          IconButton(
            onPressed: () => removePropositionEntry(index, questionIndex),
            icon: const Icon(Icons.delete, color: Colors.red),
          )
      ],
    );
  }

  Widget propositionGroupBox(
      {required int questionIndex, required List<String> propositions}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Liste des propositions possibles
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(propositions.length, (value) {
                  return propositionBox(
                      index: value,
                      questionIndex: questionIndex,
                      removable: value > 2);
                }),
              ),

              // bouton pour ajouter une nouvelle entrée
              TextButton.icon(
                onPressed: () => addPropositionEntry(questionIndex),
                label: const Text("Ajouter"),
                icon: const Icon(Icons.add_circle),
              ),

              const SizedBox(height: 10),

              // partie de choix de la réponse correcte
              Text(
                "Choisissez la réponse correcte :",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Wrap(
                  spacing: 20,
                  children: List.generate(propositions.length, (value) {
                    int answer = questionFields[questionIndex]["answer"];
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(
                          value: value,
                          onChanged: (value) {
                            setState(() {
                              questionFields[questionIndex]["answer"] = value;
                            });
                          },
                          groupValue: answer,
                        ),
                        Text("Proposition ${value + 1}")
                      ],
                    );
                  }))
            ]),
          ),
          Positioned(
            left: 10.0,
            top: 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(5))),
              child: Text(
                "Propositions possibles",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
