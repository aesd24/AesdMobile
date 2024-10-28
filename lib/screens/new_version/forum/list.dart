import 'package:aesd_app/components/text_field.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/screens/new_version/forum/subject.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForumMain extends StatefulWidget {
  const ForumMain({super.key});

  @override
  State<ForumMain> createState() => _ForumMainState();
}

class _ForumMainState extends State<ForumMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset(
              "assets/icons/forum.png",
              height: 30,
              width: 30,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTextField(
                  label: "Recherche",
                  prefixIcon: const Icon(Icons.search),
                  suffix: PopupMenuButton(
                      icon: const FaIcon(FontAwesomeIcons.sort,
                          color: Colors.grey),
                      itemBuilder: (context) {
                        return const [
                          PopupMenuItem(value: "", child: Text("Plus récent")),
                          PopupMenuItem(value: "", child: Text("Plus ancient"))
                        ];
                      })),
              Align(
                alignment: Alignment.center,
                child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: List.generate(9, (index) {
                      return forumDiscutionBox(context,
                          title: "Titre de la discution $index",
                          responseNumber: index + 5,
                          onClick: () => pushForm(context,
                              destination: const DiscutionSubjectPage()));
                    })),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget forumDiscutionBox(BuildContext context,
      {required String title,
      required int responseNumber,
      required void Function()? onClick}) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: (size.width * .5) - 20,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  responseNumber.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 3),
                const FaIcon(
                  FontAwesomeIcons.message,
                  size: 17,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
