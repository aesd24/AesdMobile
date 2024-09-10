/* import 'dart:io';
import 'package:aesd_app/components/bottom_sheets.dart'; */
import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/screens/user/dashbord/wallet.dart';
//import 'package:aesd_app/screens/auth/register/register.dart';
/* import 'package:aesd_app/screens/posts/create_post.dart';
import 'package:aesd_app/screens/posts/video_post_preview.dart';
import 'package:aesd_app/screens/users/common/followers.dart'; */
//import 'package:aesd_app/screens/posts/video_post_preview.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

class PersonnalDashbord extends StatefulWidget {
  const PersonnalDashbord({super.key});

  @override
  State<PersonnalDashbord> createState() => _PersonnalDashbordState();
}

class _PersonnalDashbordState extends State<PersonnalDashbord> {

  @override
  Widget build(BuildContext context) {

    showIndisponible(){
      showSnackBar(
        context: context,
        message: "Cette section est momentanément indisponible !",
        bgColor: Colors.blue,
        icon: Icons.info
      );
    }

    changeForm(Widget form){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => form)
      );
    }

    // liste des boutons sur l'interface
    List<Map<String, dynamic>> buttonsInformations = [
      /* {
        'text': "Modifier mes informations personnelles",
        'icon': const Icon(Icons.edit_note),
        'function':() => changeForm(RegisterPage(
          accountType: "SVT", //Provider.of<User>(context).accountType,
          update: true,
        ))
      }, */
      {
        'text': "Faire un post",
        'icon': const Icon(Icons.post_add),
        'function': () => /* changeForm(const CreatePostForm()) */ showIndisponible()
      },
      /* {
        'text': "Poster une vidéo d'édification",
        'icon': const Icon(Icons.movie),
        'function': () {
          setVideo(dynamic _video) async{
            File? video = await _video;
            if (video != null){
              changeForm(VideoPostPreview(video: video));
            }
          }
          pickModeSelectionBottomSheet(
            context: context,
            setter: setVideo,
            photo: false
          );
        }
      }, */
      {
        'text': "Mes fidèles",
        'icon': const Icon(Icons.group),
        'function': () => /* changeForm(FollowersPage(community: false)) */ showIndisponible()
      },
      {
        'text': "Dîmes et dons reçus",
        'icon': const Icon(Icons.payments_rounded),
        'function': () => changeForm(const WalletForm())
      }
    ];

    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border(bottom: BorderSide(color: Colors.green.shade900, width: 3))
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Image.asset(
                      "assets/images/default_user.png",
                      height: 150,
                      width: 150,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _customColumn(
                        value: '0',
                        label: "Fidèle.s"
                      ),
                      
                      _customColumn(
                        value: '0',
                        label: "Abonnement.s"
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: List.generate(buttonsInformations.length, (index){
                Map<String, dynamic> currentButton = buttonsInformations[index];
            
                return customDashbordButton(
                  context: context,
                  text: currentButton['text'],
                  icon: currentButton['icon'],
                  function: currentButton['function']
                );
              })
            ),
          ],
        ),
      ),
    );
  }

  Widget _customColumn({
    required String label,
    required String value
  }){
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge
        )
      ],
    );
  }
}