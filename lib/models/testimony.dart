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
    String content = body.length > 100 ? '${body.substring(0, 100)}...' : body;
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(7),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            user != null ? Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(user!.photo!)
                ),
                SizedBox(width: 5),
                Text(user!.name),
              ],
            ) : Text(
              "Anonyme",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontStyle: FontStyle.italic
              ),
            ),
            SizedBox(height: 20),
            Text(
              content,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.grey.shade600
              )
            ),
          ],
        ),
      ),
    );
  }
}
