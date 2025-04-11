import 'dart:io';
import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/camera_functions.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

import '../../providers/testimony.dart';
import '../../providers/user.dart';

class TestimonyForm extends StatefulWidget {
  const TestimonyForm({super.key});

  @override
  State<TestimonyForm> createState() => _TestimonyFormState();
}

class _TestimonyFormState extends State<TestimonyForm> {
  int? meId;

  bool _isLoading = false;
  final recorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  // préécoute
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  PlayerState _playerState = PlayerState.stopped;

  Future<void> _initAudioPlayer() async {
    audioPlayer.onDurationChanged.listen((d) => setState(() => _duration = d));
    audioPlayer.onPositionChanged.listen((p) => setState(() => _position = p));
    audioPlayer.onPlayerStateChanged.listen((s) => setState(() => _playerState = s));
  }

  Future<void> _playAudio() async {
    try{
      if (recordPath != null) {
        await audioPlayer.play(DeviceFileSource(recordPath!));
      }
    } catch(e) {
      showSnackBar(
        context: context,
        message: "Impossible de jouer l'audio",
        type: SnackBarType.danger
      );
    }
  }

  Future<void> _pauseAudio() async {
    await audioPlayer.pause();
  }

  Future<void> _seekAudio(Duration position) async {
    setState(() {
      _position = position;
    });
    await audioPlayer.seek(_position);
  }

  // variable d'enregistrement
  bool _isAnonymous = false;
  String mediaType = 'audio';
  File? media;
  List<String> allowedExtensions = ['mp3', 'm4a', 'ogg'];
  String? recordPath;

  bool isRecording = false;
  bool isPaused = false;

  reinitVars() {
    setState(() {
      isRecording = false;
      isPaused = false;
      recordPath = null;
      media = null;
    });
  }

