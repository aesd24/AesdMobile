import 'package:aesd_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TestimonyModel {
  late int id;
  late String title;
  late bool isAnonymous;
  late String mediaType;
  late String mediaUrl;
  late UserModel? user;

  TestimonyModel.fromJson(json) {
    id = json['id'];
    title = json['title'];
    isAnonymous = json['is_anonymous'] == 1;
    mediaUrl = json['media'];
    mediaType = json['mediaType'];
    user = json['user'] == null ? null : UserModel.fromJson(json['user']);
  }

  getWidget(context) {
    Color boxColor = mediaType == 'audio' ? Colors.blue : Colors.purple;
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
            Container(
              margin: EdgeInsets.only(top: 22, bottom: 10),
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                border: Border.all(
                  color: boxColor,
                  width: 1
                ),
                borderRadius: BorderRadius.circular(10),
                color: boxColor.withAlpha(30)
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 18,
                  backgroundColor: boxColor,
                  child: FaIcon(
                    mediaType == 'audio' ?
                    FontAwesomeIcons.music : FontAwesomeIcons.clapperboard,
                    color: Colors.white,
                    size: 15
                  ),
                ),
                title: Text(
                  'Témoignage ${mediaType == 'audio'? 'audio' : 'vidéo'}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: boxColor
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
