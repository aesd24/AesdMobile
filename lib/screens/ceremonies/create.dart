import 'dart:io';

import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/camera_functions.dart';
import 'package:aesd_app/models/ceremony.dart';
import 'package:aesd_app/providers/ceremonies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class CreateCeremony extends StatefulWidget {
  const CreateCeremony({
    super.key,
    required this.churchId,
    this.ceremony,
    this.editMode = false,
  });

  final int churchId;
  final CeremonyModel? ceremony;
  final bool editMode;


  @override
  State<CreateCeremony> createState() => _CreateCeremonyState();
}

class _CreateCeremonyState extends State<CreateCeremony> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // data
  File? movie;
  DateTime? date;

  // controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  init() async {
    if (widget.editMode) {
      _titleController.text = widget.ceremony!.title;
      _descriptionController.text = widget.ceremony!.description;
      date = widget.ceremony!.date;
      movie = File.fromUri(Uri.parse(widget.ceremony!.video));
    }
  }

  @override
  initState(){
    init();
    super.initState();
  }

  // functions
  handleSubmit() async {
    // vérifications
    if (date == null) {
      showSnackBar(
        context: context,
        message: "Choisissez une date pour la cérémonie",
        type: SnackBarType.warning
      );
      return;
    }
    if (movie == null){
      showSnackBar(
        context: context,
        message: "Sélectionnez d'abord un fichier média",
        type: SnackBarType.warning
      );
      return;
    }
    if (! _formKey.currentState!.validate()) {
      showSnackBar(
        context: context,
        message: "Remplissez correctement les champs",
        type: SnackBarType.danger
      );
      return;
    }

    // Effectuer la création
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Ceremonies>(context, listen: false).create({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': date!,
        'movie': movie!.path,
        "church_id": widget.churchId
      }).then((value) {
        showSnackBar(
          context: context,
          message: "Cérémonie créé avec succès",
          type: SnackBarType.success
        );
        Provider.of<Ceremonies>(context, listen: false).all(
          churchId: widget.churchId
        );
      });
    } on HttpException catch(e) {
      showSnackBar(
        context: context,
        message: e.message,
        type: SnackBarType.danger
      );
    } on DioException catch(e) {
      e.printError();
      showSnackBar(
        context: context,
        message: "Erreur réseau. Vérifiez votre connexion internet et rééssayez...",
        type: SnackBarType.danger
      );
    } catch (e) {
      e.printError();
      showSnackBar(
        context: context,
        message: "Une erreur inattendue est survenue",
        type: SnackBarType.danger
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Création de cérémonie"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  customTextField(
                    prefixIcon: Icon(
                      FontAwesomeIcons.church,
                      size: 20,
                      color: Colors.grey
                    ),
                    controller: _titleController,
                    label: "Titre",
                    placeholder: "Titre de la cérémonie",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Ce champs est obligatoire";
                      }
                      return null;
                    }
                  ),
                  
                  customDateField(
                    label: "Date de la cérémonie",
                    lastDate: DateTime.now(),
                    value: date,
                    onChanged: (value) => setState(() => date = value)
                  ),
              
                  customMultilineField(
                    label: "Descrivez la cérémonie...",
                    controller: _descriptionController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Ce champs est obligatoire";
                      }
                      return null;
                    }
                  ),
              
                  InkWell(
                    onTap: () async {
                      File? file = await pickVideo();
                      if (file != null) {  
                        setState(() => movie = file);
                        showSnackBar(
                          context: context,
                          message: "Vidéo chargé avec succès !",
                          type: SnackBarType.success
                        );
                      } else {
                        showSnackBar(
                          context: context,
                          message: "Echec du chargement de la vidéo",
                          type: SnackBarType.danger
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: movie != null ? Colors.green : Colors.grey
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            movie != null ? Icons.check_circle : Icons.movie,
                            size: 80,
                            color: movie != null ? Colors.green : Colors.grey
                          ),
                          SizedBox(height: 10),
                          Text(
                            movie != null ?
                            "Vidéo chargé" :
                            "Chargez le film de la cérémonie",
                            style: TextStyle(
                              color: movie != null ? Colors.green : null
                            ),
                          )
                        ],
                      )
                    ),
                  ),
              
                  SizedBox(height: 10),
              
                  customButton(
                    context: context,
                    text: "Valider",
                    onPressed: () async => await handleSubmit()
                  )
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}