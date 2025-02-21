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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        shadowColor: Colors.grey.shade300,
        toolbarHeight: size.height * .1,
        elevation: 2,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Row(
              children: [
                Text(
                  widget.user.name,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                    fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.photo!),
                ),
              ],
            ),
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
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                margin: EdgeInsets.all(10),
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
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withAlpha(100),
                      blurRadius: 2,
                      offset: Offset(0.5, 0.5)
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            "Mon église",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        
                        PopupMenuButton(
                          icon: FaIcon(
                            FontAwesomeIcons.ellipsisVertical,
                            size: 16,
                            color: Colors.black
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(value: "item 1", child: Text("Item 1")),
                            PopupMenuItem(value: "item 2", child: Text("Item 2"))
                          ]
                        )
                      ],
                    ),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 35,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "<ChurchName>"
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 10),
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              alignment: WrapAlignment.center,
                              spacing: 13,
                              runSpacing: 10,
                              children: [
                                customIconButton(
                                  label: "Porte-feuille",
                                  icon: FontAwesomeIcons.wallet,
                                  color: Colors.green,
                                  destination: ChurchWallet()
                                ),
                                customIconButton(
                                  destination: ProgramListPage(),
                                  color: Colors.purple,
                                  icon: FontAwesomeIcons.calendar,
                                  label: "Programme"
                                ),
                                customIconButton(
                                  destination: CeremoniesManagement(),
                                  color: Colors.orange,
                                  icon: FontAwesomeIcons.film,
                                  label: "Cérémonies"
                                ),
                                customIconButton(
                                  color: Colors.blue,
                                  icon: FontAwesomeIcons.peopleGroup,
                                  label: "Communauté"
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customIconButton({
    required String label,
    required IconData icon,
    Color color = Colors.blue,
    Widget? destination
  }) {
    return IconButton(
      onPressed: destination != null ?
      () => pushForm(context, destination: destination) : null,
      icon: FaIcon(icon, size: 18),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          color.withAlpha(80)
        ),
        iconColor: WidgetStatePropertyAll(color),
        overlayColor: WidgetStatePropertyAll(
          color.withAlpha(100)
        ),
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
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary
          ),
        )
      ],
    );
  }
}
