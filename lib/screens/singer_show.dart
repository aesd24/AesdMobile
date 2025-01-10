import 'package:aesd_app/models/singer_model.dart';
import 'package:flutter/material.dart';

class SingerShow extends StatefulWidget {
  final SingerModel singer;

  const SingerShow({super.key, required this.singer});

  @override
  _SingerShowState createState() => _SingerShowState();
}

class _SingerShowState extends State<SingerShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Chantres'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          /*ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {},
          ),*/
          Center(
            child: Stack(
              children: [
                ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: Ink.image(
                      image: NetworkImage(widget.singer.user.photo!),
                      fit: BoxFit.cover,
                      width: 128,
                      height: 128,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              Text(
                widget.singer.user.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(
                'Manager: ${widget.singer.managerName}',
                style: const TextStyle(color: Colors.grey),
              )
            ],
          ),
          const SizedBox(height: 48),
          buildAbout(widget.singer),
        ],
      ),
    );
  }

  Widget buildAbout(SingerModel singer) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Téléphone: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  singer.phone,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text(
                  'Émail: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  singer.user.email,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              indent: 10.0,
              endIndent: 20.0,
              thickness: 1,
            ),
            const Text(
              'A propos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              singer.description,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
