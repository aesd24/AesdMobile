import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/models/notification.dart';
import 'package:aesd_app/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NotificationDetail extends StatelessWidget {
  NotificationDetail({super.key, required this.notification});

  NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    // changer le statut de la notification
    notification.readed = false;
    var user = Provider.of<User>(context, listen: false).user;
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            Center(
              child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 7,
                  width: MediaQuery.of(context).size.width / 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.shade800,
                  ),
                  child: const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: FaIcon(FontAwesomeIcons.solidBell),
                  )),
            ),
            const SizedBox(height: 10),
            Center(
                child: Text(
              notification.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            )),
            const SizedBox(height: 70),
            Text("Bonjour, ${user.name}",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      notification.content,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            if (notification.type == "demande")
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Demande éffectué par:",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.green),
                    ),
                    const SizedBox(height: 10),
                    const ListTile(
                      leading: CircleAvatar(),
                      title: Text("Nom du demandeur"),
                      subtitle: Text("jj/mm/AAAA"),
                    )
                  ],
                ),
              ),
            // boutons en cas de demandes
            if (notification.type == "demande")
              Row(
                children: [
                  Expanded(
                      child: customButton(
                          context: context,
                          text: "Accepter",
                          foregroundColor: Colors.green,
                          backgroundColor: Colors.white,
                          onPressed: () {})),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.xmark),
                    style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        backgroundColor: WidgetStateProperty.all(Colors.red)),
                  )
                ],
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Center(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Pour plus d'informations, ",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: Colors.white70)),
                    TextSpan(
                      text: "contactez nous !",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      //onEnter: (event) => pushForm(context, destination: const ContactPage)
                    ),
                  ]),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
