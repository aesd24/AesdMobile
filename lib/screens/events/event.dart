import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Partie de l'image
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .4,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/event.jpg"), fit: BoxFit.cover),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15))),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.black.withOpacity(.7),
                  Colors.black.withOpacity(.1)
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: TextButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.asset("assets/event.jpg",
                              fit: BoxFit.contain),
                        ),
                      );
                    },
                  ),
                  icon: const FaIcon(
                    FontAwesomeIcons.expand,
                    size: 20,
                  ),
                  iconAlignment: IconAlignment.end,
                  label: Text(
                    "Agrandir",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.transparent),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      overlayColor:
                          WidgetStateProperty.all(Colors.grey.withOpacity(.2))),
                ),
              ),
            ),
          ),

          // Partie du contenu de la page de l'
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Titre de l'évènement",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "jj/mm/AAAA",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.grey),
                      ),
                      Text(
                        "Lieu",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const Text("Description de l'évènement")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
