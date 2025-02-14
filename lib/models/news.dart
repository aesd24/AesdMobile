import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/screens/actuality/actuality.dart';
import 'package:flutter/material.dart';

class NewsModel {
  late int id;
  late String title;
  late String content;
  late DateTime date;

  NewsModel.fromJson(json) {
    id = json['id'];
    title = json['title'];
    content = json['description'];
    date = DateTime.parse(json['date']);
  }

  Widget getWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => pushForm(context, destination: const NewsPage()),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
            image: AssetImage("assets/news.jpeg"), fit: BoxFit.cover
          )
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [
                Colors.black.withAlpha(127),
                Colors.black.withAlpha(75),
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
          alignment: Alignment.bottomLeft,
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
                content,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Colors.white60),
              )
            ],
          ),
        ),
      ),
    );
  }
}