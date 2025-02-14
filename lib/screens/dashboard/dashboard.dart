import 'package:aesd_app/components/menu_drawer.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/user_model.dart';
import 'package:aesd_app/screens/dashboard/ceremony.dart';
import 'package:aesd_app/screens/dashboard/church_wallet.dart';
import 'package:aesd_app/screens/dashboard/programs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key, required this.user});

  UserModel user;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(),
          )
        ],
      ),
      drawer: MenuDrawer(pageIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customContainer(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Statistiques d'abonnements
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        customStat(context, value: 0, label: "Abonné(s)"),
                        customStat(context, value: 0, label: "Abonnement(s)")
                      ],
                    ),
                  ],
                ),
              ),
              //if (widget.user.church != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Mon église",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              //if (widget.user.church != null)
              customContainer(context,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(""
                                //widget.user.church!.logo!
                                ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                              child: Text(
                                  "Nom de l'église", //widget.user.church!.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Wrap(
                          runAlignment: WrapAlignment.start,
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            customSquaredButton(
                              destination: const ChurchWallet(),
                              color: Colors.green,
                              icon: FontAwesomeIcons.wallet,
                              label: "Porte-feuille"
                            ),
                            customSquaredButton(
                              destination: ProgramListPage(),
                              color: Colors.purple,
                              icon: FontAwesomeIcons.calendar,
                              label: "Programme"
                            ),
                            customSquaredButton(
                              destination: CeremoniesManagement(),
                              color: Colors.orange,
                              icon: FontAwesomeIcons.film,
                              label: "Cérémonies"
                            ),
                            customSquaredButton(
                              color: Colors.blue,
                              icon: FontAwesomeIcons.peopleGroup,
                              label: "Communauté"
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Annexes",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Card(
                            elevation: 2,
                            shadowColor: Colors.green,
                            color: Colors.green.shade50,
                            child: const ListTile(
                              title: Text("Localisation de l'annexe"),
                              subtitle: Text("Géré par: Serviteur de l'annexe"),
                            ),
                          )
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget customSquaredButton({
    required String label,
    required IconData icon,
    Color color = Colors.blue,
    Widget? destination
  }) {
    return GestureDetector(
      onTap: destination != null
          ? () => pushForm(context, destination: destination)
          : null,
      child: Column(
        children: [
          Container(
            height: 65,
            width: 65,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: color),
                color: color.withOpacity(.4),
                borderRadius: BorderRadius.circular(7)),
            child: Center(
              child: FaIcon(
                icon,
                size: 25,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(label)
        ],
      ),
    );
  }

  Container customContainer(BuildContext context, {required Widget child}) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 2)),
        child: child);
  }

  Column customStat(BuildContext context,
      {required int value, required String label}) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        )
      ],
    );
  }
}
