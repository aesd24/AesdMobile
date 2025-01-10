import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/screens/new_version/events/event.dart';
import 'package:flutter/material.dart';

class EventModel {
  late int id;
  late String title;
  late String? imageUrl;
  late DateTime date;

  EventModel.fromJson(json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['image_url'];
    date = json['date'];
  }

  Widget getWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => pushForm(context, destination: const EventPage()),
      child: Container(
        width: double.infinity,
        height: 170,
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
                    Colors.green.withOpacity(.7),
                    Colors.green.withOpacity(.3),
                  ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "${date.day}/${date.month}/${date.year}",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Colors.white60),
              )
            ],
          ),
        ),
      ),
    );
  }
}
