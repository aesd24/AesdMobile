import 'package:aesd_app/components/menu_drawer.dart';
import 'package:aesd_app/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context).user;

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
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2)),
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

                    const SizedBox(height: 40),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Informations personnelles",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const FaIcon(
                                FontAwesomeIcons.pen,
                                size: 20,
                                color: Colors.amber,
                              ))
                        ],
                      ),
                    ),

                    // Informations de l'utilisateur
                    customInfoTile(context,
                        value: user.name, label: "Nom & prenoms"),
                    customInfoTile(context,
                        label: "Téléphone", value: "(+225) ${user.phone}"),
                    customInfoTile(context,
                        label: "courriel", value: user.email),
                    /* customInfoTile(context,
                        label: "Type de compte", value: user.accountType), */
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customInfoTile(BuildContext context,
      {required String label, required String value}) {
    return ListTile(
      title: Text(
        value,
        style: Theme.of(context)
            .textTheme
            .labelLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
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
