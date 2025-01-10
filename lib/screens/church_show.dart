import 'package:aesd_app/models/church_model.dart';
import 'package:aesd_app/widgets/servant_card.dart';
import 'package:flutter/material.dart';

class ChurchShow extends StatefulWidget {
  final ChurchModel church;

  const ChurchShow({super.key, required this.church});

  @override
  _ChurchShowState createState() => _ChurchShowState();
}

class _ChurchShowState extends State<ChurchShow> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.church.name),
      ),
      body: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              height: size.height * 0.38,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.church.cover!),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: size.height * 0.38),
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(
                          text: "Détails",
                        ),
                        Tab(
                          text: "Serviteurs",
                        ),
                        Tab(
                          text: "Programme",
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        color: Colors.grey.shade300,
                        child: TabBarView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView(
                                children: [
                                  Text(widget.church.description),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Divider(
                                    indent: 10.0,
                                    endIndent: 20.0,
                                    thickness: 1,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Serviteur Principal: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      Text(
                                        widget.church.mainServant != null
                                            ? widget
                                                .church.mainServant!.user.name
                                            : '---',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  /*Row(
                                    children: [
                                      Text(
                                        'Email: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      Text(widget.church.email),
                                    ],
                                  ),*/
                                  Row(
                                    children: [
                                      const Text(
                                        'Téléphone: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      Text(widget.church.phone),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Situation géograpgique: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(widget.church.address)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                            widget.church.servants.isNotEmpty
                                ? ListView(
                                    children: [
                                      for (final servant
                                          in widget.church.servants)
                                        ServantCard(servant: servant)
                                    ],
                                  )
                                : const Center(
                                    child: Text(
                                        "Pas de serviteurs dans cette église."),
                                  ),
                            widget.church.programm != null
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ListView(
                                      children: const [
                                        /* getDayWidget("Lundi",
                                            widget.church.programm!.monday),
                                        getDayWidget("Mardi",
                                            widget.church.programm!.tuesday),
                                        getDayWidget("Mercredi",
                                            widget.church.programm!.wednesday),
                                        getDayWidget("Jeudi",
                                            widget.church.programm!.thursday),
                                        getDayWidget("Vendredi",
                                            widget.church.programm!.friday),
                                        getDayWidget("Samedi",
                                            widget.church.programm!.saturday),
                                        getDayWidget("Dimanche",
                                            widget.church.programm!.sunday), */
                                      ],
                                    ),
                                  )
                                : const Center(
                                    child: Text("Aucun programme disponible."),
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDayWidget(String day, String? value) {
    if (value != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$day: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
          Text(value),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    }

    return Container();
  }
}
