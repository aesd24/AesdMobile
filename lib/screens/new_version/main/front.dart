import 'dart:ui';
import 'package:aesd_app/components/event.dart';
import 'package:aesd_app/components/section.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/screens/new_version/church/main.dart';
import 'package:aesd_app/screens/new_version/forum/list.dart';
import 'package:aesd_app/screens/new_version/quiz/list.dart';
import 'package:flutter/material.dart';

class FrontPage extends StatefulWidget {
  FrontPage({super.key, required this.setOpacity});

  Function(double) setOpacity;

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  final _scrollController = ScrollController();

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
                                        destination: const ChurchMainPage())),
                                customNavItem(
                                    iconUrl: "assets/icons/forum.png",
                                    text: "Forum",
                                    onTap: () => pushForm(context,
                                        destination: const ForumMain())),
                              ]),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              customSection(context,
                  title: "Evènements",
                  children: List.generate(5, (index) {
                    return customEventBox(
                      context,
                      title: "Evènement $index",
                      date: "jj/mm/AAAA",
                    );
                  })),
              customSection(context,
                  scrollDirection: Axis.vertical,
                  title: "Actualités",
                  children: List.generate(5, (index) {
                    return customNewsBox(
                      title: "Titre de l'actualité $index",
                      description: "Description de l'actualité $index",
                    );
                  }))
            ]),
          )
        ],
      ),
    );
  }

  Widget customNewsBox({
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
              image: AssetImage("assets/news.jpeg"), fit: BoxFit.cover)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              Colors.black.withOpacity(0.5),
              Colors.black.withOpacity(0.2),
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
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              description,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Colors.white60),
            )
          ],
        ),
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
