import 'package:aesd_app/functions/formatteurs.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/screens/events/event.dart';
import 'package:flutter/material.dart';

class EventModel {
  late int id;
  late String title;
  late String description;
  late DateTime startDate;
  late DateTime endDate;
  late String location;
  late String? imageUrl;
  late String type;
  late String category;
  late String organizer;
  late int churchId;
  late bool isPublic;

  EventModel.fromJson(json) {
    id = json['id'];
    title = json['titre'];
    description = json['description'];
    startDate = DateTime.parse(json['date_debut']);
    endDate = DateTime.parse(json['date_fin']);
    location = json['lieu'];
    imageUrl = json['file'];
    type = json['type_evenement'];
    category = json['categorie_evenement'];
    organizer = json['organisateur'];
    churchId = json['eglise_id'];
    isPublic = json['est_public'] == 1;
  }

  Widget getWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => pushForm(context, destination: const EventPage()),
      child: Container(
        width: size.width * .9,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: imageUrl == null
                    ? const AssetImage("assets/event.jpg")
                    : NetworkImage(imageUrl!),
                fit: BoxFit.cover)),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.green.withAlpha(180),
                Colors.green.withAlpha(80),
              ]
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Text(
                "Du ${formatDate(startDate)} au ${formatDate(endDate)}",
                style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Colors.white60),
              )
            ],
          ),
        ),
      ),
    );
  }
}
