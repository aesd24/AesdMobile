import 'package:aesd_app/models/course_deferred_model.dart';
import 'package:aesd_app/screens/give_your_live_screen.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DiferredShow extends StatefulWidget {
  final CourseDeferredModel course;

  const DiferredShow({
    super.key,
    required this.course,
  });

  @override
  _DiferredShowState createState() => _DiferredShowState();
}

class _DiferredShowState extends State<DiferredShow> {
  //late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    /*
    _controller = YoutubePlayerController(
      initialVideoId: widget.course.youtubeId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    */
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              widget.course.title,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            /*
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
             */
            const SizedBox(height: 10),
            Html(data: widget.course.body),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GiveYourLiveScreen(),
            ),
          );
        },
        backgroundColor: kSecondaryColor,
        child: const Icon(FontAwesomeIcons.church),
      ),
    );
  }
}
