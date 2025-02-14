import 'dart:io';

import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/components/auth_overlay_loading.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/providers/auth.dart';
import 'package:aesd_app/screens/home/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key, required this.requestEmail});

  final String requestEmail;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool isLoading = false;

  // clé de formulaire
  final _formKey = GlobalKey<FormState>();

  // controllers
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  // variables de visibilité
  bool _isPasswordVisible = false;
  bool _isConfirmationVisible = false;

  Future changePassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      Provider.of<Auth>(context, listen: false).changePassword(
        email: widget.requestEmail,
        newPassword: _passwordController.text,
        newPasswordConfirmation: _confirmationController.text
      ).then((value) {
        if (value.statusCode == 200){
          if (context.mounted){
            showSnackBar(
              context: context,
              message: "Mot de passe modifier avec succès",
              type: SnackBarType.success
            );
            closeAllAndPush(context, HomePage());
          }
        }
      });
    } on DioException catch (e) {
      e.printError();
      showSnackBar(
          context: context,
          message: "Erreur réseau, vérifier votre connexion internet",
          type: SnackBarType.danger);
    } on HttpException catch (e) {
      showSnackBar(
          context: context, message: e.message, type: SnackBarType.danger);
    } catch (e) {
      e.printError();
      showSnackBar(
          context: context,
          message: "Une erreur s'est produite. Veuillez réessayer",
          type: SnackBarType.danger);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthOverlayLoading(
      loading: isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text("Modification")),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Modifiez maintenant votre mot de passe",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),

                  // adresse email pour la vérification
                  /* customTextField(
                      prefixIcon: const Icon(
                        FontAwesomeIcons.envelope,
                        size: 20,
                      ),
                      label: "Adresse email",
                      type: TextInputType.emailAddress,
                      controller: _emailController), */

                  // nouveau mot de passe
                  customTextField(
                      label: "Nouveau mot de passe",
                      obscureText: !_isPasswordVisible,
                      prefixIcon: const Icon(FontAwesomeIcons.lock, size: 20),
                      suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: FaIcon(
                            !_isPasswordVisible
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: 20,
                            color: Colors.grey,
                          )),
                      controller: _passwordController),

                  // confirmation du mot de passe
                  customTextField(
                      label: "Confirmation",
                      obscureText: !_isConfirmationVisible,
                      prefixIcon: const Icon(FontAwesomeIcons.lock, size: 20),
                      suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              _isConfirmationVisible = !_isConfirmationVisible;
                            });
                            //print("cliqué");
                          },
                          icon: FaIcon(
                            !_isConfirmationVisible
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: 20,
                            color: Colors.grey,
                          )),
                      controller: _confirmationController),

                  // bouton de confirmation
                  const SizedBox(height: 20),
                  customButton(
                      context: context,
                      text: "Changer mon mot de passe",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await changePassword();
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
