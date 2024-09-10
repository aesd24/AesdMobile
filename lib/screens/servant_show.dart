import 'package:aesd_app/models/servant_model.dart';
import 'package:aesd_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class ServantShow extends StatefulWidget {
  final ServantModel servant;

  const ServantShow({super.key, required this.servant});

  @override
  _ServantShowState createState() => _ServantShowState();
}

class _ServantShowState extends State<ServantShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Serviteurs de Dieu'),
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
                      image: NetworkImage(widget.servant.user.photo),
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
          buildName(widget.servant),
          const SizedBox(height: 24),
          // Center(child: buildUpgradeButton()),
          // const SizedBox(height: 24),
          //NumbersWidget(),
          const SizedBox(height: 48),
          buildAbout(widget.servant),
        ],
      ),
    );
  }

  Widget buildName(ServantModel servant) => Column(
        children: [
          Text(
            servant.user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            servant.title.description,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Envoyer un message',
        onClicked: () {},
      );

  Widget buildAbout(ServantModel servant) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Église: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Expanded(
                  child: Text(
                    servant.church.name,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
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
                  servant.phone,
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
                  servant.user.email,
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
              servant.description,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
