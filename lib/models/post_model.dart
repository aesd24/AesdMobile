import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/category.dart';
import 'package:aesd_app/screens/posts/single_post.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class PostModel {
  late int id;
  late String title;
  late String content;
  late String body;
  late String shortBody;
  late String? image;
  late String author;
  late String date;
  List<Category> categories = [];
  bool liked = false;
  late List comments;
  late int likes;
  //DateTime date = DateTime.now();

  PostModel();

  PostModel.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    body = json['body'] ?? "";
    image = json['image_url'];
    shortBody = json['short_body'] ?? "";

    //DateTime dateTime = DateTime.parse(json['created_at']);
    DateTime dateTime = DateTime.now();
    date = DateFormat('d MMM yyyy à HH:mm').format(dateTime);

    /* json['categories'].forEach((category) {
      categories.add(Category.fromJson(category));
    }); */

    id = json['id'];
    content = json['content'];
    author = json['author'];
    liked = json['liked'];
    comments = json['comments'];
    likes = json['likes'];
  }

  getWidget(
    BuildContext context, {
    required void Function() stateNotifier,
  }) {
    return GestureDetector(
      onTap: () => pushForm(context,
          destination: SinglePost(
            post: this,
          )),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey, width: 1),
                top: BorderSide(color: Colors.grey, width: 1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(),
                    const SizedBox(width: 10),
                    Text(author, style: Theme.of(context).textTheme.titleMedium)
                  ],
                ),
                Text(
                  date,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.grey),
                )
              ],
            ),

            // Contenu du post
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            // Image contenu dans le post
            if (image != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(7))),
              ),

            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 20),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      liked = !liked;
                      liked ? likes++ : likes--;
                      stateNotifier();
                    },
                    icon: FaIcon(
                      liked
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: liked ? Colors.red : Colors.black,
                    ),
                    label: Text("$likes likes"),
                    style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(Colors.black),
                        overlayColor:
                            WidgetStateProperty.all(Colors.grey.shade200)),
                  ),
                  const SizedBox(width: 50),
                  TextButton.icon(
                    onPressed: () => pushForm(context,
                        destination:
                            SinglePost(post: this, isCommenting: true)),
                    icon: const FaIcon(
                      FontAwesomeIcons.comment,
                    ),
                    label: Text("${comments.length} commentaires"),
                    style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(Colors.black),
                        overlayColor:
                            WidgetStateProperty.all(Colors.grey.shade200)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
