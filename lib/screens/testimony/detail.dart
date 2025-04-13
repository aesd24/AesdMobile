import 'package:aesd_app/functions/formatteurs.dart';
import 'package:aesd_app/models/testimony.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

import '../../components/snack_bar.dart';

class TestimonyDetail extends StatefulWidget {
  const TestimonyDetail({super.key, required this.testimony});

  final TestimonyModel testimony;

  @override
  State<TestimonyDetail> createState() => _TestimonyDetailState();
}

class _TestimonyDetailState extends State<TestimonyDetail> {
  // la video
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  initializeVideoPlayer() {
    // initialisation du controller de vidéo
    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.testimony.mediaUrl)
    )..initialize();

    // initialisation du conteneur de vidéo personnalisé
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ],
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
    );
  }

  // l'audio
  final AudioPlayer audioPlayer = AudioPlayer();

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
      await audioPlayer.play(DeviceFileSource(
        widget.testimony.mediaUrl
      ));
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

  initialize() {
    try {
      if (widget.testimony.mediaType.toLowerCase() == 'video') {
        initializeVideoPlayer();
      } else {
        _initAudioPlayer();
      }
    } catch (e) {
      //
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    if (widget.testimony.mediaType == 'video') {
      _videoPlayerController.dispose();
      _chewieController?.dispose();
    } else {
      audioPlayer.stop();
      print("Musique arreté");
      audioPlayer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(formatDate(widget.testimony.date)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Titre',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(100)
              )
            ),
            Text(
              widget.testimony.title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: widget.testimony.user != null ? Row(
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundImage: widget.testimony.user?.photo != null ?
                      NetworkImage(widget.testimony.user!.photo!) : null
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.testimony.user!.name,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ) : null,
            ),
            if (widget.testimony.mediaType.toLowerCase() == 'audio')
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: BorderRadius.circular(10)
              ),
              child: ListTile(
                leading: IconButton(
                    onPressed: _playerState == PlayerState.playing
                        ? _pauseAudio
                        : _playAudio,
                    icon: FaIcon(_playerState == PlayerState.playing
                        ? FontAwesomeIcons.pause
                        : FontAwesomeIcons.play,
                      size: 20
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                      iconColor: WidgetStatePropertyAll(Colors.white),
                    )
                ),
                title: Slider(
                  min: 0,
                  max: _duration.inMilliseconds.toDouble(),
                  value: _position.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    _seekAudio(Duration(milliseconds: value.toInt()));
                  },
                  activeColor: Colors.blueGrey,
                  inactiveColor: Colors.blueGrey.shade200,
                  thumbColor: Colors.blue,
                ),
                subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _position.toString().split('.').first,
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      Text(' / '),
                      Text(
                        _duration.toString().split('.').first,
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    ]
                ),
              ),
            ),

            SizedBox(height: 20),

            if(widget.testimony.mediaType.toLowerCase() == 'video')
            _chewieController != null ?
            SizedBox(
              height: size.height * .3,
              width: size.width,
              child: Chewie(controller: _chewieController!),
            ) : Center(
              child: Text("La vidéo n'est pas disponible !")
            ),
          ]
        ),
      ),
    );
  }
}
