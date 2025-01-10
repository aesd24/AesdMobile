import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/drop_down.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/components/field.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class CreateProgramForm extends StatefulWidget {
  const CreateProgramForm({super.key});

  @override
  State<CreateProgramForm> createState() => _CreateProgramFormState();
}

class _CreateProgramFormState extends State<CreateProgramForm> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final _titleController = TextEditingController();
  final _placeController = TextEditingController();

  // variables
  dynamic day;
  List weekDays = [
    "lundi",
    "mardi",
    "mercredi",
    "jeudi",
    "vendredi",
    "samedi",
    "dimanche"
  ];

  DateTime? programDate;
  DateTime? startTime;
  DateTime? endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un programme"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                customDropDownField(
                    label: "Choisissez le jour du programme",
                    items: List.generate(weekDays.length, (index) {
                      return DropdownMenuItem(
                          value: index + 1, child: Text(weekDays[index]));
                    }),
                    value: day,
                    onChange: (value) {
                      day = value;
                    }),
                customTextField(
                    label: "Titre du programme",
                    controller: _titleController,
                    suffix: const Icon(Icons.title),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Renseignez le titre du programme";
                      }
                      if (value.length < 5) {
                        return "Le titre doit contenir au moins 5 caractères";
                      }
                      return null;
                    }),
                customTextField(
                  label: "Lieu de déroulement",
                  controller: _placeController,
                  suffix: const Icon(Icons.location_pin),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Renseignez le titre du programme";
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: customDateField(
                          label: "Heure de debut",
                          value: startTime,
                          mode: DateTimeFieldPickerMode.time,
                          onChanged: (value){
                            setState(() {
                              startTime = value;
                            });
                          }
                        )
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: customDateField(
                          label: "Heure de fin",
                          value: endTime,
                          mode: DateTimeFieldPickerMode.time,
                          onChanged: (value){
                            setState(() {
                              endTime = value;
                            });
                          }
                        )
                      ),
                    ]
                  ),
                ),
                const SizedBox(height: 10),
                customButton(
                    context: context,
                    text: "Valider",
                    onPressed: () {
                      if (day == null) {
                        showSnackBar(
                            context: context,
                            message: "Choisissez le jour du programme",
                            type: SnackBarType.warning);
                        return;
                      }

                      if (startTime == null) {
                        showSnackBar(
                            context: context,
                            message: "Renseignez l'heure de début du programme",
                            type: SnackBarType.warning);
                        return;
                      }

                      if (endTime == null) {
                        showSnackBar(
                            context: context,
                            message: "Renseignez l'heure de début du programme",
                            type: SnackBarType.warning);
                        return;
                      }

                      if (_formKey.currentState!.validate()) {
                        //print("Création du programme");
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
