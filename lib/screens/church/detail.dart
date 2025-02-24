import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/models/church_model.dart';
import 'package:aesd_app/models/day_program.dart';
import 'package:aesd_app/models/event.dart';
import 'package:aesd_app/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class ChurchDetailPage extends StatefulWidget {
  ChurchDetailPage({super.key, required this.church});

  ChurchModel church;

  @override
  State<ChurchDetailPage> createState() => _ChurchDetailPageState();
}

class _ChurchDetailPageState extends State<ChurchDetailPage> {
  bool _isLoading = false;
  int _pageIndex = 0;
  setPageIndex(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  final _pageController = PageController(initialPage: 0);

  handleSubscribtion() async {
    /* try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Church>(context, listen: false).subscribe(
        widget.church.id,
      );
    } on HttpException {
      showSnackBar(context: context, message: "L'abonnement a échoué !");
    } finally {
      setState(() {
        _isLoading = false;
      });
    } */
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context).user;
    bool subscribed = widget.church.id == user.church?.id;

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                      image: DecorationImage(
                          image: NetworkImage(widget.church.image),
                          fit: BoxFit.cover)),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withAlpha(25),
                              Colors.black.withAlpha(160)
                            ])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                            backgroundImage: widget.church.logo != null
                                ? NetworkImage(widget.church.logo!)
                                : const AssetImage("assets/images/bg-5.jpg"),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                child: Text(
                              widget.church.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                              overflow: TextOverflow.clip,
                            )),
                            const SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: Text(
                                  widget.church.mainServant != null
                                      ? widget.church.mainServant!.name
                                      : "Inconnu",
                                  style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(color: Colors.white.withAlpha(170)),
                                  overflow: TextOverflow.clip,
                                )),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.location_pin,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      widget.church.address,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: Colors.white),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
      
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextButton.icon(
                      onPressed: () => handleSubscribtion(),
                      icon: FaIcon(
                        subscribed ? FontAwesomeIcons.bookmark :
                        FontAwesomeIcons.solidBookmark
                      ),
                      iconAlignment: IconAlignment.end,
                      label: Text(subscribed ? "Se désabonner" : "S'abonner"),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          subscribed ? Colors.transparent : Colors.blue
                        ),
                        overlayColor: WidgetStateProperty.all(
                          subscribed ? Colors.red.withAlpha(110)
                          : Colors.white.withAlpha(110)
                        ),
                        iconColor: WidgetStateProperty.all(
                          subscribed ? Colors.red : Colors.white
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          subscribed ? Colors.red : Colors.white
                        ),
                        shape: subscribed ? WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            side: const BorderSide(width: 2, color: Colors.red),
                            borderRadius: BorderRadius.circular(100)
                          )
                        ) : null
                      ),
                    ),
                  ),
                ),
      
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 30),
                  child: Text(widget.church.description),
                ),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customNavitem(context,
                      currentIndex: _pageIndex, index: 0, label: "Programme"),
                    customNavitem(context,
                      currentIndex: _pageIndex, index: 1, label: "Céremonies"),
                    customNavitem(context,
                      currentIndex: _pageIndex, index: 2, label: "Communauté"),
                  ],
                ),
      
                SizedBox(height: 20),
      
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .6,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (value) => setPageIndex(value),
                      children: [
                        Placeholder(),
                        Ceremonies(),
                        Community()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell customNavitem(BuildContext context,
      {required int index, required String label, required int currentIndex}) {
    return InkWell(
        onTap: () {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
        child: AnimatedContainer(
          padding: const EdgeInsets.all(7),
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              border: index == currentIndex
                  ? const Border(
                      bottom: BorderSide(width: 5, color: Colors.green))
                  : null),
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: index == currentIndex ? Colors.green : null),
          ),
        ));
  }
}

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
              "Serviteurs de l'église",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: List.generate(5, (index) {
              return Card(
                child: ListTile(
                  title: const Text("Nom du serviteur"),
                  subtitle: const Text("serviteur@email.com"),
                  trailing: index == 0
                      ? Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.green, width: 1.5),
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text(
                            "Principale",
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      : null,
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

class Ceremonies extends StatefulWidget {
  const Ceremonies({super.key});

  @override
  State<Ceremonies> createState() => _CeremoniesState();
}

class _CeremoniesState extends State<Ceremonies> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          customTextField(
              label: "Rechercher", prefixIcon: const Icon(Icons.search)),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              label: const Text("Voir plus"),
              icon: const Icon(Icons.add),
              iconAlignment: IconAlignment.end,
            ),
          ),
          Column(
            children: List.generate(4, (index) {
              return Card(
                color: Colors.green.shade50,
                child: ListTile(
                  leading: const CircleAvatar(
                    child: FaIcon(
                      FontAwesomeIcons.film,
                      color: Colors.green,
                    ),
                  ),
                  title: Text("Titre de la cérémonie $index"),
                  subtitle: Text("0${index + 1}/0${index + 1}/20${index + 1}0"),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

class Program extends StatefulWidget {
  const Program({super.key});

  @override
  State<Program> createState() => _ProgramState();
}

class _ProgramState extends State<Program> {
  var currentProgram = DayProgramModel.fromJson({
    'day': "Lundi",
    'program': List.generate(3, (index) {
      return {
        'title': "Programme $index",
        'startTime': "${index + 10}:00:00",
        'endTime': "${index + 11}:00:00",
        'place': "Lien $index"
      };
    })
  });

  var lastEvent = EventModel.fromJson(
      {'id': 0, 'title': "Intitulé de l'évènement 1", 'date': DateTime.now()});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Programme du jour",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.keyboard_arrow_right),
                  iconAlignment: IconAlignment.end,
                  label: const Text("Tout voir"))
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: lastEvent.getWidget(context)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: currentProgram.getWidget(context),
          )
        ],
      ),
    );
  }
}
