import 'dart:io';
import 'package:aesd_app/components/bottom_sheets.dart';
import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/drop_down.dart';
import 'package:aesd_app/components/picture_containers.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/components/text_field.dart';
import 'package:aesd_app/constants/dictionnary.dart';
import 'package:aesd_app/models/church_model.dart';
import 'package:aesd_app/providers/church.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class MainChurchCreationPage extends StatefulWidget {
  MainChurchCreationPage({super.key, this.editMode = false});

  bool editMode;

  @override
  State<MainChurchCreationPage> createState() => _MainChurchCreationPageState();
}

class _MainChurchCreationPageState extends State<MainChurchCreationPage> {
  bool isLoading = false;

  // clé de formulaire
  final _formKey = GlobalKey<FormState>();

  // form controllers
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  // valeur du type d'église
  String? churchType;

  // photo de l'église
  File? _churchImage;
  setChurchImage(dynamic image) async {
    _churchImage = await image;
    setState(() {});
  }

  // fonction de création d'une nouvelle église
  _createChurch() async {
    if (_formKey.currentState!.validate()) {
      if (_churchImage == null) {
        showSnackBar(
            context: context,
            message: "Chargez d'abords une image",
            type: SnackBarType.warning);
        return;
      }

      /* if (await verifyImageSize(_churchImage!)) {
        showSnackBar(
            context: context,
            message: "La taille de votre image ne doit pas dépasser 20Mo",
            type: SnackBarType.warning);
        return;
      } */

      try {
        setState(() {
          isLoading = true;
        });

        await Provider.of<Church>(context, listen: false).create(data: {
          'name': _nameController.text,
          'email': _addressController.text,
          'phone': _contactController.text,
          'location': _locationController.text,
          'description': _descriptionController.text,
          'isMain': 1,
          'churchType': churchType,
          'image': _churchImage
        }).then((response) {
          print(response);
          showSnackBar(
              context: context,
              message: "Enregistrement de l'église réussi",
              type: SnackBarType.success);

          Navigator.of(context).popUntil((route) => route.isFirst);
        });
      } on HttpException catch (e) {
        showSnackBar(
            context: context, message: e.message, type: SnackBarType.danger);
      } on DioException catch (e) {
        e.printError();
        showSnackBar(
            context: context,
            message: "Erreur lors de l'envoi des données",
            type: SnackBarType.danger);
      } catch (e) {
        e.printError();
        showSnackBar(
            context: context,
            message: "Une erreur s'est produite !",
            type: SnackBarType.danger);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  init() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (widget.editMode == true) {
        // obtention de l'église du serviteur
        var result = await Provider.of<Church>(context, listen: false).one();
        ChurchModel church = ChurchModel.fromJson(result.data['church']);

        //mise en place des données dans les champs
        _nameController.text = church.name;
        _addressController.text = church.email;
        _contactController.text = church.phone;
        _descriptionController.text = church.description;
        _locationController.text = church.address;

        for (var type in churchTypes) {
          if (church.type.code == type.code) {
            churchType = type.name;
          }
        }
      }
    } catch (e) {
      e.printError();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool update = widget.editMode;
    return LoadingOverlay(
      isLoading: isLoading,
      color: Colors.black,
      opacity: .3,
      child: Scaffold(
        appBar: AppBar(
            title: Text(update
                ? 'Modifier mon église'
                : 'Créer une église principale')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                pickModeSelectionBottomSheet(
                                    context: context, setter: setChurchImage);
                              },
                              child: customRoundedAvatar(
                                  image: _churchImage,
                                  overlayText:
                                      "Cliquez pour ajoutez une photo")),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              _nameController.text == ""
                                  ? "Renseignez le nom de l'église"
                                  : _nameController.text,
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  // nom de l'église
                  customTextField(
                      label: "Nom de votre église",
                      placeholder: "Ex: AESD",
                      prefixIcon: const Icon(Icons.church_outlined),
                      controller: _nameController,
                      onChanged: (value) {
                        setState(() {});
                      }),

                  // adresse email de l'église
                  customTextField(
                      label: "Adresse email",
                      placeholder: "Ex: AESD@mail.ch",
                      type: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      controller: _addressController),

                  //contact de l'église
                  customTextField(
                      label: "Contact de l'église",
                      placeholder: "Ex: 0122334455",
                      type: TextInputType.number,
                      prefixIcon: const Icon(Icons.phone_outlined),
                      controller: _contactController),

                  // type d'église
                  customDropDownField(
                      prefixIcon: const Icon(Icons.wb_sunny_outlined),
                      label: "Type d'église",
                      placeholder: "Quel est le type de votre église ?",
                      value: churchType,
                      items: List.generate(churchTypes.length, (index) {
                        var current = churchTypes[index];
                        return DropdownMenuItem(
                            value: current.code, child: Text(current.name));
                      }),
                      onChange: (value) {
                        churchType = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Veuillez choisir un type d'église";
                        }
                        return null;
                      }),

                  // localisation de l'église
                  customTextField(
                      label: "Localisation",
                      placeholder: "Ex: Yopougon toit rouge gendarmerie",
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      controller: _locationController),

                  // description de l'église
                  customMultilineField(
                      label: "Description de l'église",
                      controller: _descriptionController,
                      maxLength: 100,
                      validator: (value) {
                        if (value == null || value.toString().isEmpty) {
                          return "Remplissez ce champ !";
                        }
                        if (value.toString().length < 20) {
                          return "Donnez une description un peu plus concrète";
                        }
                        return null;
                      }),

                  // bouton de validation
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: customButton(
                        context: context,
                        text: "Soumettre",
                        onPressed: () => _createChurch()),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
