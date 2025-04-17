import "dart:io";
import "package:aesd_app/components/button.dart";
import "package:aesd_app/components/drop_down.dart";
import "package:aesd_app/components/snack_bar.dart";
import "package:aesd_app/components/field.dart";
import "package:aesd_app/components/toggle_form.dart";
import "package:aesd_app/constants/dictionnary.dart";
import "package:aesd_app/functions/navigation.dart";
import "package:aesd_app/models/user_model.dart";
import "package:aesd_app/providers/auth.dart";
//import "package:aesd_app/providers/auth.dart";
import "package:aesd_app/providers/user.dart";
import "package:aesd_app/screens/auth/login.dart";
import "package:aesd_app/screens/auth/register/finish.dart";
import "package:aesd_app/screens/auth/register/add_photo.dart";
import "package:aesd_app/screens/home/home.dart";
import "package:aesd_app/components/webview.dart";
import "package:dio/dio.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:get/get.dart";
import "package:loading_overlay/loading_overlay.dart";
import "package:provider/provider.dart";

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key, this.update, this.user});
  bool? update = false;
  UserModel? user;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;

  // formKey
  final _formKey = GlobalKey<FormState>();

  // controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _telController = TextEditingController();
  final _passwordController = TextEditingController();
  final _adressController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _descriptionController = TextEditingController(); // (compte chantre)
  final _managerController = TextEditingController(); // nom du manager (compte chantre)
  String? call; // l'appel du serviteur (pasteur, evangéliste...)
  String accountType = Type.faithFul.code;

  // accept terms
  bool terms = false;

  // passwords visible
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // fonction d'enregistrement de fidèle
  void _startRegistering() async {
    Widget? destinationPage; // page de destination
    if (accountType == Type.servant.code) {
      destinationPage = const AddPhotoPage();
    } else {
      destinationPage = const FinishPage();
    }

    Provider.of<User>(context, listen: false).setRegisterData({
      "account_type": accountType,
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _telController.text,
      "adress": _adressController.text,
      "password": _passwordController.text,
      "password_confirmation": _confirmPasswordController.text,
      "manager": _managerController.text,
      "description": _descriptionController.text,
      "call": call,
    });

    pushForm(context, destination: destinationPage);
  }

  modifyInformation() async {
    try{
      setState(() {
        isLoading = true;
      });
      await Provider.of<Auth>(context, listen: false)
      .modifyInformation({
        "name": _nameController.text,
        "email": _emailController.text,
        "phone": _telController.text,
        "adresse": _adressController.text,
      }).then((value) {
        if (value.statusCode == 200){
          showSnackBar(
            context: context,
            message: "Modification éffectué avec succès",
            type: SnackBarType.success
          );
          closeAllAndPush(context, HomePage());
        }
      });
    } on HttpException catch(e) {
      showSnackBar(
        context: context,
        message: e.message,
        type: SnackBarType.danger
      );
    } on DioException {
      showSnackBar(
        context: context,
        message: "Une erreur s'est produite",
        type: SnackBarType.danger
      );
    } catch (e){
      e.printError();
      showSnackBar(
        context: context,
        message: "Une erreur s'est produite",
        type: SnackBarType.danger
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // obtention des données utilisateur pour la modification
    if (widget.update == true) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _telController.text = widget.user!.phone;
      _adressController.text = widget.user!.adress;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text((widget.update != null && widget.update!)
                ? "Modification"
                : "Enregistrement",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.green, fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 3),
              Text((widget.update != null && widget.update!)
                ? "Modifier vos informations"
                : 'Saisissez les informations',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.grey,
                )
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(7),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: SizedBox(
                      height: size.height * .66,
                      child: ListView(
                        children: [
                          if (widget.update == null || !widget.update!) customDropDownField(
                            label: "Type de compte",
                            value: accountType,
                            onChange: (value) {
                              setState(() {
                                accountType = value;
                              });
                            },
                            items: List.generate(Type.accountTypes.length, (index) {
                              var current = Type.accountTypes[index];
                              return DropdownMenuItem(
                                  value: current.code,
                                  child: Text(current.name));
                            })
                          ),
    
                          const SizedBox(height: 15),
    
                          // champs de nom et prénoms
                          customTextField(
                            controller: _nameController,
                            prefixIcon: const Icon(Icons.person_outlined),
                            label: "Nom et prénoms",
                            placeholder: "Ex: John Elco",
                            validator: (value) {
                              // vérification que le champs est remplis
                              if (value == null || value.toString().isEmpty) {
                                return "Remplissez le champs SVP !";
                              }
    
                              // vérifier qu'il entre seulement un prénom avec le nom
                              if (value.toString().split(" ").length < 2) {
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
                              validator: (value) {
                                // vérification que le champs est remplis
                                if (value == null || value.toString().isEmpty) {
                                  return "Remplissez le champs SVP !";
                                }
                                if (!RegExp(
                                        "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]{2,}?\\.[a-zA-Z]{2,}\$")
                                    .hasMatch(value)) {
                                  if (!RegExp("^[a-zA-Z0-9._%-]{5,}")
                                      .hasMatch(value)) {
                                    return "Entrez au moins 5 caractères avant le '@'";
                                  }
                                  if (!RegExp("^[.]*.[a-zA-Z0-9]{2,}\$")
                                      .hasMatch(value)) {
                                    return "Nom de domaine invalide !";
                                  }
                                  return "Adresse email invalide !";
                                }
                                return null;
                              }),
    
                          // champs du numéro de téléphone
                          customTextField(
                              controller: _telController,
                              prefixIcon: const Icon(Icons.phone_outlined),
                              type: TextInputType.number,
                              label: "Téléphone",
                              placeholder: "Ex: 0011223344",
                              validator: (value) {
                                // vérification que le champs est remplis
                                if (value == null || value.toString().isEmpty) {
                                  return "Remplissez le champs SVP !";
                                }
    
                                if (!RegExp('^[0-9]{10}\$').hasMatch(value)) {
                                  return "Entrez un numéro à 10 chiffres";
                                }
    
                                if (!RegExp("^(01|07|05)").hasMatch(value)) {
                                  return "Le numéro doit commencer par 01, 05 ou 07";
                                }
                                return null;
                              }),
    
                          customTextField(
                              controller: _adressController,
                              prefixIcon:
                                  const Icon(Icons.location_on_outlined),
                              label: "Adresse",
                              placeholder: "Où habitez vous ?",
                              validator: (value) {
                                // vérification que le champs est remplis
                                if (value == null || value.toString().isEmpty) {
                                  return "Remplissez le champs SVP !";
                                }
    
                                return null;
                              }),
    
                          // champs de choix de l'appel du serviteur
                          if (accountType == Type.servant.code)
                          customDropDownField(
                            label: 'Quel est votre appel ?',
                            value: call,
                            onChange: (value) {
                              setState(() {
                                call = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Veuillez choisir un appel !";
                              }
                              return null;
                            },
                            prefixIcon: const Icon(Icons.wb_sunny_outlined),
                            items:
                                List.generate(servantTypes.length, (index) {
                              var current = servantTypes[index];
                              return DropdownMenuItem(
                                  value: current.code,
                                  child: Text(current.name));
                            })
                          ),

                          if (widget.update == null)
                          if (accountType == Type.singer.code)
                          customTextField(
                            controller: _managerController, 
                            prefixIcon: Icon(FontAwesomeIcons.briefcase, size: 20),
                            label: "Nom du manager"
                          ),

                          // description du compte chantre
                          if (widget.update == null)
                          if (accountType == Type.singer.code)
                          customMultilineField(
                            label: "Description",
                            controller: _descriptionController
                          ),
    
                          // champs de mot de passe
                          if (widget.update == null)
                            customTextField(
                                obscureText: !_passwordVisible,
                                controller: _passwordController,
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                    icon: Icon(!_passwordVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined)),
                                label: "Mot de passe",
                                placeholder: "Ex: mot_2_passe",
                                validator: (value) {
                                  // vérification que le champs est remplis
                                  if (value == null ||
                                      value.toString().isEmpty) {
                                    return "Remplissez le champs SVP !";
                                  }
    
                                  if (value.toString().length < 8) {
                                    return "Entrez un mot de passe d'au moins 8 caractères";
                                  }
    
                                  if (!RegExp("[0-9]+").hasMatch(value)) {
                                    return "Le mot de passe doit contenir au moins un chiffre";
                                  }
    
                                  if (!RegExp("[A-Z]+").hasMatch(value)) {
                                    return "Le mot de passe doit contenir au moins une majuscule";
                                  }
    
                                  if (RegExp('[ ]+').hasMatch(value)) {
                                    return "Le mot de passe ne doit pas contenir d'espace";
                                  }
    
                                  return null;
                                }),
    
                          // champs de confirmation de mot de passe
                          if (widget.update == null)
                          customTextField(
                            obscureText: !_confirmPasswordVisible,
                            controller: _confirmPasswordController,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible =
                                        !_confirmPasswordVisible;
                                  });
                                },
                                icon: Icon(!_confirmPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined)),
                            label: "Confirmé le mot de passe",
                            placeholder: "le même mot de passe !",
                            validator: (value) {
                              // vérification que le champs est remplis
                              if (value == null ||
                                  value.toString().isEmpty) {
                                return "Remplissez le champs SVP !";
                              }

                              if (_passwordController.text !=
                                  _confirmPasswordController.text) {
                                return "Les mots de passe ne correspondent pas";
                              }
                              return null;
                            }
                          ),
    
                          // Conditions d'utilisation et politique de confidentialité
                          if (widget.update == null)
                            CheckboxListTile(
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
                                      text:"conditions générales d'utilisation",
                                      style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(color: Colors.green),
                                      recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        pushForm(
                                          context,
                                          destination: CustomWebView(
                                            url: "https://eglisesetserviteursdedieu.com/terms-of-service"
                                          )
                                        );
                                      },
                                    ),
                                    TextSpan(
                                        text: " et la ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge),
                                    TextSpan(
                                      text: "politique de confidentialité",
                                      style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(color: Colors.green),
                                      recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        CustomWebView(url:"https://eglisesetserviteursdedieu.com/privacy-policy");
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
                            text: (widget.update != null && widget.update!)
                                ? "Modifier"
                                : "S'inscrire",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Modification des données
                                if (widget.update != null && widget.update!) {
                                  modifyInformation();
                                  return;
                                }

                                // Vérifier que les terms ont été acceptés avant la création
                                if (terms == false) {
                                  showSnackBar(
                                    context: context,
                                    message: "Acceptez les terms pour continuer !",
                                    type: SnackBarType.warning
                                  );
                                  return;
                                }
                                _startRegistering();
                              } else {
                                showSnackBar(
                                  context: context,
                                  message: "Remplissez correctement le formulaire",
                                  type: SnackBarType.danger
                                );
                              }
                            }
                          )
                        ),
      
                        // lien vers la page de connexion
                        if (widget.update == null) const SizedBox(height: 10),
                        if (widget.update == null)
                          toggleLink(
                              context: context,
                              targetPage: const LoginPage(),
                              label: "Vous avez déjà un compte ?",
                              linkText: "Connectez-vous !")
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget hypertextLink(
      {required BuildContext context, required String text, bool? icon}) {
    return GestureDetector(
        onTap: () {
          // hypertext link
        },
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(text,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Colors.green,
                  )),
          if (icon != null && icon)
            const SizedBox(
              width: 10,
            ),
          if (icon != null && icon) const Icon(Icons.link, color: Colors.green)
        ]));
  }
}
