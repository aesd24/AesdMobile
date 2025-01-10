import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/models/testimony.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TestimoniesList extends StatefulWidget {
  const TestimoniesList({super.key});

  @override
  State<TestimoniesList> createState() => _TestimoniesListState();
}

class _TestimoniesListState extends State<TestimoniesList> {
  final List<TestimonyModel> _testimonies = List.generate(5, (index) {
    return TestimonyModel.fromJson({
      'id': index,
      'title': "Titre du témoignage $index",
      'body': "Corps du témoignage $index",
      'isAnonymous': false,
      'user': null
    });
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Témoignages"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: customTextField(
                    prefixIcon: const Icon(Icons.search),
                    label: "Rechercher",
                    suffix: PopupMenuButton(
                        icon: const FaIcon(FontAwesomeIcons.sort),
                        itemBuilder: (context) => const [
                              PopupMenuItem(
                                  value: "date", child: Text("Trier par date")),
                              PopupMenuItem(
                                  value: "name", child: Text("Trier par nom")),
                            ])),
              ),

              // liste des témoignages
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(_testimonies.length, (index) {
                      var current = _testimonies[index];
                      return current.getWidget(context);
                    }),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
