import 'package:aesd_app/components/text_field.dart';
import 'package:aesd_app/models/social_help.dart';
import 'package:flutter/material.dart';

class SocialDemandes extends StatefulWidget {
  const SocialDemandes({super.key});

  @override
  State<SocialDemandes> createState() => _SocialDemandesState();
}

class _SocialDemandesState extends State<SocialDemandes> {
  final List<SocialHelpModel> _socialProblems = List.generate(
      4,
      (index) => SocialHelpModel.fromJson({
            'id': index,
            'title': "Intitulé du problème $index",
            'description': "Description du problème $index",
            'date': "200$index-0${index + 1}-0${index + 1}",
            'applicant': {
              'id': index,
              'name': "Demandeur $index",
            }
          }));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextField(
                label: "Rechercher", prefixIcon: const Icon(Icons.search)),
            const SizedBox(height: 20),
            Column(
              children: List.generate(_socialProblems.length, (index) {
                var current = _socialProblems[index];
                return current.getWidget(context);
              }),
            )
          ],
        ),
      ),
    );
  }
}
