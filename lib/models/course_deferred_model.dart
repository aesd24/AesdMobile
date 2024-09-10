import 'package:intl/intl.dart';

import 'category.dart';

class CourseDeferredModel {
  late String title;
  late String body;
  late String shortBody;
  late String image;
  late String date;
  late List<Category> categories = [];
  late String youtubeUrl;
  late String youtubeId;

  CourseDeferredModel();

  CourseDeferredModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    image = json['image_url'];
    shortBody = json['short_body'];
    DateTime dateTime = DateTime.parse(json['created_at']);
    date = DateFormat('d MMM yyyy à HH:mm').format(dateTime);
    //youtubeUrl = 'https://www.youtube.com/watch?v=' + json['youtube_video_id'];
    //youtubeId = json['youtube_video_id'];

    /*json['categories'].foreach((category) {
      categories.add(category);
    });*/
  }
}
