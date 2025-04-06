import 'dart:io';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/camera_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class TestimonyForm extends StatefulWidget {
  const TestimonyForm({super.key});

  @override
  State<TestimonyForm> createState() => _TestimonyFormState();
}

class _TestimonyFormState extends State<TestimonyForm> {
  final recorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();

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
    if (_audioPath != null) {
      await audioPlayer.play(DeviceFileSource(_audioPath!));
    }
  }

  Future<void> _pauseAudio() async {
    await audioPlayer.pause();
  }

  Future<void> _seekAudio(Duration position) async {
    await audioPlayer.seek(position);
  }

  // variable d'enregistrement
  bool _isAnonymous = false;
  String mediaType = 'audio';
  String obtainingWay = 'record';
  File? media;
  List<String> allowedExtensions = ['mp3', 'm4a', 'ogg'];
  String? recordPath;

  bool isRecording = false;
  bool recordStarted = true;

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
      final path = '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.mp4';
      await recorder.start(RecordConfig(), path: path);
      isRecording = await recorder.isRecording();

      setState(() {
        recordStarted = true;
        obtainingWay = 'record';
      });
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
      if (await recorder.isPaused()){
        await recorder.resume();
      } else {
        await recorder.pause();
      }
    }
  }

  stopRecording() async {
    isRecording = await recorder.isRecording();
    recordPath = await recorder.stop();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faire un témoignage'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          child: Column(
            children: [
              Row(
                children: [
                  mediaTypeSelector(
                    icon: FontAwesomeIcons.microphone,
                    label: "Audio",
                    isSelected: mediaType == "audio",
                    value: 'audio',
                    mainColor: Colors.blue,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.blueAccent,
                        Colors.lightBlue,
                        Colors.lightBlueAccent
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  ),
                  mediaTypeSelector(
                    icon: FontAwesomeIcons.video,
                    label: "video",
                    isSelected: mediaType == "video",
                    value: 'video',
                    mainColor: Colors.purple,
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.purpleAccent,
                        Colors.deepPurple,
                        Colors.deepPurpleAccent
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  )
                ]
              ),
              SizedBox(
                height: 20
              ),
              customTextField(
                label: "Titre du témoignage",
                placeholder: "Choisissez un titre"
              ),
              if(media == null) Container(
                height: 200,
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                child: Row(
                  children: mediaType == 'audio' ? [
                    customColoredBox(
                      color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: !recordStarted ? [
                          IconButton(
                            onPressed: () => startRecording(),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.blue),
                              foregroundColor: WidgetStatePropertyAll(Colors.white),
                              padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 15, horizontal: 20))
                            ),
                            icon: FaIcon(
                              FontAwesomeIcons.microphone, size: 30
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Flexible(
                              child: Text(
                                "Enregistrer mon témoignage",
                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                  color: Colors.blue
                                ),
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ] :
                        [
                          recordPath == null ? Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.solidCircle,
                                color: Colors.red,
                                size: 17
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text("Enregistrement en cours..."),
                              ),
                              IconButton(
                                onPressed: () => pauseOrUnpauseRecording(),
                                icon: FaIcon(FontAwesomeIcons.pause, color: Colors.black),
                              ),
                              IconButton(
                                onPressed: () => stopRecording(),
                                icon: FaIcon(FontAwesomeIcons.stop, color: Colors.red),
                              )
                            ],
                          ) : 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: _playerState == PlayerState.playing
                                  ? _pauseAudio
                                  : _playAudio,
                                icon: FaIcon(_playerState == PlayerState.playing
                                  ? FontAwesomeIcons.pause
                                  : FontAwesomeIcons.play),
                              ),
                              Expanded(
                                child: Slider(
                                  min: 0,
                                  max: _duration.inMilliseconds.toDouble(),
                                  value: _position.inMilliseconds.toDouble(),
                                  onChanged: (value) => _seekAudio(Duration(milliseconds: value.toInt())),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    if (obtainingWay != 'record') customColoredBox(
                      color: Colors.green,
                      child: GestureDetector(
                        onTap: () => getTestimonyFromFiles(),
                        child: Column(
                          children: [
                            Padding(
                              padding:  EdgeInsets.symmetric(vertical: 10),
                              child: FaIcon(
                                FontAwesomeIcons.download, size: 35, color: Colors.green,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Flexible(
                                child: Text(
                                  "Télécharger mon témoignage",
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Colors.green
                                  ),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(bottom: 2),
                              child: Text(
                                "Formats: ${allowedExtensions.map((e) => e).toList()}",
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: Colors.grey
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ] :
                  [
                    customColoredBox(
                      color: Colors.deepPurple,
                      child: GestureDetector(
                        onTap: () async {
                          var file = await pickVideo(camera: true);
                          if (file != null) {
                            setState(() => media = file);
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:  EdgeInsets.symmetric(vertical: 10),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.deepPurple,
                                child: FaIcon(
                                  FontAwesomeIcons.video,
                                  size: 30, 
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Flexible(
                                child: Text(
                                  "Enregistrer mon témoignage",
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Colors.deepPurple
                                  ),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    customColoredBox(
                      color: Colors.green,
                      child: GestureDetector(
                        onTap: () async {
                          var file = await pickVideo();
                          if (file != null) {
                            setState(() {
                              media = file;
                            });
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:  EdgeInsets.symmetric(vertical: 10),
                              child: FaIcon(
                                FontAwesomeIcons.download, size: 45, color: Colors.green,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Flexible(
                                child: Text(
                                  "Téléchargez la vidéo du témoignage",
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Colors.green
                                  ),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]
                ),
              ),
              if(media != null) Builder(
                builder: (context) {
                  String mediaName = media!.path.split('/').last;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Card(
                      elevation: 0,
                      color: Colors.green.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.green)
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: FaIcon(
                            FontAwesomeIcons.check,
                            size: 20,
                            color: Colors.green
                          ),
                        ),
                        title: Text(mediaName),
                        trailing: IconButton(
                          onPressed: () => setState(() => media = null),
                          icon: FaIcon(
                            FontAwesomeIcons.xmark,
                            color: Colors.red,
                            size: 17
                          )
                        ),
                      ),
                    ),
                  );
                }
              ),
              Row(
                children: [
                  Checkbox(
                    value: !_isAnonymous, onChanged: (value) => setState(() {
                      _isAnonymous = !_isAnonymous;
                    })
                  ),
                  Text(
                    "Dévoiler mon identitée",
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customColoredBox({
    required Color color,
    required Widget child
  }) {
    return Expanded(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1.5),
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child
      ),
    );
  }

  Widget mediaTypeSelector({
    required IconData icon,
    required String label,
    required bool isSelected,
    required String value,
    required Color mainColor,
    required LinearGradient gradient
  }) {
    return GestureDetector(
      onTap: () => setState(() {
        mediaType = value;
      }),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: !isSelected ? Colors.blueGrey.withAlpha(50) : mainColor,
          borderRadius: BorderRadius.circular(100),
          gradient: isSelected ? gradient : null
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 20, minHeight: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                size: 17,
                color: isSelected ? Colors.white : Colors.blueGrey
              ),
              if (isSelected) Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold
                  )
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}