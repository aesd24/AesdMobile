import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialhelpPage extends StatefulWidget {
  const SocialhelpPage({super.key});

  @override
  State<SocialhelpPage> createState() => _SocialhelpPageState();
}

class _SocialhelpPageState extends State<SocialhelpPage> {

  final List _socialProblems = List.generate(4, (index){
    return {
      "applicant": "Nom_du_demandeur",
      "Title" : "Intitulé_du_problème $index",
      "description": "Description du probleme",
      "date": "2022-01-01",
    };
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Demandes d'aides",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold
                )
              ),
            ),

            TextFormField(
              decoration: InputDecoration(
                labelText: "Recherchez...",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search, color: Colors.grey,),
                suffixIcon: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.sort, color: Colors.grey),
                  onPressed: (){},
                )
              ),
            ),

            const SizedBox(height: 20),
          
            Column(
              children: List.generate(_socialProblems.length, (index){
                return socialProblemWidget(
                  applicant: _socialProblems[index]["applicant"],
                  title: _socialProblems[index]["Title"],
                  description: _socialProblems[index]["description"],
                  date: _socialProblems[index]["date"],
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget socialProblemWidget({
    required String applicant,
    required String title,
    required String description,
    required String date,
  }){
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(applicant, style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Colors.grey
              )),

              Text(date, style: Theme.of(context).textTheme.bodySmall,)
            ]
          ),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium,),
          ),

          Text(description, style: Theme.of(context).textTheme.bodyMedium,)
        ],
      )
    );
  }
}