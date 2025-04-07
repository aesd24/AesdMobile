import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/testimony.dart';
import 'package:aesd_app/screens/testimony/form.dart';
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
      'is_anonymous': 1,
      'media': '',
      'mediaType': index % 2 == 0 ? 'video' : 'audio',
      'user': null
    });
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Les témoignages"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => pushForm(context, destination: TestimonyForm()),
                  label: Text('Ajouter'),
                  icon: FaIcon(FontAwesomeIcons.plus),
                  iconAlignment: IconAlignment.end
                )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: customTextField(
                        prefixIcon: const Icon(Icons.search),
                        label: "Rechercher",
                      ),
                    ),
                  ],
                ),
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
