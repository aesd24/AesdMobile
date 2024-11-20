import 'dart:io';
import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/picture_containers.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/camera_functions.dart';
import 'package:aesd_app/functions/file_functions.dart';
import 'package:aesd_app/providers/user.dart';
import 'package:aesd_app/screens/new_version/auth/register/finish.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({super.key});

  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {
  File? idPicture;
  File? idCardRecto;
  File? idCardVerso;

  // fonction pour charger l'image
  Future<void> _pickImage(int index) async {
    File? picture = await pickImage();
    setState(() {
      if (index == 0) {
        idPicture = picture;
      } else if (index == 1) {
        idCardRecto = picture;
      } else {
        idCardVerso = picture;
      }
    });
  }

  // terminer le processus l'enregistrement
  _finish() async {
    String message = "";

    if (idPicture == null || idCardRecto == null || idCardVerso == null) {
      showSnackBar(
          context: context,
          message: "Veuillez charger toutes les images necessaires",
          type: SnackBarType.warning);
      return;
    }

    // vérification de la taille des fichiers
    var pictures = [idPicture, idCardRecto, idCardVerso];
    for (var picture in pictures) {
      var verifier = await verifyImageSize(picture!);
      if (verifier['result'] == false) {
        if (pictures.indexOf(picture) == 0) {
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

    Provider.of<User>(context, listen: false).setRegisterData({
      'idPicture': pictures[0],
      'id_card_recto': pictures[1],
      'id_card_verso': pictures[2]
    });

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const FinishPage()));
  }

  @override
  Widget build(BuildContext context) {
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
                  height: size.height * 0.76,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ajouter une photo de la carte d'identité
                          Text(
                            "Photo d'identité",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),

                          const Divider(
                            color: Colors.green,
                            height: 4,
                            thickness: 2,
                            endIndent: 100,
                          ),

                          // photo d'identité
                          Center(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: GestureDetector(
                                  onTap: () => _pickImage(0),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.green.shade200,
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.grey, blurRadius: 3)
                                        ]),
                                    child: CircleAvatar(
                                      radius: 70,
                                      backgroundColor: Colors.white,
                                      backgroundImage: idPicture == null
                                          ? null
                                          : FileImage(idPicture!),
                                      child: idPicture == null
                                          ? const Text(
                                              "Ajouter votre photo d'identité",
                                              textAlign: TextAlign.center,
                                            )
                                          : null,
                                    ),
                                  ),
                                )),
                          ),

                          const SizedBox(height: 20),

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
                              picture: idCardRecto,
                              onClick: () => _pickImage(1),
                              label: "Le recto de votre carte d'identité svp !",
                              icon: Icons.recent_actors_rounded,
                              height: size.height * .2,
                              overlayText:
                                  "Cliquez pour charger une autre image"),

                          // verso
                          imageSelectionBox(
                              context: context,
                              picture: idCardVerso,
                              onClick: () => _pickImage(2),
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
