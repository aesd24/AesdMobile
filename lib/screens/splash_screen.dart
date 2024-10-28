import 'package:aesd_app/screens/new_version/home.dart';
import 'package:dio/dio.dart';
import 'package:aesd_app/providers/auth.dart';
import 'package:aesd_app/requests/dio_client.dart';
import 'package:aesd_app/screens/auth/login.dart';
//import 'package:aesd_app/screens/home_screen.dart';
import 'package:aesd_app/services/session/storage_auth_token_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Future<StorageAuthTokenSession> _futureAuthToken =
      StorageAuthTokenSession.getFormSecureStorage();

  bool logged = false;

  void init() async {
    if (await checkConnectionState()) {
      _futureAuthToken.then((StorageAuthTokenSession authToken) => {
            Provider.of<Auth>(context, listen: false)
                .setToken(type: authToken.type, token: authToken.token)
          });

      Future.delayed(const Duration(seconds: 10), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                logged ? const HomePage() : const LoginPage()));
      });
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Erreur !"),
              content: const Text(
                  "Connexion impossible. Vérifiez votre connexion internet et rééssayez !"),
              actions: [
                TextButton(
                  onPressed: () {
                    // fermer l'application
                    SystemNavigator.pop();
                  },
                  style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.red),
                      overlayColor:
                          WidgetStateProperty.all(Colors.red.shade200)),
                  child: const Text("Fermer"),
                ),
                TextButton(
                  onPressed: () {
                    // rééssayer de vérifier le serveur
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const SplashScreen()),
                        (route) => false);
                  },
                  style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.blue),
                      overlayColor:
                          WidgetStateProperty.all(Colors.blue.shade200)),
                  child: const Text("Rééssayer"),
                )
              ],
            );
          });
    }
  }

  Future<bool> checkConnectionState() async {
    try {
      var client = await DioClient().getApiClient();
      var response = await client.get("test");

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException {
      return false;
    }
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
    setState(() {
      logged = Provider.of<Auth>(context).isLogged();
    });

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
