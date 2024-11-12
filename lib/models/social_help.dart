import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/user_model.dart';
import 'package:aesd_app/screens/new_version/social/social.dart';
import 'package:flutter/material.dart';

class SocialHelpModel {
  late int id;
  late UserModel applicant; // demandeur
  late String title;
  late String description;
  late DateTime date;

  SocialHelpModel.fromJson(json) {
    id = json['id'];
    applicant = UserModel.fromJson(json['applicant']);
    title = json['title'];
    description = json['description'];
    date = DateTime.parse(json['date']);
  }

  getWidget(context) {
    String shortDescription = description;
    if (description.length > 50) {
      shortDescription = '${description.substring(0, 50)}...';
    }
    return GestureDetector(
      onTap: () => pushForm(context, destination: const SocialHelpPage()),
      child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 15),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(applicant.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.grey)),
                Text(
                  "${date.day}-${date.month}-${date.year}",
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                shortDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          )),
    );
  }
}
