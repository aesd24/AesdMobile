import "package:aesd_app/components/button.dart";
import "package:aesd_app/components/drop_down.dart";
import "package:aesd_app/components/snack_bar.dart";
import "package:aesd_app/components/text_field.dart";
import "package:aesd_app/components/toggle_form.dart";
import "package:aesd_app/constants/dictionnary.dart";
import "package:aesd_app/providers/auth.dart";
import "package:aesd_app/providers/user.dart";
import "package:aesd_app/screens/auth/login.dart";
import "package:aesd_app/screens/auth/register/finish.dart";
import "package:aesd_app/screens/auth/register/add_photo.dart";
import "package:aesd_app/screens/webview.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key, required this.accountType, this.update});
  String accountType;
  bool? update = false;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // formKey
  final _formKey = GlobalKey<FormState>();

  // controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _telController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? call; // l'appel du serviteur (pasteur, evangéliste...)

  // accept terms
  bool terms = false;

  // passwords visible
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // fonction d'enregistrement de fidèle
  void _startRegistering () async {
    Widget? destinationPage; // page de destination

    if (widget.accountType.toLowerCase() == "ftf"){
      destinationPage = const FinishPage();
    } else if (widget.accountType.toLowerCase() == "svt"){
      destinationPage = const AddPhotoPage();
    } else {
      destinationPage = const LoginPage();
    }

    Provider.of<User>(context, listen: false).setRegisterData({
      "account_type": widget.accountType, 
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _telController.text,
      "password": _passwordController.text,
      "password_confirmation": _confirmPasswordController.text,
      "description" : _descriptionController.text,
      "call": call,
      "terms" : terms,
      "device_name" : "xxxxx"
    });

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => destinationPage!)
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // obtention des données utilisateur pour la modification
    if (widget.update == true){
      var userData = Provider.of<Auth>(context).user;

      _nameController.text = userData.name;
      _emailController.text = userData.email;
      _telController.text = userData.phone;
      call = "PAS";
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // revenir au formulaire précédent
                          returnButton(context: context),
                      
                          // Titre et sous-titre
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              children: [
                                Text(
                                  (widget.update != null && widget.update!) ? "Modification" : "Enregistrement",
                                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                      
                                const SizedBox(height: 3),
                      
                                Text(
                                  (widget.update != null && widget.update!) ? "Modifier vos informations" : 'Saisissez les informations',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.grey,
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                
                    // formulaire
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Form(
                        key: _formKey,
                        child: SizedBox(
                          height: size.height * .66,
                          child: ListView(
                            children: [
                              // champs de nom et prénoms
                              customTextField(
                                controller: _nameController,
                                prefixIcon: const Icon(Icons.person_outlined),
                                label: "Nom et prénoms",
                                placeholder: "Ex: John Elco",
                                validator: (value){
                                  // vérification que le champs est remplis
                                  if (value == null || value.toString().isEmpty){
                                    return "Remplissez le champs SVP !";
                                  }
                          
                                  // vérifier qu'il entre seulement un prénom avec le nom
                                  if (value.toString().split(" ").length < 2){
                                    return "Entrez uniquement votre nom et 1 prénom SVP !";
                                  }
                                  return null;
                                }
                              ),
                          
                              //champs de l'adresse email    
                              customTextField(
                                controller: _emailController,
                                prefixIcon: const Icon(Icons.mail_outlined),
                                type: TextInputType.emailAddress,
                                label: "Adresse e-mail",
                                placeholder: "Ex: exemple@exemple.com",
                                validator: (value){
                                  // vérification que le champs est remplis
                                  if (value == null || value.toString().isEmpty){
                                    return "Remplissez le champs SVP !";
                                  }
                                  if(!RegExp("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]{2,}?\\.[a-zA-Z]{2,}\$").hasMatch(value)){
                                    if(!RegExp("^[a-zA-Z0-9._%-]{5,}").hasMatch(value)){
                                      return "Entrez au moins 5 caractères avant le '@'";
                                    }
                                    if (!RegExp("^[.]*.[a-zA-Z0-9]{2,}\$").hasMatch(value)){
                                      return "Nom de domaine invalide !";
                                    }
                                    return "Adresse email invalide !";
                                  }
                                  return null;
                                }
                              ),
                              
                              // champs du numéro de téléphone
                              customTextField(
                                controller: _telController,
                                prefixIcon: const Icon(Icons.phone_outlined),
                                type: TextInputType.number,
                                label: "Téléphone",
                                placeholder: "Ex: 0011223344",
                                validator: (value){
                                  // vérification que le champs est remplis
                                  if (value == null || value.toString().isEmpty){
                                    return "Remplissez le champs SVP !";
                                  }
                                      
                                  if (!RegExp('^[0-9]{10}\$').hasMatch(value)){
                                    return "Entrez un numéro à 10 chiffres";
                                  }
                                      
                                  if (!RegExp("^(01|07|05)").hasMatch(value)){
                                    return "Le numéro doit commencer par 01, 05 ou 07";
                                  }
                                  return null;
                                }
                              ),
                          
                              // champs de choix de l'appel du serviteur
                              if(widget.accountType.toLowerCase() == "svt") customDropDownField(
                                label: 'Quel est votre appel ?',
                                value: call,
                                onChange: (value){
                                  setState(() {
                                    call = value;
                                  });
                                },
                                validator: (value){
                                  if (value == null){
                                    return "Veuillez choisir un appel !";
                                  }
                                  return null;
                                },
                                prefixIcon: const Icon(Icons.wb_sunny_outlined),
                                items: List.generate(servantTypes.length, (index){
                                  var current = servantTypes[index];
                                  return {
                                    "id": current.id,
                                    "code": current.code,
                                    "name": current.name
                                  };
                                })
                              ),

                              // champs de mot de passe
                              if (widget.update == null) customTextField(
                                obscureText: !_passwordVisible,
                                controller: _passwordController,
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffix: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  icon: Icon(!_passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined)
                                ),
                                label: "Mot de passe",
                                placeholder: "Ex: mot_2_passe",
                                validator: (value){
                                  // vérification que le champs est remplis
                                  if (value == null || value.toString().isEmpty){
                                    return "Remplissez le champs SVP !";
                                  }
                                      
                                  if (value.toString().length < 8){
                                    return "Entrez un mot de passe d'au moins 8 caractères";
                                  }
                                      
                                  if (!RegExp("[0-9]+").hasMatch(value)){
                                    return "Le mot de passe doit contenir au moins un chiffre";
                                  }
                                      
                                  if(!RegExp("[A-Z]+").hasMatch(value)){
                                    return "Le mot de passe doit contenir au moins une majuscule";
                                  }
    
                                  if (RegExp('[ ]+').hasMatch(value)){
                                    return "Le mot de passe ne doit pas contenir d'espace";
                                  }
                                      
                                  return null;
                                }
                              ),
                              
                              // champs de confirmation de mot de passe
                              if (widget.update == null) customTextField(
                                obscureText: !_confirmPasswordVisible,
                                controller: _confirmPasswordController,
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffix: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _confirmPasswordVisible = !_confirmPasswordVisible;
                                    });
                                  },
                                  icon: Icon(!_confirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined)
                                ),
                                label: "Confirmé le mot de passe",
                                placeholder: "le même mot de passe !",
                                validator: (value){
                                  // vérification que le champs est remplis
                                  if (value == null || value.toString().isEmpty){
                                    return "Remplissez le champs SVP !";
                                  }
                                      
                                  if (_passwordController.text != _confirmPasswordController.text){
                                    return "Les mots de passe ne correspondent pas";
                                  }
                                      
                                  return null;
                                }
                              ),

                              if (widget.update == null) if (widget.accountType.toLowerCase() == "svt") customMultilineField(
                                label: "Décrivez vous !",
                                controller: _descriptionController
                              ),
                                            
                              // Conditions d'utilisation et politique de confidentialité
                              if (widget.update == null) CheckboxListTile(
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "J'ai lu et j'accepte les ",
                                        style: Theme.of(context).textTheme.labelLarge
                                      ),
                                      TextSpan(
                                        text: "conditions générales d'utilisation",
                                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                          color: Colors.green
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => CustomWebView(url: "https://eglisesetserviteursdedieu.com/terms-of-service"))
                                          );
                                          print('Opened');
                                        },
                                      ),
                                      TextSpan(
                                        text: " et la ",
                                        style: Theme.of(context).textTheme.labelLarge
                                      ),
                                      TextSpan(
                                        text: "politique de confidentialité",
                                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                          color: Colors.green
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => CustomWebView(url: "https://eglisesetserviteursdedieu.com/privacy-policy"))
                                          );
                                          print('Opened');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                value: terms,
                                onChanged: (bool? value) {
                                  setState(() {
                                    terms = value ?? false;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            ],
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: customButton(
                          context: context,
                          text: (widget.update != null && widget.update!) ? "Modifier" : "S'inscrire",
                          onPressed: (){
                            if(terms != false){
                              if (_formKey.currentState!.validate()){
                                _startRegistering();
                              }
                            }
                            else {
                              showSnackBar(
                                context: context,
                                message: "Acceptez les terms pour continuer !",
                                type: "warning"
                              );
                            }
                          }
                        )
                      ),
                  
                      // lien vers la page de connexion
                      if (widget.update == null) const SizedBox(height: 10),
                      if (widget.update == null) toggleLink(
                        context: context,
                        targetPage: const LoginPage(),
                        label: "Vous avez déjà un compte ?",
                        linkText: "Connectez-vous !"
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget hypertextLink({
    required BuildContext context,
    required String text,
    bool? icon
  }){
    return GestureDetector(
      onTap: (){
        // hypertext link
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: Colors.green,
            )
          ),
          if(icon != null && icon) const SizedBox(width: 10,),
          if(icon != null && icon) const Icon(Icons.link, color: Colors.green)
        ]
      )
    );
  }
}