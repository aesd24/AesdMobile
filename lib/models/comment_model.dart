import 'package:aesd_app/utils/extensions.dart';
import 'package:intl/intl.dart';

class Comment {
  late String comment;
  late String date;
  late String userName;
  late String userPhoto;

  Comment();

  Comment.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    DateTime dateTime = DateTime.parse(json['created_at']);
    date = dateTime.isToday()
        ? DateFormat('HH:mm').format(dateTime)
        : DateFormat('d MMM').format(dateTime);
    userName = json['commentator']['name'];
    userPhoto = json['commentator']['profile_photo_path'];
  }
}
