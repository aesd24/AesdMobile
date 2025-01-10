import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/user_model.dart';
import 'package:aesd_app/screens/new_version/auth/recover_account/forgot_password.dart';
import 'package:aesd_app/screens/new_version/auth/register/register.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilPage extends StatefulWidget {
  ProfilPage({super.key, required this.user});

  UserModel user;
  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(color: Colors.green, blurRadius: 5)
              ], borderRadius: BorderRadius.circular(100)),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: widget.user.photo == null
                    ? const AssetImage("assets/profil.png")
                    : NetworkImage(widget.user.photo!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextButton.icon(
                  onPressed: () => pushForm(context,
                      destination: RegisterPage(
                        update: true,
                      )),
                  icon: const FaIcon(FontAwesomeIcons.pen, size: 20),
                  iconAlignment: IconAlignment.end,
                  style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.amber),
                      overlayColor:
                          WidgetStateProperty.all(Colors.amber.shade100),
                      backgroundColor:
                          WidgetStateProperty.all(Colors.amber.shade50),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.amber, width: 2),
                        borderRadius: BorderRadius.circular(100),
                      ))),
                  label: const Text("Modifier les informations")),
            ),
            customInfoTile(label: "Nom & prénoms", value: widget.user.name),
            customInfoTile(label: "email", value: widget.user.email),
            customInfoTile(
                label: "Numéro de téléphone", value: widget.user.phone),
            customInfoTile(
              label: "Adresse",
              value: widget.user.adress.isEmpty
                  ? "Pas d'adresse"
                  : widget.user.adress,
            ),
            customInfoTile(
                label: "Type de compte", value: widget.user.accountType),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: customButton(
                  context: context,
                  text: "Mot de passe oublié ?",
                  onPressed: () => pushForm(context,
                      destination: const ForgotPasswordPage())),
            )
          ],
        ),
      ),
    );
  }

  ListTile customInfoTile({required String label, required String value}) {
    return ListTile(
      title: Text(
        value,
        style: TextStyle(
            color: Colors.green.shade900, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        label,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
