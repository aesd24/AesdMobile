import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/providers/servant.dart';
import 'package:aesd_app/screens/user/dashbord/church_dashbord.dart';
import 'package:aesd_app/screens/user/dashbord/personnal_dashbord.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class Dashbord extends StatefulWidget {
  const Dashbord({super.key});

  @override
  State<Dashbord> createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {

  bool isLoading = false;

  init() async {
    try{
      setState(() {
        isLoading = true;
      });

      await Provider.of<Servant>(context, listen: false).getServant();
    } catch(e){
      e.printError();
      Navigator.of(context).pushReplacementNamed(
        '/home'
      );
      showSnackBar(
        context: context,
        message: "Impossible de vérifier que vous êtes un serviteur !",
        type: "danger"
      );
    } finally{
      setState(() {
        isLoading = false;
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

    return LoadingOverlay(
      isLoading: isLoading,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Tableau de bord"),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  sliver: SliverAppBar(
                    expandedHeight: 100.0,
                    toolbarHeight: 0,
                    forceElevated: innerBoxIsScrolled,
                    bottom: const TabBar(
                      dividerHeight: 0,
                      // These are the widgets to put in each tab in the tab bar.
                      tabs: [
                        Tab(
                          icon: Icon(Icons.person_pin_rounded),
                          child: Text("Personnel"),
                        ),
                        Tab(
                          icon: Icon(Icons.church_rounded),
                          child: Text("Mon église"),
                        ),
                      ],
                    ),
                  ),
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                )
              ];
            },
            body: const TabBarView(
              children: [
                SafeArea(
                  top: false,
                  bottom: false,
                  child: PersonnalDashbord()
                ),
                SafeArea(
                  top: false,
                  bottom: false,
                  child: ChurchDashbord()
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}