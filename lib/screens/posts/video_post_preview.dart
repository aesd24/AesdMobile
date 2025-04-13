import 'dart:io';
import 'package:aesd_app/functions/file_functions.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:aesd_app/components/bottom_sheets.dart';
import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/providers/ceremonies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPostPreview extends StatefulWidget {
  VideoPostPreview({super.key, required this.video});

  File video;

  @override
  State<VideoPostPreview> createState() => _VideoPostPreviewState();
}

class _VideoPostPreviewState extends State<VideoPostPreview> {
  List<String> months = [
    "Janvier",
    "Février",
    "Mars",
    "Avril",
    "Mai",
    "Juin",
    "Juillet",
    "Août",
    "Septembre",
    "Octobre",
    "Novembre",
    "Décembre"
  ];
  bool processing = false;
  final _formKey = GlobalKey<FormState>();

  // video controllers
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  // input controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // date de la cérémonie
  DateTime? _date;

  // vidéo
  late File video;

  // soumettre les données
  submit() async {
    if (_formKey.currentState!.validate()) {
      if (_date == null) {
        showSnackBar(
            context: context,
            message: "Veuillez choisir une date",
            type: SnackBarType.warning);
        return;
      }
      try {
        setState(() {
          processing = true;
        });
        var response =
            await Provider.of<Ceremonies>(context, listen: false).create({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'date': _date,
          'video': video.path
        });

        if (response.statusCode == 201) {
          showSnackBar(
              context: context,
              message: "Vidéo posté avec succès !",
              type: SnackBarType.success);
          Navigator.of(context).pop();
        } else {
          showSnackBar(
              context: context,
              message: "Echec de la publication de la vidéo",
              type: SnackBarType.danger);
        }
      } on DioException catch (e) {
        e.printError();
        showSnackBar(
            context: context,
            message: "Vérifiez votre connexion internet et rééssayez",
            type: SnackBarType.warning);
      } catch (e) {
        e.printError();
        showSnackBar(
            context: context,
            message: "Une erreur est survenu !",
            type: SnackBarType.danger);
      } finally {
        setState(() {
          processing = false;
        });
      }
    } else {
      showSnackBar(
          context: context,
          message: "Renseignez correctement le formulaire",
          type: SnackBarType.warning);
    }
  }

  initializeVideoPlayer(File file) async {
    video = file;
    // initialiser le controller du lecteur vidéo
    _videoPlayerController = VideoPlayerController.file(video);
    await _videoPlayerController.initialize();

    // initialiser le container personnalisé
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ],
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        additionalOptions: (context) {
          return <OptionItem>[
            OptionItem(
                onTap: (context) {},
                iconData: Icons.share,
                title: "Partager"),
            OptionItem(
                onTap: (context) {},
                iconData: Icons.info,
                title: "details")
          ];
        });

    setState(() {});
  }

  init() async {
    var result = await verifyVideoSize(widget.video);
    if (!result.isGood) {
      showSnackBar(
          context: context,
          message: "La vidéo est trop grande. taille: ${result.length}Mo",
          type: SnackBarType.warning);
      Navigator.of(context).pop();
      return;
    }
    initializeVideoPlayer(widget.video);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: processing,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Poster une vidéo"),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                customTextField(
                    label: "Titre",
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value!.isEmpty) {
                        return "Le titre est obligatoire";
                      }
                      return null;
                    }),
                customButton(
                    context: context,
                    text: _date == null
                        ? "Ajouter la date de l'évènement"
                        : "Célébration du : ${_date!.day} ${months[_date!.month - 1]} ${_date!.year}",
                    trailing: const Icon(Icons.date_range),
                    border: const BorderSide(width: 2, color: Colors.grey),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    highlightColor: Colors.white,
                    onPressed: () async {
                      // sélectionner une date
                      _date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(
                              DateTime.now().year, DateTime.now().month - 1),
                          lastDate: DateTime.now(),
                          currentDate: DateTime.now());
                      setState(() {});
                    }),
                customMultilineField(
                    label: 'Ajoutez une description à la video (optionnel)',
                    controller: _descriptionController,
                    maxLength: 200,
                    maxLines: 4),
                AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Builder(
                      builder: (context) {
                        if (_chewieController != null) {
                          return Chewie(
                            controller: _chewieController!,
                          );
                        } else {
                          return LinearProgressIndicator(
                            color: Colors.grey.shade300,
                          );
                        }
                      },
                    )),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setVideo(dynamic file) async {
                            File? video = await file;
                            if (video != null) {
                              initializeVideoPlayer(video);
                            }
                          }

                          pickModeSelectionBottomSheet(
                              context: context,
                              setter: setVideo,
                              photo: false,
                              optionnalText:
                                  "La taille de la vidéo ne doit pas excéder 300Mo");
                        },
                        icon: const Icon(Icons.replay),
                        label: const Text("Rééssayer"),
                        iconAlignment: IconAlignment.start,
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.blue),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white),
                            overlayColor:
                                WidgetStateProperty.all(Colors.white12)),
                      ),
                      IconButton(
                        onPressed: () => submit(),
                        icon: const Icon(
                          Icons.send,
                          size: 35,
                        ),
                        style: ButtonStyle(
                            iconColor: WidgetStateProperty.all(Colors.green),
                            overlayColor:
                                WidgetStateProperty.all(Colors.grey.shade300)),
                      )
                    ])
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
