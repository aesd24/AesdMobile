import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/text_field.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    color: Theme.of(context).colorScheme.secondary
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 20),
              customTextField(
                  label: "Adresse email",
                placeholder: "Renseignez votre adresse email"
              ),
              customButton(
                context: context,
                text: "Faire la demande",
                onPressed: (){}
              )
            ],
          ),
        ),
      ),
    );
  }
}
