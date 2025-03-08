import 'package:aesd_app/components/menu_drawer.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/church_model.dart';
import 'package:aesd_app/models/user_model.dart';
import 'package:aesd_app/providers/church.dart';
import 'package:aesd_app/screens/church/creation/main.dart';
import 'package:aesd_app/screens/church/detail.dart';
import 'package:aesd_app/screens/dashboard/ceremony.dart';
import 'package:aesd_app/screens/dashboard/church_wallet.dart';
import 'package:aesd_app/screens/dashboard/events.dart';
import 'package:aesd_app/screens/dashboard/programs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key, required this.user});

  UserModel user;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isLoading = false;
  List<ChurchModel> userChurches = [];

  init() async {
    try{
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Church>(context, listen: false).getUserChurches()
      .then((value) {
        userChurches = Provider.of<Church>(context, listen: false).userChurches;
        setState(() {});
      });
    } catch (e) {
      e.printError();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
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
                    backgroundImage: widget.user.photo != null ?
                      NetworkImage(widget.user.photo!) : null,
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
                Text(
                  "Eglises",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Consumer<Church>(
                  builder: (context, churchProvider, child) {
                    return Column(
                    children: List.generate(
                      churchProvider.userChurches.length, 
                      (index) => churchCard(
                        church: churchProvider.userChurches[index]
                      )
                    ),
                  );
                  }
                ),
                SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget churchCard({
    required ChurchModel church,
  }) {
    return Container(
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
          Align(
            alignment: Alignment.centerRight,
            child: PopupMenuButton(
              icon: FaIcon(
                FontAwesomeIcons.ellipsisVertical,
                size: 16,
                color: Colors.black
              ),
              onSelected: (value) {
                if (value == "profil"){
                  pushForm(context, destination: ChurchDetailPage(churchId: church.id));
                } else if (value == "edit"){
                  pushForm(context, destination: MainChurchCreationPage(
                    editMode: true, churchId: church.id
                    )
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: "profil", child: Text("Consulter le profil")),
                PopupMenuItem(value: "edit", child: Text("Modifier l' église"))
              ]
            ),
          ),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                ),
                SizedBox(height: 5),
                Text(church.name),

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
                        icon: FontAwesomeIcons.calendarWeek,
                        label: "Programme"
                      ),
                      customIconButton(
                        destination: ChurchEvents(churchId: church.id),
                        color: Colors.amber,
                        icon: FontAwesomeIcons.solidCalendarDays,
                        label: "Evènements"
                      ),
                      customIconButton(
                        destination: CeremoniesManagement(churchId: church.id),
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
