import 'package:flutter/material.dart';

class SocialHelpPage extends StatefulWidget {
  const SocialHelpPage({super.key});

  @override
  State<SocialHelpPage> createState() => _SocialHelpPageState();
}

class _SocialHelpPageState extends State<SocialHelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Intitulé de la demande",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "01-01-2024",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 40),

            // zone du demandeur
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const CircleAvatar(radius: 50),
                  Text(
                    "Nom du demandeur",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "email@exemple.com",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                  ),
                  Text(
                    "01-0203-0405",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // zone du contenu de la demande
            const Text("Contenu de la demande")
          ],
        ),
      ),
    );
  }
}
