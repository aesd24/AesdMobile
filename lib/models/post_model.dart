import 'package:aesd_app/models/category.dart';
import 'package:intl/intl.dart';

class PostModel {
  late String title;
  late String body;
  late String shortBody;
  late String image;
  late String date;
  List<Category> categories = [];

  PostModel();

  PostModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    image = json['image_url'];
    shortBody = json['short_body'];

    DateTime dateTime = DateTime.parse(json['created_at']);
    date = DateFormat('d MMM yyyy à HH:mm').format(dateTime);

    json['categories'].forEach((category) {
      categories.add(Category.fromJson(category));
    });
  }
}
