import 'dart:io';
import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/picture_containers.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/camera_functions.dart';
//import 'package:aesd_app/providers/auth.dart';
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

  List<File?> pictures = [null, null, null];

  // fonction pour charger l'image
  Future<void> _pickImage(int index) async {
    File? picture = await pickImage();
    setState(() {
      pictures[index] = picture;
    });
    }

  // terminer le processus l'enregistrement
  _finish() {
    String message = "";

    for (var element in pictures){
      if (element == null){
        if(pictures.indexOf(element) == 0) {
          message = "Veuillez ajouter une photo d'identité !";
        } else if(pictures.indexOf(element) == 1) {
          message = "Ajoutez le recto de votre pièce d'identité !";
        } else {
          message = "Ajoutez le verso de votre pièce d'identité !";
        }
        showSnackBar(context: context, message: message, type: "warning");
        return;
      }
    }

    Provider.of<User>(context, listen: false).setRegisterData({
      'id_picture': pictures[0]!,
      'id_card_recto': pictures[1]!,
      'id_card_verso': pictures[2]!
    });

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FinishPage())
    );
  }

  @override
  Widget build(BuildContext context) {

    // obtenir les images depuis la variable globale
    Provider.of<User>(context).registerData.forEach((key, value){
      if(value is File){
        pictures.add(value);
      }
    });

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter des photos'),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.75,
              child: ListView(
                children: [
                  // ajouter une photo d'identité
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
              
                  imageSelectionBox(
                    context: context,
                    picture: pictures[0],
                    onClick: () => _pickImage(0),
                    label: "Ajoutez une photo de vous !",
                    icon: Icons.add_a_photo_outlined,
                    overlayText: "Cliquez pour charger une autre image"
                  ),
              
                  const SizedBox(height: 40),
              
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
                    picture: pictures[1],
                    onClick: () => _pickImage(1),
                    label: "Le recto de votre carte d'identité svp !",
                    icon: Icons.recent_actors_rounded,
                    height: size.height * .2,
                    overlayText: "Cliquez pour charger une autre image"
                  ),

                  // verso
                  imageSelectionBox(
                    context: context,
                    picture: pictures[2],
                    onClick: () => _pickImage(2),
                    label: "Le verso de votre carte d'identité svp !",
                    icon: Icons.vertical_split_rounded,
                    height: size.height * .2,
                    overlayText: "Cliquez pour charger une autre image"
                  )
                ]
              ),
            ),
              
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom : 5),
                child: customButton(
                  context: context,
                  text: "Suivant",
                  trailing: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () => _finish()
                ),
              ),
            )
          ]
        )
      ),
    );
  }
}