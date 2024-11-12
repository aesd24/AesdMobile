import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/church_selection.dart';
import 'package:aesd_app/components/text_field.dart';
import 'package:aesd_app/models/church_model.dart';
import 'package:aesd_app/providers/church.dart';
import 'package:aesd_app/screens/auth/register/finish.dart';
import 'package:aesd_app/screens/new_version/church/create_church.dart';
import 'package:flutter/material.dart';

class ChooseChurch extends StatefulWidget {
  const ChooseChurch({super.key});

  @override
  State<ChooseChurch> createState() => _ChooseChurchState();
}

class _ChooseChurchState extends State<ChooseChurch> {
  // liste des églises
  List? churchList;

  //controller
  final searchController = TextEditingController();

  // fonction de filtre des églises a partir de la recherche
  List getList() {
    String text = searchController.text;

    // variable à retourner
    List returned = [];

    // boucle sur la liste
    if (text.isNotEmpty && churchList != null) {
      for (var element in churchList!) {
        if (element["name"]
            .toString()
            .toLowerCase()
            .contains(text.toLowerCase())) {
          returned.add(element);
        }
      }
    } else {
      return churchList ?? [];
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
                    MaterialPageRoute(builder: (context) => const FinishPage()),
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
      var churches = await Church().all();
      churchList = churches.item1;
      setState(() {});
    } catch (e) {
      //
    }
  }

  @override
  void initState() {
    super.initState();
    loadChurches();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Choisir une église")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recherche et nouvelle églises
              customButton(
                  context: context,
                  text: "Ajouter mon église",
                  trailing:
                      const Icon(Icons.church_outlined, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateChurchPage()));
                  }),

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
                child: SizedBox(
                  height: size.height * .6,
                  width: double.infinity,
                  child: Builder(builder: (context) {
                    if (churchList == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return churchList!.isNotEmpty
                          ? ListView(
                              children:
                                  List.generate(getList().length, (value) {
                              if (getList().isNotEmpty) {
                                ChurchModel church = getList()[value];
                                return churchSelectionTile(
                                    context: context,
                                    id: church.id!,
                                    name: church.name,
                                    mainPastor: church.mainServant != null
                                        ? church.mainServant!.name
                                        : "inconnu",
                                    zone: church.address,
                                    onClick: _chooseChurch);
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
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                ),
                                alignment: Alignment.center,
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.search_off, size: 60),
                                    Text(
                                        "Aucune église disponible pour le moment !")
                                  ],
                                ),
                              ),
                            );
                    }
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