  // functions
  getTestimonyFromFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio
    );
    if (result != null) {
      setState(() {
        media = File(result.files.single.path!);
      });
    }
  }

  startRecording() async {
    if (await recorder.hasPermission()){
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.mp3';
      await recorder.start(RecordConfig(), path: path);
      isRecording = await recorder.isRecording();
      setState(() {});
    } else {
      showSnackBar(
        context: context,
        message: "Accès au micro refusé",
        type: SnackBarType.danger
      );
    }
  }

  pauseOrUnpauseRecording() async {
    if (isRecording) {
      if (isPaused){
        await recorder.resume();
      } else {
        await recorder.pause();
      }
      setState(() {
        isPaused = !isPaused;
      });
    }
  }

  stopRecording() async {
    isRecording = await recorder.isRecording();
    recordPath = await recorder.stop();
    setState(() {});
  }

  saveRecord() {
    setState(() {
      media = File(recordPath!);
    });
  }

  handleCreation() async {
    if (media == null) {
      return showSnackBar(
        context: context,
        message: "Ajouter le fichier du témoignage",
        type: SnackBarType.warning
      );
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading= true;
      });
      try {
        await Provider.of<Testimony>(context, listen: false).create({
          'title': _titleController.text,
          'is_anonymous': _isAnonymous,
          'media': media!.path,
          'mediaType': mediaType,
          'user_id': meId,
        }).then(
          (value) async {
            Provider.of<Testimony>(context, listen: false).getAll().then(
              (value) => closeForm(context)
            );
            showSnackBar(
              context: context,
              message: "Témoignage enregistré avec succès !",
              type: SnackBarType.success
            );
          }
        );
      } on HttpException catch (e) {
        showSnackBar(
          context: context,
          message: e.message,
          type: SnackBarType.danger
        );
      } on DioException {
        showSnackBar(
          context: context,
          message: "Erreur de connexion. Vérifiez votre connexion internet",
          type: SnackBarType.danger
        );
      } catch(e) {
        showSnackBar(
          context: context,
          message: "Une erreur inattendu s'est produit !",
          type: SnackBarType.danger
        );
        e.printError();
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    meId = Provider.of<User>(context, listen: false).user.id;
  }

  @override
  void dispose() {
    _titleController.dispose();
    recorder.stop();
    recorder.dispose();
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          buildCustomSelector(
                            color: Colors.blue,
                            icon: FontAwesomeIcons.microphone,
                            isSelected: mediaType == 'audio',
                            label: 'Audio',
                            onTap: () => setState(() => mediaType = 'audio'),
                          ),
                          buildCustomSelector(
                            color: Colors.purple,
                            icon: FontAwesomeIcons.video,
                            isSelected: mediaType == 'video',
                            label: 'Vidéo',
                            onTap: () => setState(() => mediaType = 'video')
                          ),
                        ],
                      ),

                      Form(
                        key: _formKey,
                        child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: customTextField(
                          label: "Titre du témoignage",
                          placeholder: "Ajoutez un titre au témoignage",
                          controller: _titleController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir le champ';
                            }
                            return null;
                          }
                        )
                      ),
                      ),
                      CheckboxMenuButton(
                        value: _isAnonymous,
                        onChanged: (value){
                          setState(() {
                            _isAnonymous = value!;
                          });
                        },
                        child: Text('Faire un témoignage anonyme')
                      ),

                      if (recordPath == null && media == null) mediaType == 'audio' ?
                        buildAudioSection() : buildVideoSection(),
                      if (recordPath != null && media == null) buildAudioPlayingSection(),

                      if (media != null) Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Card(
                          elevation: 0,
                          color: Colors.green.withAlpha(70),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: FaIcon(
                                FontAwesomeIcons.file,
                                color: Colors.green
                              ),
                            ),
                            title: Text(
                              media!.path.split('/').last,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.green, fontWeight: FontWeight.bold
                              )
                            ),
                            trailing: IconButton(
                              onPressed: () => reinitVars(),
                              icon: FaIcon(FontAwesomeIcons.xmark),
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(Colors.white),
                                iconColor: WidgetStatePropertyAll(Colors.red),
                                iconSize: WidgetStatePropertyAll(20)
                              ),
                            ),
                          )
                        )
                      ),
                    ],
                  ),
                ),
              ),
              customButton(
                context: context,
                text: "Soumettre le témoignage",
                onPressed: () => handleCreation(),
              ),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAudioPlayingSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Card(
            elevation: 0,
            child: ListTile(
              leading: IconButton(
                onPressed: () async {
                  if (_playerState == PlayerState.paused) {
                    await _playAudio();
                  } else {
                    await _pauseAudio();
                  }
                },
                icon: FaIcon(
                  _playerState != PlayerState.playing ?
                  FontAwesomeIcons.play : FontAwesomeIcons.pause
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.blue),
                  iconColor: WidgetStatePropertyAll(Colors.white),
                  iconSize: WidgetStatePropertyAll(17)
                )
              ),
              title: Slider(
                min: 0,
                max: _duration.inMilliseconds.toDouble(),
                value: _position.inMilliseconds.toDouble(),
                onChanged: (value) {
                  _seekAudio(Duration(milliseconds: value.toInt()));
                }
              ),
              subtitle: Text(
                '${_position.toString().split('.').first} / ${_duration.toString().split('.').first}',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => reinitVars(),
                  icon: FaIcon(FontAwesomeIcons.xmark),
                  style: ButtonStyle(
                    iconColor: WidgetStatePropertyAll(Colors.red),
                    iconSize: WidgetStatePropertyAll(20)
                  ),
                ),
                IconButton(
                  onPressed: () {
                    reinitVars();
                    startRecording();
                  },
                  icon: FaIcon(FontAwesomeIcons.arrowRotateRight),
                  style: ButtonStyle(
                      iconColor: WidgetStatePropertyAll(Colors.amber),
                      iconSize: WidgetStatePropertyAll(18)
                  ),
                ),
                IconButton(
                  onPressed: () => saveRecord(),
                  icon: FaIcon(FontAwesomeIcons.check),
                  style: ButtonStyle(
                      iconColor: WidgetStatePropertyAll(Colors.green),
                      iconSize: WidgetStatePropertyAll(20)
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }

  Widget buildAudioSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10)
            ),
            child: ListTile(
              leading: !isRecording ? InkWell(
                onTap: () => startRecording(),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: FaIcon(
                    FontAwesomeIcons.microphone,
                    size: 17,
                    color: Colors.blue,
                  ),
                ),
              ) :
              IconButton(
                onPressed: () => pauseOrUnpauseRecording(),
                icon: FaIcon(
                  isPaused ? FontAwesomeIcons.play : FontAwesomeIcons.pause,
                  size: 20,
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.white),
                ),
              ),
              title: Text(
                isRecording ? "Enregistrement en cours..."
                : "Enregistrez votre témoignage",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.blue
                ),
              ),
              trailing: isRecording ? IconButton(
                onPressed: () => stopRecording(),
                icon: FaIcon(
                  FontAwesomeIcons.stop,
                  size: 20,
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.white),
                  iconColor: WidgetStatePropertyAll(Colors.red),
                ),
              ) : null
            ),
          ),
          if (! isRecording) Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '- ou -',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.tertiary.withAlpha(150)
              ),
            ),
          ),
          if (! isRecording) Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(10)
            ),
            child: ListTile(
              onTap: () => getTestimonyFromFiles(),
              leading: FaIcon(
                FontAwesomeIcons.download,
                color: Colors.green
              ),
              title: Text(
                "Télécharger un fichier audio",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.green, fontWeight: FontWeight.bold
                )
              ),
              subtitle: Text(
                allowedExtensions.map((e) => e).toString(),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.grey
                )
              )
            )
          )
        ]
      ),
    );
  }

  Widget buildVideoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: BorderRadius.circular(10)
            ),
            child: ListTile(
              onTap: () async {
                var f = await pickVideo(camera: true);
                if (f != null) {
                  setState(() => media = File(f.path));
                }
              },
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: FaIcon(
                  FontAwesomeIcons.video,
                  size: 17,
                  color: Colors.purple,
                ),
              ),
              title: Text(
                "Enregistrer la vidéo de votre témoignage",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.purple
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '- ou -',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary.withAlpha(150)
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(10)
            ),
            child: ListTile(
              onTap: () async {
                var f = await pickVideo();
                if (f != null) {
                  setState(() {media = File(f.path);});
                }
              },
              leading: FaIcon(
                FontAwesomeIcons.download,
                color: Colors.green
              ),
              title: Text(
                "Télécharger un fichier Vidéo",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.green, fontWeight: FontWeight.bold
                )
              ),
            )
          )
        ]
      ),
    );
  }

  Widget buildCustomSelector({
    required Color color,
    required IconData icon,
    required bool isSelected,
    required String label,
    required Function onTap,
  }) {
    Color displayedColor = isSelected ? color : Colors.blueGrey;
    return GestureDetector(
      onTap: () => onTap(),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: displayedColor.withAlpha(20),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 1.5, color: displayedColor),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              color: displayedColor,
              size: 20,
            ),
            if (isSelected) Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: displayedColor, fontWeight: FontWeight.bold
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}