import 'dart:io';

import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/functions/camera_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateCeremony extends StatefulWidget {
  const CreateCeremony({super.key});

  @override
  State<CreateCeremony> createState() => _CreateCeremonyState();
}

class _CreateCeremonyState extends State<CreateCeremony> {
  File? movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Création de cérémonie"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          child: Column(
            children: [
              customTextField(
                prefixIcon: Icon(
                  FontAwesomeIcons.church,
                  size: 20,
                  color: Colors.grey
                ),
                label: "Titre",
                placeholder: "Titre de la cérémonie"
              ),
              
              customDateField(
                label: "Date de la cérémonie",
              ),

              customMultilineField(
                label: "Descrivez la cérémonie..."
              ),

              InkWell(
                onTap: () async {
                  movie = await pickVideo();
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.movie_creation, size: 80),
                      SizedBox(height: 10),
                      Text("Chargez le film de la cérémonie")
                    ],
                  )
                ),
              ),

              SizedBox(height: 10),

              customButton(
                context: context,
                text: "Valider",
                onPressed: (){}
              )
            ],
          )
        ),
      ),
    );
  }
}