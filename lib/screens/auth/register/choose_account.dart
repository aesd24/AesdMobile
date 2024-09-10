import 'package:aesd_app/components/toggle_form.dart';
import 'package:aesd_app/constants/dictionnary.dart';
import 'package:aesd_app/screens/auth/login.dart';
import 'package:aesd_app/screens/auth/register/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseAccount extends StatefulWidget {
  const ChooseAccount({super.key});

  @override
  State<ChooseAccount> createState() => _ChooseAccountState();
}

class _ChooseAccountState extends State<ChooseAccount> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // image de fond
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              "assets/images/bg-1.jpg",
              fit: BoxFit.cover
            )
          ),

          // OVERLAY

          // Logo de l'application
          // section du logo
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
                    "Bienvenu(e)",
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Vous êtes...",
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // liste des comptes
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(accountTypes.length, (value){
                  var account = accountTypes[value];
                  return selectAccountTile(
                    context: context,
                    title: account.name,
                    value: account.code,
                  );
                })
              )
            )
          ),

          // lien vers l'enregistrement
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: toggleLink(
                context: context,
                targetPage: const LoginPage(),
                label: "Vous avez déjà un compte ?",
                linkText: "Connectez-vous !",
                dark: true
              )
            )
          )
        ]
      )
    );
  }
}

Widget selectAccountTile({
  required BuildContext context,
  required String title,
  required String value,
}){
  return GestureDetector(
    onTap: (){      
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RegisterPage(accountType: value))
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(7),
      ),
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )
        ),
        trailing: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.keyboard_arrow_right, color: Colors.green),
        )
      )
    )
  );
}