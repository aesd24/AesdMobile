import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    var buttons = [
      {
        'label': "Mes informations personnels",
        'icon': FontAwesomeIcons.solidUser,
        'function': (){}
      },
      {
        'label': "Modifier mon mot de passe",
        'icon': FontAwesomeIcons.lock,
        'function': (){}
      },
      {
        'label': "Information sur mon église",
        'icon': FontAwesomeIcons.church,
        'function': (){}
      },
      {
        'label': "Faire un post",
        'icon': FontAwesomeIcons.signsPost,
        'function': (){}
      }
    ];
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "Plus d'options",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),

            Column(
              children: List.generate(buttons.length, (index){
                Map<String, dynamic> current = buttons[index];
                return customMoreButton(
                  context,
                  text: current['label'],
                  icon: current['icon'],
                  onPressed: current['function']
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget customMoreButton(BuildContext context, {
    required String text,
    IconData? icon,
    required Function()? onPressed,
  }){
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(5)
        ),
        alignment: Alignment.center,
        child: icon == null ? Text(text) : Row(
          children: [
            Icon(icon, color: Colors.black, size: 22),
            const SizedBox(width: 30),
            Text(
              text,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}