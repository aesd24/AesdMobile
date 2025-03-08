import 'package:aesd_app/functions/formatteurs.dart';
import 'package:aesd_app/models/event.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.event});

  final EventModel event;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Image.asset("assets/event.jpg", fit: BoxFit.contain),
                  ),
                );
              },
            ),
            icon: const FaIcon(
              FontAwesomeIcons.expand,
              size: 20,
            ),
            iconAlignment: IconAlignment.end,
            label: Text(
              "Affiche",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              iconColor: WidgetStateProperty.all(Colors.white),
              overlayColor: WidgetStateProperty.all(Colors.grey.withAlpha(50))
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Partie de l'image et des titres
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .5,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.event.imageUrl == null ?
                    AssetImage("assets/event.jpg") :
                    NetworkImage(widget.event.imageUrl!),
                  fit: BoxFit.cover
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15))),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.black.withAlpha(200),
                  Colors.black.withAlpha(70)
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.event.description,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Colors.white
                    ),
                  )
                ],
              ),
            ),
          ),

          // Partie du contenu
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                displayingTile(
                  icon: FontAwesomeIcons.person,
                  text: "Organisateur",
                  child: Text(widget.event.organizer)
                ),
                displayingTile(
                  icon: FontAwesomeIcons.solidCalendarDays,
                  text: "Période",
                  child: Row(
                    children: [
                      Text(
                        "Du ${formatDate(widget.event.startDate)} au ${formatDate(widget.event.endDate)}",
                      ),
                    ],
                  ),
                ),
                displayingTile(
                  icon: FontAwesomeIcons.locationPin,
                  text: "Lieu",
                  child: Text(widget.event.location)
                ),
                displayingTile(
                  icon: FontAwesomeIcons.ellipsisVertical,
                  text: "Type et catégorie",
                  child: Text("${widget.event.type}, ${widget.event.category}")
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget displayingTile({
    required IconData icon,
    required String text,
    required Widget child,
  }){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                icon,
                size: 18,
                color: Colors.black
              ),
              SizedBox(width: 10),
              Text(
                text,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold
                )
              ),
            ],
          ),

          child
        ],
      ),
    );
  }

  Widget customIconTitle(IconData icon, String text) {
    return Row(
      children: [
        FaIcon(
          icon,
          size: 18,
          color: Colors.black
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold
          )
        ),
      ],
    );
  }
}
