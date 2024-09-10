import 'package:aesd_app/models/category.dart';
import 'package:aesd_app/models/comment_model.dart';
import 'package:intl/intl.dart';

class ForumModel {
  late String title;
  late String slug;
  late String body;
  late String date;
  late int commentCount;
  List<Category> categories = [];
  List<Comment> comments = [];

  ForumModel();

  ForumModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    slug = json['slug'];
    body = json['body'];
    commentCount = json['comments_count'];

    DateTime dateTime = DateTime.parse(json['created_at']);
    date = DateFormat('d MMM yyyy').format(dateTime);

    json['categories'].forEach((category) {
      categories.add(Category.fromJson(category));
    });

    json['comments'].forEach((comment) {
      comments.add(Comment.fromJson(comment));
    });
  }
}
