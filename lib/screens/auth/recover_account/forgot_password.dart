import 'dart:io';

import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/providers/auth.dart';
import 'package:aesd_app/screens/auth/recover_account/validation.dart';
import 'package:aesd_app/components/auth_overlay_loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // clé de formulaire
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  final _infoController = TextEditingController();

  Future submit() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Auth>(context, listen: false)
        .forgotPassword(email: _infoController.text)
        .then((value) {
          pushForm(context, destination: const ValidateOtpPage());
        }
      );
    } on DioException catch(e) {
      e.printError();
      showSnackBar(
        context: context,
        message: "Erreur réseau. Vérifier votre connexion internet", 
        type: SnackBarType.danger
      );
    } on HttpException catch (e) {
      showSnackBar(
        context: context,
        message: e.message,
        type: SnackBarType.danger
      );
    } catch(e){
      e.printError();
      showSnackBar(
        context: context,
        message: "Erreur inattendue",
        type: SnackBarType.danger
      );
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
        appBar: AppBar(
          title: const Text("Mot de passe oublié"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Saisissez votre adresse email et après vérification, nous vous enverrons un email pour la modification de votre mot de passe",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: customTextField(
                      label: "Email",
                      controller: _infoController,
                      placeholder: "Saisissez votre adresse email",
                      prefixIcon: const Icon(FontAwesomeIcons.envelope, size: 20),
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return "Veuillez renseigner votre adresse email ou votre numéro de téléphone";
                        }
                        return null;
                      }),
                ),
                customButton(
                    context: context,
                    text: "Faire la demande",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await submit();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
