import 'dart:io';
import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/picture_containers.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/camera_functions.dart';
import 'package:aesd_app/functions/file_functions.dart';
import 'package:aesd_app/providers/user.dart';
import 'package:aesd_app/screens/auth/register/finish.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({super.key});

  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {
  List<File?> pictures = [null, null];

  // fonction pour charger l'image
  Future<void> _pickImage(int index) async {
    File? picture = await pickImage();
    setState(() {
      pictures[index] = picture;
    });
  }

  // terminer le processus l'enregistrement
  _finish() async {
    String message = "";

    for (var element in pictures) {
      // vérification de l'existance des fichiers
      if (element == null) {
        if (pictures.indexOf(element) == 0) {
          message = "Ajoutez le recto de votre pièce d'identité !";
        } else if (pictures.indexOf(element) == 1) {
          message = "Ajoutez le verso de votre pièce d'identité !";
        }
        showSnackBar(
            context: context, message: message, type: SnackBarType.warning);
        return;
      }

      // vérification de la taille des fichiers
      var verifier = await verifyImageSize(element);
      if (verifier['result'] == false) {
        if (pictures.indexOf(element) == 0) {
          message = "La taille du recto de la pièce ne doit pas excéder 20Mo";
        } else {
          message = "La taille du verso de la pièce ne doit pas excéder 20Mo";
        }
        showSnackBar(
            context: context,
            message: "$message: ${verifier['length']} Mo",
            type: SnackBarType.warning);
        return;
      }
    }

    Provider.of<User>(context, listen: false).setRegisterData(
        {'id_card_recto': pictures[0]!, 'id_card_verso': pictures[1]!});

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const FinishPage()));
  }

  @override
  Widget build(BuildContext context) {
    // obtenir les images depuis la variable globale
    Provider.of<User>(context).registerData.forEach((key, value) {
      if (value is File) {
        pictures.add(value);
      }
    });

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter des photos'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.75,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ajouter une photo de la carte d'identité
                          Text(
                            "Pièce d'identité",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),

                          const Divider(
                            color: Colors.green,
                            height: 4,
                            thickness: 2,
                            endIndent: 100,
                          ),

                          // recto
                          imageSelectionBox(
                              context: context,
                              picture: pictures[0],
                              onClick: () => _pickImage(0),
                              label: "Le recto de votre carte d'identité svp !",
                              icon: Icons.recent_actors_rounded,
                              height: size.height * .2,
                              overlayText:
                                  "Cliquez pour charger une autre image"),

                          // verso
                          imageSelectionBox(
                              context: context,
                              picture: pictures[1],
                              onClick: () => _pickImage(1),
                              label: "Le verso de votre carte d'identité svp !",
                              icon: Icons.vertical_split_rounded,
                              height: size.height * .2,
                              overlayText:
                                  "Cliquez pour charger une autre image")
                        ]),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: customButton(
                        context: context,
                        text: "Suivant",
                        trailing: const Icon(Icons.arrow_forward,
                            color: Colors.white),
                        onPressed: () => _finish()),
                  ),
                )
              ])),
    );
  }
}
