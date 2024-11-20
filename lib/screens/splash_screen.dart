import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/screens/new_version/home.dart';
import 'package:aesd_app/providers/auth.dart';
import 'package:aesd_app/screens/new_version/auth/login.dart';
//import 'package:aesd_app/screens/home_screen.dart';
//import 'package:aesd_app/services/session/storage_auth_token_session.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool logged = false;

  void init() async {
    await Provider.of<Auth>(context, listen: false)
        .getToken()
        .then((value) async {
      if (value != null) {
        logged = true;
      }
    });

    Future.delayed(const Duration(seconds: 5), () {
      pushForm(context,
          destination: logged ? const HomePage() : const LoginPage());
    });
  }

  // background Image
  AssetImage background = const AssetImage("assets/images/bg-8.jpg");

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: precacheImage(background, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              // background
              body: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: background,
                  fit: BoxFit.cover,
                )),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // logo de l'application
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 35),
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 200,
                          height: 200,
                        ),
                      ),

                      // titre
                      Text(
                        "Annuaire des Eglises et Serviteurs de Dieu",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const Spacer(),

                      // barre de progression
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        child: LinearProgressIndicator(
                          color: Colors.green,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "\"Là ou deux ou trois sont réunis en mon nom, je suis là au milieu d'eux.\"",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Colors.white60,
                                  fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 200,
                  height: 200,
                ),
              ),
            );
          }
        });
  }
}
