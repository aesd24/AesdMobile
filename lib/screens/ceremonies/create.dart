import 'dart:io';

import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/dialog.dart';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/camera_functions.dart';
import 'package:aesd_app/functions/file_functions.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/ceremony.dart';
import 'package:aesd_app/providers/ceremonies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class CeremonyForm extends StatefulWidget {
  const CeremonyForm({
    super.key,
    required this.churchId,
    this.ceremony,
    this.editMode = false
  });

  final int churchId;
  final CeremonyModel? ceremony;
  final bool editMode;

  @override
  State<CeremonyForm> createState() => _CeremonyFormState();
}

class _CeremonyFormState extends State<CeremonyForm> {
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
    }
  }

  @override
  initState(){
    super.initState();
    init();
  }

  // functions
  handleSubmit() async {
    if (! _formKey.currentState!.validate()) {
      showSnackBar(
        context: context,
        message: "Remplissez correctement les champs",
        type: SnackBarType.danger
      );
      return;
    }

    // vérifications
    if (date == null) {
      showSnackBar(
        context: context,
        message: "Choisissez une date pour la cérémonie",
        type: SnackBarType.warning
      );
      return;
    }
    if (! widget.editMode){
      if ( movie == null){
        showSnackBar(
          context: context,
          message: "Sélectionnez d'abord un fichier média",
          type: SnackBarType.warning
        );
        return;
      }
    }
    
    // vérification de la taille de la vidéo
    if (movie != null) {
      var result = await verifyVideoSize(movie!);
      if (!result.isGood) {
        showSnackBar(
          context: context,
          message: "Le fichier est trop volumineux: ${result.length} MB",
          type: SnackBarType.danger
        );
        return;
      }
    }

    messageBox(
      context,
      title: "Avertissement",
      content: Text("Le chargement pourrait prendre du temps à cause de la taille du fichier."),
      actions: [
        TextButton(
          onPressed: () => closeForm(context),
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.grey),
          ),
          child: Text("Annuler"),
        ),
        TextButton.icon(
          onPressed: () async {
            closeForm(context);
            !widget.editMode ? await createCeremony() : await updateCeremony();
          },
          icon: FaIcon(FontAwesomeIcons.check),
          iconAlignment: IconAlignment.end,
          label: Text("Ok"),
        )
      ]
    );
  }

  updateCeremony() async {
    // Effectuer la création
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Ceremonies>(context, listen: false).update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': date!,
        'movie': movie?.path,
        "church_id": widget.churchId
      }, id: widget.ceremony!.id).then((value) async {
        await Provider.of<Ceremonies>(context, listen: false).all(
          churchId: widget.churchId
        );
        showSnackBar(
          context: context,
          message: value['message'],
          type: SnackBarType.success
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

  createCeremony() async {
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
            child: Column(
              children: [
                Expanded(
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
                                  color: movie == null ? Colors.grey : Colors.green
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    movie == null ? Icons.movie : Icons.check_circle,
                                    size: 80,
                                    color: movie == null ? Colors.grey : Colors.green
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    movie == null ?
                                    "Chargez le film de la cérémonie ${widget.editMode ? "(optionnel)" : ""}":
                                    "Vidéo chargé"
                                  )
                                ],
                              )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Ajoutez une vidéo de moins de 300 Mo",
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: Colors.grey
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                customButton(
                  context: context,
                  text: "Valider",
                  onPressed: () async => await handleSubmit()
                ),
                SizedBox(height: 10)
              ],
            )
          ),
        ),
      ),
    );
  }
}