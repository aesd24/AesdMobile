import 'dart:io';
import 'package:aesd_app/components/bottom_sheets.dart';
import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/church_selection.dart';
import 'package:aesd_app/components/dialog.dart';
import 'package:aesd_app/components/snack_bar.dart';
//import 'package:aesd_app/providers/auth.dart';
import 'package:aesd_app/providers/church.dart';
import 'package:aesd_app/providers/servant.dart';
import 'package:aesd_app/providers/user.dart';
import 'package:aesd_app/screens/new_version/church/choose_church.dart';
import 'package:aesd_app/screens/new_version/church/create_church.dart';
//import 'package:aesd_app/screens/events/create_event.dart';
import 'package:aesd_app/screens/new_version/posts/video_post_preview.dart';
import 'package:aesd_app/screens/new_version/wallet/wallet.dart';
/* import 'package:aesd_app/screens/quiz/create_quiz.dart';
import 'package:aesd_app/screens/users/common/followers.dart'; */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChurchDashbord extends StatefulWidget {
  const ChurchDashbord({super.key});

  @override
  State<ChurchDashbord> createState() => _ChurchDashbordState();
}

class _ChurchDashbordState extends State<ChurchDashbord> {

  changeForm(Widget form){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => form)
    );
  }

  int? churchId;

  // obtenir l'église
  getChurch() async {
    try {
      churchId = Provider.of<Servant>(context, listen: false).servant.churchId;
      if (churchId != null){
        var response = await Provider.of<Church>(context, listen: false).one();
        if (response.statusCode == 200){
          setState(() {
            church = response.data["church"];
            owner = response.data['owner'];
          });
        } else {
          messageBox(
            context,
            title: "Oups !",
            isDismissable: false,
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Nous n'avons pas pu obtenir les informations de l'église."),
                Text("Il semble que votre église n'existe pas !")
              ]
            ),
            actions: [
              TextButton(
                onPressed: (){
                  try{
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ChooseChurch())
                    );
                  } catch (e){
                    e.printError();
                  }
                },
                child: const Text("Choisir une autre"),
              ),
            ]
          );
        }
      }
    } catch (e){
      e.printError();
    }
  }

  dynamic church;
  dynamic owner;

  @override
  void initState() {
    super.initState();
    getChurch();
  }

  @override
  Widget build(BuildContext context) {
    showIndisponible(){
      showSnackBar(
        context: context,
        message: "Cette section est momentanément indisponible !",
        type: SnackBarType.info
      );
    }

    // liste des boutons a afficher sur la page
    List<Map<String, dynamic>> buttonsInformations = church == null ? [] : [
      {
        'text': "Modifier mon église",
        'icon': const Icon(Icons.edit_note),
        'function': (){
          try {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  if (owner['id'] == Provider.of<User>(context, listen: false).user.id!){
                    return CreateChurchPage(editMode: true);
                  } else {
                    return const ChooseChurch();
                  }
                }
              )
            );
          } catch(e){
            e.printError();
          }
        }
      },
      {
        'text': "Ajouter un évènement",
        'icon': const Icon(Icons.event),
        'function': () => /* changeForm(const CreateEventPage()) */ showIndisponible()
      },
      {
        'text': "Partager une célébration en différé",
        'icon': const Icon(Icons.video_chat_rounded),
        'function': (){
          setVideo(dynamic file) async {
            File? video = await file;
            if (video != null){
              changeForm(VideoPostPreview(video: video));
            }
          }
          pickModeSelectionBottomSheet(
            context: context,
            setter: setVideo,
            photo: false,
            optionnalText: "La taille de la vidéo ne doit pas excéder 300Mo"
          );
        }
      },
      {
        'text': "Créer un quiz biblique",
        'icon': const Icon(Icons.quiz_rounded),
        'function': () => /* changeForm(const CreateQuizPage()) */ showIndisponible()
      },
      {
        'text': "Communauté",
        'icon': const Icon(Icons.group),
        'function': () => /* changeForm(FollowersPage(community: true)) */ showIndisponible()
      },
      {
        'text': "Offrandes reçus",
        'icon': const Icon(Icons.payments_rounded),
        'function': () => changeForm(const WalletForm())
      }
    ];

    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Mon église",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  churchId != null ? Builder(
                    builder: (context) {
                      if (church != null) {
                        return churchSelectionTile(
                          context: context,
                          id: churchId!,
                          name: church['name'] ?? "",
                          mainPastor: owner['name'],
                          zone: church['address'],
                          image_url: "${church['logo']}"
                        );
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height * .3,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          alignment: Alignment.center,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Patientez..."),
                              CircularProgressIndicator()
                            ],
                          ),
                        );
                      }
                    }
                  ) : Container(
                    height: MediaQuery.of(context).size.height * .3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.question_mark_rounded,
                          size: 40,
                          color: Colors.grey.shade600,
                        ),
                        Text(
                          "Vous n'avez pas encore d'église.",
                          style: Theme.of(context).textTheme.labelLarge,
                        )
                      ],
                    ),
                  ),
                ],
              )
            ),
            Column(
              children: churchId != null ? List.generate(buttonsInformations.length, (index){
                Map<String, dynamic> currentButton = buttonsInformations[index];
            
                return customDashbordButton(
                  context: context,
                  text: currentButton['text'],
                  icon: currentButton['icon'],
                  function: currentButton['function']
                );
              }) : [
                customButton(
                  context: context,
                  text: "Choisir une église",
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ChooseChurch())
                    );
                  }
                )
              ]
            ),
          ],
        ),
      ),
    );
  }
}