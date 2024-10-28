import 'package:aesd_app/screens/new_version/church/ceremonies.dart';
import 'package:aesd_app/screens/new_version/church/community.dart';
import 'package:aesd_app/screens/new_version/church/program.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChurchMainPage extends StatefulWidget {
  const ChurchMainPage({super.key});

  @override
  State<ChurchMainPage> createState() => _ChurchMainPageState();
}

class _ChurchMainPageState extends State<ChurchMainPage> {
  int _pageIndex = 0;
  setPageIndex(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon église"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset(
              "assets/icons/church.png",
              height: 30,
              width: 30,
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        unselectedItemColor: Colors.black45,
        elevation: 0,
        currentIndex: _pageIndex,
        onTap: (value) => setPageIndex(value),
        items: const [
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.calendar), label: "Programme"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.church), label: "Cérémonies"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.userGroup), label: "Communauté"),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image de présentation de l'église
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                        image: AssetImage(
                          "assets/welcome.jpg",
                        ),
                        fit: BoxFit.cover)),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(.1),
                            Colors.black.withOpacity(.6)
                          ])),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          child: Text(
                        "Nom de l'église",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                      )),
                      const SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Text(
                            "Serviteur principale",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: Colors.white),
                            overflow: TextOverflow.clip,
                          )),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.location_pin,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                "Position",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Colors.white),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // Partie modifié selon la barre de navigation
              [
                const ChurchProgram(),
                const CeremoniesPage(),
                const ChurchCommunity()
              ][_pageIndex]
            ],
          ),
        ),
      ),
    );
  }
}
