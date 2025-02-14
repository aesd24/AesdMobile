import 'dart:ui';
import 'package:aesd_app/components/section.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/event.dart';
import 'package:aesd_app/models/news.dart';
import 'package:aesd_app/screens/actuality/actualities.dart';
import 'package:aesd_app/screens/church/choose_church.dart';
import 'package:aesd_app/screens/church/detail.dart';
import 'package:aesd_app/screens/events/events.dart';
import 'package:aesd_app/screens/forum/list.dart';
import 'package:aesd_app/screens/quiz/list.dart';
import 'package:aesd_app/screens/testimony/testimonies.dart';
import 'package:flutter/material.dart';

class FrontPage extends StatefulWidget {
  FrontPage({super.key, required this.userChurch, required this.setOpacity});

  var userChurch;
  Function(double) setOpacity;

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  final _scrollController = ScrollController();

  final events = List.generate(0, (index) {
    return EventModel.fromJson({
      "id": index,
      "title": "Event $index",
      "date": "2024-02-14 14:00",
    });
  });

  final news = List.generate(0, (index) {
    return NewsModel.fromJson({
      "id": index,
      "title": "News $index",
      "content": "This is the content of news $index.",
      "date": "2024-02-15 14:00",
    });
  });

  @override
  void initState() {
    _scrollController.addListener(() {
      setState(() {
        widget.setOpacity(_scrollController.offset < 155
            ? _scrollController.offset / 155
            : 1);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: size.height * .45,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/welcome.jpg"),
                        fit: BoxFit.cover)),
              ),

              // Sections des boutons de navigation (flou)
              Positioned(
                  left: size.width * .05,
                  bottom: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 10, sigmaY: 10, tileMode: TileMode.mirror),
                      child: Container(
                        height: 90,
                        width: size.width * .9,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                customNavItem(
                                    iconUrl: "assets/icons/quiz.png",
                                    text: "Quiz",
                                    onTap: () => pushForm(context,
                                        destination: const QuizzesList())),
                                customNavItem(
                                    iconUrl: "assets/icons/church.png",
                                    text: "Mon église",
                                    onTap: () => pushForm(context,
                                        destination: widget.userChurch != null
                                            ? ChurchDetailPage(
                                                church: widget.userChurch,
                                              )
                                            : const ChooseChurch())),
                                customNavItem(
                                    iconUrl: "assets/icons/forum.png",
                                    text: "Forum",
                                    onTap: () => pushForm(context,
                                        destination: const ForumMain())),
                                customNavItem(
                                    iconUrl: "assets/icons/share.png",
                                    text: "Témoignage",
                                    onTap: () => pushForm(context,
                                        destination: const TestimoniesList()))
                              ]),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                customSection(context,
                  title: "Evènements",
                  viewAllPage: const AllEvents(),
                  children: List.generate(events.length, (index) {
                    var current = events[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: current.getWidget(context)
                    );
                  })
                ),

                customSection(context,
                  scrollDirection: Axis.vertical,
                  title: "Actualités",
                  viewAllPage: const AllActualities(),
                  children: List.generate(news.length, (index) {
                    var current = news[index];
                    return current.getWidget(context);
                  })
                )
            ]),
          )
        ],
      ),
    );
  }

  Widget customNavItem({
    required String iconUrl,
    required String text,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            iconUrl,
            height: 40,
            width: 40,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
