import 'dart:io';

import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/components/toggle_form.dart';
//import 'package:aesd_app/exceptions/http_form_validation_exception.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/providers/auth.dart';
import 'package:aesd_app/screens/auth/recover_account/forgot_password.dart';
import 'package:aesd_app/screens/auth/register/register.dart';
//import 'package:aesd_app/screens/home_screen.dart';
import 'package:aesd_app/screens/home/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aesd_app/components/auth_overlay_loading.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isProcessing = false; // le traitement est-il en cours ?

  bool _keyboardVisible = false;

  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;

  // controllers
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  // fonction de connexion
  Future login() async {
    setState(() {
      _isProcessing = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .login(
        login: _loginController.text,
        password: _passwordController.text,
      )
          .then((response) {
        if (response.statusCode == 200) {
          // Aller a la page 'home';
          Get.offAll(() => const HomePage());
        }
      });
    } on HttpException catch (e) {
      showSnackBar(
          context: context, message: e.message, type: SnackBarType.warning);
    } on DioException {
      showSnackBar(
          context: context,
          message: 'Vérifiez votre connexion internet',
          type: SnackBarType.danger);
    } catch (e) {
      e.printInfo();
      showSnackBar(
          context: context,
          type: SnackBarType.danger,
          message: "Une erreur est survenue");
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // fond d'écran
  AssetImage backgroundImage = const AssetImage('assets/images/bg-1.jpg');

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    Size size = MediaQuery.of(context).size;
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return AuthOverlayLoading(
      loading: _isProcessing,
      child: Scaffold(
        body: FutureBuilder(
            future: precacheImage(backgroundImage, context),
            builder: (context, snapshot) {
              return Stack(
                children: [
                  // image de fond (background)
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/bg-1.jpg'),
                      fit: BoxFit.cover,
                    )),
                  ),

                  // section du logo
                  if (!_keyboardVisible)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: size.height * .1),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/logo.png",
                              height: size.height * .2,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Bon retour !",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "connectez-vous",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                  // section du formulaire
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      height: size.height * .55,
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withAlpha(250),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15))),

                      // formulaire
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            customTextField(
                                label: 'email / numéro de téléphone',
                                placeholder: "ex: test@exp.com / 0011223344",
                                prefixIcon: Icon(
                                  FontAwesomeIcons.envelope,
                                  size: 20,
                                ),
                                controller: _loginController,
                                validator: (value) {
                                  //var emailSplitted = value.toString().split("@");
                                  RegExp emailReg = RegExp(
                                      "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]{2,}?\\.[a-zA-Z]{2,}\$");
                                  RegExp telReg =
                                      RegExp("^(01|05|07)[0-9]{8}\$");

                                  // vérification que le champs est remplis
                                  if (value == null ||
                                      value.toString().isEmpty) {
                                    return "Remplissez le champs SVP !";
                                  }

                                  // vérifier que l'utilisateur à entrez une email ou un numéro de telephone
                                  if (!emailReg.hasMatch(value) &&
                                      !telReg.hasMatch(value)) {
                                    // Envoie de messages relatifs a l'erreur sur le numéro de telephone
                                    if (RegExp("^[0-9]+\$").hasMatch(value)) {
                                      if (!RegExp('^[0-9]{10}\$')
                                          .hasMatch(value)) {
                                        return "Entrez un numéro à 10 chiffres";
                                      }

                                      if (!RegExp("^(01|07|05)")
                                          .hasMatch(value)) {
                                        return "Le numéro doit commencer par 01, 05 ou 07";
                                      }
                                    }

                                    // Envoie de messages relatifs à l'erreur sur l'email
                                    else {
                                      if (!RegExp("^[a-zA-Z0-9._%-]{5,}")
                                          .hasMatch(value)) {
                                        return "Entrez au moins 5 caractères avant le '@'";
                                      }
                                      if (!RegExp("^[.]*.[a-zA-Z0-9]{2,}\$")
                                          .hasMatch(value)) {
                                        return "Nom de domaine invalide !";
                                      }
                                    }
                                    return "Adresse email ou numéro de téléphone invalide !";
                                  }
                                  return null;
                                }),
                            customTextField(
                                label: 'Mot de passe',
                                placeholder: "ex: mot_2_passe",
                                prefixIcon: const Icon(
                                  FontAwesomeIcons.lock,
                                  size: 20,
                                ),
                                obscureText: obscurePassword,
                                suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: FaIcon(
                                    obscurePassword
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 20,
                                  ),
                                ),
                                controller: _passwordController,
                                validator: (value) {
                                  if (value == null ||
                                      value.toString().isEmpty) {
                                    return "Remplissez le champs SVP !";
                                  }
                                  return null;
                                }),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: GestureDetector(
                                onTap: () => pushForm(context,
                                    destination: const ForgotPasswordPage()),
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () => pushForm(context,
                                          destination:
                                              const ForgotPasswordPage()),
                                      child: Text(
                                        "Mot de passe oublié ?",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: Colors.green,
                                            ),
                                      ),
                                    )),
                              ),
                            ),

                            // bouton valider
                            customButton(
                                context: context,
                                text: "Se connecter",
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    login();
                                  }
                                }),

                            // lien vers l'enregistrement
                            const Spacer(),
                            toggleLink(
                                context: context,
                                targetPage: RegisterPage(),
                                label: "Vous n'avez pas de compte ?",
                                linkText: "Enregistrez vous !"),

                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
