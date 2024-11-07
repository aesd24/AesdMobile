import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/providers/auth.dart';
import 'package:aesd_app/screens/splash_screen.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:aesd_app/widgets/app_overlay_loading.dart';
import 'package:aesd_app/widgets/grid_dashboard.dart';
//import 'package:aesd_app/components/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _getUserInfo();
  }

  _getUserInfo() async {
    try {
      //await Provider.of<Auth>(context, listen: false).getUserInfoFromCache();
    } catch (e) {
      showSnackBar(
          context: context,
          message: "Impossible d'obtenir les données de l'utilisateur !",
          type: SnackBarType.danger);
      e.printError();
    }
  }

  _logout() async {
    setState() {
      _loading = true;
    }

    await Provider.of<Auth>(context, listen: false).logout().then((value) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AppOverlayLoading(
      loading: _loading,
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        //drawer: MenuDrawer(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kHeaderColor,
          title: const Text(
            "AESD",
            style: TextStyle(
              color: Color(0xffffffff),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () => _logout(),
                child: const Icon(
                  Icons.logout,
                  size: 24.0,
                  color: Color(0xffffffff),
                ),
              ),
            ),
          ],
          actionsIconTheme: const IconThemeData(
              size: 30.0, color: Colors.black, opacity: 10.0),
        ),
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: size.height * 0.27,
                  alignment: Alignment.center,
                  child: const Image(
                    image: AssetImage('assets/images/welcome.jpg'),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'ANNUAIRE DES ÉGLISES ET SERVITEURS DE DIEU',
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            /*SizedBox(
              height: 20,
            ),*/
            /*Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "ANNUAIRE DES ÉGLISES ET SERVITEUR DE DIEU.",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
                  ),
                ],
              ),
            ),*/
            const SizedBox(
              height: 5,
            ),
            GridDashboard()
          ],
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Se déconnecter'),
                  onTap: () async => _logout(),
                ),
              ],
            ),
          );
        });
  }
}
