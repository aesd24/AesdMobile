import 'dart:io';
import 'package:aesd_app/components/dialog.dart';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/church_model.dart';
import 'package:aesd_app/models/day_program.dart';
import 'package:aesd_app/models/user_model.dart';
import 'package:aesd_app/providers/church.dart';
import 'package:aesd_app/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class ChurchDetailPage extends StatefulWidget {
  ChurchDetailPage({super.key, required this.churchId});

  int churchId;

  @override
  State<ChurchDetailPage> createState() => _ChurchDetailPageState();
}

class _ChurchDetailPageState extends State<ChurchDetailPage> {
  ChurchModel? church;
  UserModel? owner;
  bool _isLoading = false;
  int _pageIndex = 0;
  setPageIndex(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  final _pageController = PageController(initialPage: 0);

  onSubscribe(subscribed) async {
    if (subscribed) {
      messageBox(
        context,
        title: "Désabonnement",
        content: Text("Vous allez vous désabonner. Voulez-vous continuer ?"),
        actions: [
          TextButton(
            onPressed: () => closeForm(context),
            iconAlignment: IconAlignment.end,
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.grey),
            ),
            child: Text("Annuler"),
          ),
          TextButton.icon(
            onPressed: () {
              closeForm(context);
              handleSubscribtion(!subscribed);
            },
            icon: FaIcon(FontAwesomeIcons.xmark),
            iconAlignment: IconAlignment.end,
            label: Text("Me désabonner"),
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.red),
              iconColor: WidgetStatePropertyAll(Colors.red),
              overlayColor: WidgetStatePropertyAll(Colors.red.shade100),
            ),
          )
        ]
      );
      return;
    } else {
      if (Provider.of<User>(context, listen: false).user.churchId != null){
        messageBox(
          context,
          title: "Changer d'église",
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Vous serez désabonner à votre église actuelle."),
              Text("Voulez-vous vraiment continuer ?"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => closeForm(context),
              iconAlignment: IconAlignment.end,
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.grey),
              ),
              child: Text("Annuler"),
            ),
            TextButton.icon(
              onPressed: () {
                closeForm(context);
                handleSubscribtion(!subscribed);
              },
              icon: FaIcon(FontAwesomeIcons.arrowsRotate),
              iconAlignment: IconAlignment.end,
              label: Text("Changer"),
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.orange),
                iconColor: WidgetStatePropertyAll(Colors.orange),
                overlayColor: WidgetStatePropertyAll(Colors.orange.shade100),
              ),
            )
          ]
        );
      } else {
        handleSubscribtion(!subscribed);
      }
    }
  }

  handleSubscribtion(bool willSubscribe) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Church>(context, listen: false).subscribe(
        widget.churchId,
        willSubscribe: willSubscribe
      ).then((value) async {
        showSnackBar(context: context, message: value, type: SnackBarType.success);
        await Provider.of<User>(context, listen: false).getUserData();
      });
    } on HttpException {
      showSnackBar(
        context: context,
        message: "L'opération a échoué !",
        type: SnackBarType.danger
      );
    } catch(e) {
      showSnackBar(
        context: context,
        message: "Une erreur inattendu est survenue",
        type: SnackBarType.danger
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  getChurch() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Church>(context, listen: false)
      .fetchChurch(widget.churchId)
      .then((value) => {
        setState(() {
          church = ChurchModel.fromJson(value['eglise']);
          owner = UserModel.fromJson(value['user']);
        })
      });
    } catch(e) {
      e.printError();
      showSnackBar(context: context, message: "Une erreur inattendu est survenue !", type: SnackBarType.danger);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getChurch();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context).user;
    bool subscribed = widget.churchId == user.churchId;

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: church == null ? Center(
            child: Text("Chargement..."),
          ) : SingleChildScrollView(
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
                          image: NetworkImage(church!.image),
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
                            backgroundImage: church!.logo != null
                                ? NetworkImage(church!.logo!)
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
                              church!.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                              overflow: TextOverflow.clip,
                            )),
                            const SizedBox(height: 7),
                            Text(
                              owner != null
                              ? owner!.name
                              : "Inconnu",
                              style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Colors.white.withAlpha(170)),
                              overflow: TextOverflow.clip,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_pin,
                              size: 15,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                church!.address,
                                style: Theme.of(context).textTheme.labelMedium!,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.phone,
                              size: 12,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                church!.phone,
                                style: Theme.of(context).textTheme.labelMedium!,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.solidEnvelope,
                              size: 12,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                church!.email,
                                style: Theme.of(context).textTheme.labelMedium!,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextButton.icon(
                      onPressed: () => onSubscribe(subscribed),
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
                  child: Text(church!.description),
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
                    height: MediaQuery.of(context).size.height * .5,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (value) => setPageIndex(value),
                      children: [
                        Program(),
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
    return SingleChildScrollView(
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
    return SingleChildScrollView(
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

  /* var lastEvent = EventModel.fromJson({
    'id': 0,
    'titre':"Intitulé de l'évènement 1",
    'date_debut': DateTime.now(),
    'date_fin': DateTime.now(),
  }); */

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          /* Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: lastEvent.getWidget(context)), */
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: currentProgram.getWidget(context),
          )
        ],
      ),
    );
  }
}
