import 'dart:io';
import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/picture_containers.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/components/text_field.dart';
import 'package:aesd_app/functions/camera_functions.dart';
import 'package:flutter/material.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  List months = [
    "Janvier",
    "Février",
    "Mars",
    "Avril",
    "Mai",
    "Juin",
    "Juillet",
    "Août",
    "Septembre",
    "Octobre",
    "Novembre",
    "Décembre"
  ];

  // affiche de l'évènement
  File? image;

  // date de l'évènement
  DateTime? _eventDate;

  // controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // clé de formulaire
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Création d'évènement"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // partie de l'affiche
              image == null
                  ? GestureDetector(
                      onTap: () async {
                        // selectionner une photo depuis la galérie
                        image = await pickImage(camera: true);
                        setState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(width: 1.5, color: Colors.green)),
                        alignment: Alignment.center,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.photo_size_select_actual_rounded,
                                color: Colors.green),
                            SizedBox(width: 15),
                            Text("Ajouter l'affiche de l'évènement")
                          ],
                        ),
                      ),
                    )
                  : imageSelectionBox(
                      context: context,
                      label: "",
                      overlayText: "Cliquez pour changer",
                      picture: image,
                      onClick: () async {
                        File? pickedFile = await pickImage(camera: true);
                        setState(() {
                          image = pickedFile;
                        });
                      }),

              // formulaire de création de l'évènement
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // titre de l'évènement
                      customTextField(
                          label: "Titre de l'évènement",
                          placeholder: "Ex: La campagne AESD",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Remplissez d'abords le champs !";
                            }
                            return null;
                          },
                          prefixIcon: const Icon(Icons.event_note)),

                      // date de l'évènement
                      customButton(
                          context: context,
                          text: _eventDate == null
                              ? "Ajouter la date de l'évènement"
                              : "Prévu le : ${_eventDate!.day} ${months[_eventDate!.month - 1]} ${_eventDate!.year}",
                          trailing: const Icon(Icons.date_range),
                          border:
                              const BorderSide(width: 2, color: Colors.grey),
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          highlightColor: Colors.white,
                          onPressed: () async {
                            // sélectionner une date
                            _eventDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 2),
                                currentDate: DateTime.now());
                            setState(() {});
                          }),

                      // description de l'évènement
                      customMultilineField(
                          label: "Description de l'évènement",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Remplissez d'abords le champs !";
                            }
                            if (value.length < 30) {
                              return "Donnez une description un peu plus détaillée";
                            }
                            return null;
                          })
                    ],
                  )),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: customButton(
                    context: context,
                    text: "Soumettre",
                    trailing: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (image == null) {
                          return showSnackBar(
                              context: context,
                              message: "Choisissez d'abord une affiche !",
                              type: SnackBarType.warning);
                        }

                        if (_eventDate == null) {
                          return showSnackBar(
                              context: context,
                              message:
                                  "Vous n'avez pas sélectionné de date pour votre évènement !",
                              type: SnackBarType.warning);
                        }

                        //TODO: Implémenter la logique d'enregistrement d'évènement
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
