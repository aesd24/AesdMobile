import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/screens/new_version/church/creation/annexe.dart';
import 'package:aesd_app/screens/new_version/church/creation/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateChurchPage extends StatefulWidget {
  const CreateChurchPage({super.key});

  @override
  State<CreateChurchPage> createState() => _CreateChurchPageState();
}

class _CreateChurchPageState extends State<CreateChurchPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choisir le type d'église"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            customSelectionBox(
                icon: FontAwesomeIcons.chessKing,
                text: "Eglise principale",
                destination: MainChurchCreationPage()),
            customSelectionBox(
                icon: FontAwesomeIcons.medal,
                text: "Eglise annexe",
                destination: const AnnexeChurchCreationPage())
          ],
        ),
      ),
    );
  }

  GestureDetector customSelectionBox(
      {required IconData icon,
      required String text,
      required Widget destination}) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => pushForm(context, destination: destination),
      child: Container(
        padding: const EdgeInsets.all(30),
        width: size.width * .4,
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 20),
            Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
