import 'package:aesd_app/screens/new_version/notifications/demandes.dart';
import 'package:aesd_app/screens/new_version/notifications/informations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int currentPage = 0;

  // controller de page
  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Notifications"),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              icon: const FaIcon(FontAwesomeIcons.sort),
              itemBuilder: (context) {
                return [];
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.bounceInOut);
                        setState(() {});
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceInOut,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: currentPage == 1 ? Colors.green : null,
                            border: Border.all(color: Colors.green, width: 2),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "Demandes",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: currentPage == 1
                                      ? Colors.white
                                      : Colors.green),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.bounceInOut);
                        setState(() {});
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceInOut,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: currentPage == 0 ? Colors.green : null,
                            border: Border.all(color: Colors.green, width: 2),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "Informations",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: currentPage == 0
                                      ? Colors.white
                                      : Colors.green),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // partie de l'affichage des notifications
              Container(
                height: MediaQuery.of(context).size.height * .75,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  children: const [Demandes(), Informations()],
                ),
              )
            ],
          ),
        ));
  }
}
