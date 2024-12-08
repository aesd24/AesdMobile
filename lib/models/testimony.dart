import 'package:aesd_app/models/user_model.dart';
import 'package:flutter/material.dart';

class TestimonyModel {
  late int id;
  late String title;
  late String body;
  late bool isAnonymous;
  late UserModel? user;

  TestimonyModel.fromJson(json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    isAnonymous = json['isAnonymous'];
    user = json['user'] == null ? null : UserModel.fromJson(json['user']);
  }

  getWidget(context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "Témoignage de: ${user == null ? "Anonymous" : user!.name}",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.black87),
          )
        ],
      ),
    );
  }
}
