import 'package:aesd_app/models/stream_model.dart';
import 'package:aesd_app/models/stream_video_model.dart';
//import 'package:aesd_app/screens/courses/stream_agora_show.dart';
import 'package:aesd_app/screens/courses/stream_show.dart';
import 'package:flutter/material.dart';

class StreamListItem extends StatelessWidget {
  final StreamModel stream;

  const StreamListItem({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          Text(
            stream.date,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            children: [
              for (var video in stream.videos) videoWidget(context, video)
            ],
          ),
        ],
      ),
    );
  }

  videoWidget(context, StreamVideoModel video) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StreamShow(
              video: video,
            )
          ),
        );
      },
      child: Container(
        height: 130,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(4, 6), // Shadow position
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                width: MediaQuery.of(context).size.width - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      video.title,
                      style: const TextStyle(color: Colors.black87, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        /*Image.asset(
                          "assets/location.png",
                          height: 12,
                        ),*/
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          video.ownerName,
                          style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 11,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        /*Image.asset(
                          "assets/location.png",
                          height: 12,
                        ),*/
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          video.dateTime,
                          style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 11,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              child: Image.network(
                video.image,
                height: 130,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
