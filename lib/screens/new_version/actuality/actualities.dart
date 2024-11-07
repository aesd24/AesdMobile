import 'package:aesd_app/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AllActualities extends StatefulWidget {
  const AllActualities({super.key});

  @override
  State<AllActualities> createState() => _AllActualitiesState();
}

class _AllActualitiesState extends State<AllActualities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                customTextField(
                    prefixIcon: const Icon(Icons.search),
                    label: "Recherche",
                    placeholder: "Rechercher un article",
                    suffix: PopupMenuButton(
                        icon: const FaIcon(FontAwesomeIcons.sort,
                            color: Colors.grey, size: 20),
                        itemBuilder: (context) {
                          return const [
                            PopupMenuItem(
                                value: "date", child: Text("Trier par date")),
                            PopupMenuItem(
                                value: "title", child: Text("Trier par titre")),
                          ];
                        })),

                // liste des articles
                SizedBox(
                  height: MediaQuery.of(context).size.height * .75,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                          10,
                          (index) => customNewsBox(
                              title: "Titre de l'article",
                              description: "Description de l'article")),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget customNewsBox({
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
              image: AssetImage("assets/news.jpeg"), fit: BoxFit.cover)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              Colors.black.withOpacity(0.5),
              Colors.black.withOpacity(0.2),
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
        alignment: Alignment.bottomLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              description,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Colors.white60),
            )
          ],
        ),
      ),
    );
  }
}
