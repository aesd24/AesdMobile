import 'package:aesd_app/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiscutionSubjectPage extends StatefulWidget {
  const DiscutionSubjectPage({super.key});

  @override
  State<DiscutionSubjectPage> createState() => _DiscutionSubjectPageState();
}

class _DiscutionSubjectPageState extends State<DiscutionSubjectPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                "Intitulé du débat",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.green.shade900, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                "jj/mm/AAAA",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black45, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(7),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(10)),
                  child: SingleChildScrollView(
                      child: Column(
                          children: List.generate(5, (index) {
                    return userPost(context,
                        name: "Participant $index", date: "jj/mm/AAAA");
                  }))),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: customTextField(
                            label: "Ecrivez votre reponse...",
                            suffix: IconButton(
                              onPressed: () {},
                              icon: const FaIcon(FontAwesomeIcons.paperPlane),
                              style: ButtonStyle(
                                  foregroundColor:
                                      WidgetStateProperty.all(Colors.green)),
                            )),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget userPost(BuildContext context,
      {required String name, required String date}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(),
                  const SizedBox(width: 10),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ),
              Text(date)
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Contenu du message"),
          )
        ],
      ),
    );
  }
}
