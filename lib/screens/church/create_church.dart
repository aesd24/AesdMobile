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
import 'package:aesd_app/screens/user/dashbord/dashbord.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class CreateChurchPage extends StatefulWidget {
  CreateChurchPage({super.key, this.editMode});

  bool? editMode;

  @override
  State<CreateChurchPage> createState() => _CreateChurchPageState();
}

class _CreateChurchPageState extends State<CreateChurchPage> {
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
    if (_formKey.currentState!.validate()){
      if(_churchImage == null){
        showSnackBar(
          context: context,
          message: "Chargez d'abords une image",
          type: 'warning'
        );
      } else {
        try{
          setState(() {
            isLoading = true;
          });

          await Provider.of<Church>(context, listen: false).create(data: {
            'name': _nameController.text,
            'email': _addressController.text,
            'phone': _contactController.text,
            'location': _locationController.text,
            'description': _descriptionController.text,
            'churchType': churchType,
            'image': _churchImage
          }).then((response){
            if (response.statusCode < 210){
              showSnackBar(
                context: context,
                message: "Enregistrement de l'église réussi",
                type: 'success'
              );

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Dashbord())
              );
            } else if(response.statusCode == 422) {
              showSnackBar(
                context: context,
                message: "Données invalides ou déjà existante !",
                type: 'danger'
              );
            } else {
              showSnackBar(
                context: context,
                message: "L'enregistrement à échoué !",
                type: 'danger'
              );
            }

            //print(response);
          });
        } catch(e) {
          e.printError();
          showSnackBar(
            context: context,
            message: "Une erreur s'est produite !",
            type: 'danger'
          );

          //print(e);
        } finally{
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  init() async {
    try {
      setState(() {isLoading = true;});

      if (widget.editMode == true){
        // obtention de l'église du serviteur
        var result = await Provider.of<Church>(context, listen: false).one();
        ChurchModel church = ChurchModel.fromJson(result.data['church']);

        //mise en place des données dans les champs
        _nameController.text = church.name;
        _addressController.text = church.email;
        _contactController.text = church.phone;
        _descriptionController.text = church.description;
        _locationController.text = church.address;

        for (var type in churchTypes){
          if (church.type.code == type.code){
            churchType = type.name;
          }
        }
      }
    } catch(e){
      e.printError();
    } finally {
      setState(() {isLoading = false;});
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    bool update = widget.editMode ?? false;
    return LoadingOverlay(
      isLoading: isLoading,
      color: Colors.black,
      opacity: .3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(update ? 'Modifier mon église' : 'Créer une église')
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            onTap: (){
                              pickModeSelectionBottomSheet(
                                context: context,
                                setter: setChurchImage
                              );
                            },
                            child: customRoundedAvatar(
                              image: _churchImage,
                              overlayText: "Cliquez pour ajoutez une photo"
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              _nameController.text == "" ? "Renseignez le nom de l'église" : _nameController.text,
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
                    onChanged: (value){
                      setState(() {});
                    }
                  ),
                  
                  // adresse email de l'église
                  customTextField(
                    label: "Adresse email",
                    placeholder: "Ex: AESD@mail.ch",
                    type: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    controller: _addressController
                  ),
        
                  //contact de l'église
                  customTextField(
                    label: "Contact de l'église",
                    placeholder: "Ex: 0122334455",
                    type: TextInputType.number,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    controller: _contactController
                  ),
        
                  // type d'église
                  customDropDownField(
                    prefixIcon: const Icon(Icons.wb_sunny_outlined),
                    label: "Type d'église",
                    placeholder: "Quel est le type de votre église ?",
                    value: churchType,
                    items: List.generate(churchTypes.length, (index){
                      return churchTypes[index].toMap();
                    }),
                    onChange: (value){
                      churchType = value;
                    },
                    validator: (value){
                      if(value == null){
                        return "Veuillez choisir un type d'église";
                      }
                      return null;
                    }
                  ),
        
                  // localisation de l'église
                  customTextField(
                    label: "Localisation",
                    placeholder: "Ex: Yopougon toit rouge gendarmerie",
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    controller: _locationController
                  ),
        
                  // description de l'église
                  customMultilineField(
                    label: "Description de l'église",
                    controller: _descriptionController
                  ),
        
                  // bouton de validation
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: customButton(
                      context: context,
                      text: "Soumettre",
                      onPressed: () => _createChurch()
                    ),
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