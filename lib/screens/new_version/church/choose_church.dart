import 'dart:io';
import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/church_model.dart';
import 'package:aesd_app/providers/church.dart';
import 'package:aesd_app/providers/user.dart';
import 'package:aesd_app/screens/new_version/church/creation/main.dart';
import 'package:aesd_app/screens/new_version/church/detail.dart';
import 'package:aesd_app/screens/new_version/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChooseChurch extends StatefulWidget {
  const ChooseChurch({super.key});

  @override
  State<ChooseChurch> createState() => _ChooseChurchState();
}

class _ChooseChurchState extends State<ChooseChurch> {
  bool isLoading = false;
  bool throwedErrorLastTime = false;

  // liste des églises
  List<ChurchModel> churchList = [];

  //controller
  final searchController = TextEditingController();

  // fonction de filtre des églises a partir de la recherche
  List getList() {
    String text = searchController.text;

    // variable à retourner
    List returned = [];

    // boucle sur la liste
    if (text.isNotEmpty) {
      for (var element in churchList) {
        if (element.name.toLowerCase().contains(text.toLowerCase())) {
          returned.add(element);
        }
      }
    } else {
      return churchList;
    }
    return returned;
  }

  // fonction a éffectué au clique du bouton
  _chooseChurch() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Choisir l'église ?"),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                      "Une demande de validation sera envoyé au serviteur principale."),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                      "En attendant la réponse, vous profiterez de l'application en tant que fidèle."),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text("Choisir cette église ?"),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => route.isFirst),
                style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.green),
                    overlayColor:
                        WidgetStateProperty.all(Colors.green.shade100)),
                child: const Text("Oui"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.red),
                    overlayColor: WidgetStateProperty.all(Colors.red.shade100)),
                child: const Text('Non'),
              )
            ],
          );
        });
  }

  Future loadChurches() async {
    // Load churches from API
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Church>(context, listen: false).fetchChurches();
      churchList = Provider.of<Church>(context, listen: false).churches;
      setState(() {});
    } on DioException {
      showSnackBar(
          context: context,
          message: "Vérifiez votre connexion internet",
          type: SnackBarType.danger);
      setState(() {
        throwedErrorLastTime = true;
      });
    } on HttpException catch (e) {
      e.printError();
      showSnackBar(
          context: context, message: e.message, type: SnackBarType.danger);
      setState(() {
        throwedErrorLastTime = true;
      });
    } catch (e) {
      e.printError();
      showSnackBar(
          context: context,
          message: "Une erreur inattendue est survenue !",
          type: SnackBarType.danger);
      setState(() {
        throwedErrorLastTime = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadChurches();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context).user;

    return Scaffold(
      appBar: AppBar(title: const Text("Choisir une église")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recherche et nouvelle églises
              if (user.accountType == "serviteur_de_dieu")
                customButton(
                    context: context,
                    text: "Ajouter mon église",
                    trailing:
                        const Icon(Icons.church_outlined, color: Colors.white),
                    onPressed: () => pushForm(context,
                        destination: MainChurchCreationPage())),

              // input de recherche
              customTextField(
                  label: "Entrez votre recherche",
                  controller: searchController,
                  prefixIcon: const Icon(Icons.search),
                  onChanged: (value) {
                    getList();
                    setState(() {});
                  }),

              // liste des églises
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Builder(builder: (context) {
                  if (isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return churchList.isNotEmpty
                        ? Column(
                            children: List.generate(getList().length, (value) {
                            if (getList().isNotEmpty) {
                              ChurchModel church = getList()[value];
                              return GestureDetector(
                                onTap: () => pushForm(context,
                                    destination:
                                        ChurchDetailPage(church: church)),
                                child: church.card(context),
                              );
                            } else {
                              return Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                ),
                                alignment: Alignment.center,
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.search_off, size: 60),
                                    Text(
                                        "Aucune résultat correspondant à la recherche !")
                                  ],
                                ),
                              );
                            }
                          }))
                        : Center(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.search_off, size: 60),
                                  const Text(
                                      "Aucune église disponible pour le moment !"),
                                  const SizedBox(height: 30),
                                  if (throwedErrorLastTime)
                                    customButton(
                                        context: context,
                                        onPressed: () async =>
                                            await loadChurches(),
                                        text: "Rééssayer",
                                        trailing: const FaIcon(
                                          FontAwesomeIcons.arrowRotateRight,
                                          color: Colors.white,
                                        ))
                                ],
                              ),
                            ),
                          );
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
