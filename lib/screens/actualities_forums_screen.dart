import 'package:aesd_app/screens/forum_list.dart';
import 'package:aesd_app/screens/post_list.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';

class ActualitiesForumsScreen extends StatefulWidget {
  static const String routeName = "/actualities_forums";

  const ActualitiesForumsScreen({super.key});

  @override
  _ActualitiesForumsScreenState createState() =>
      _ActualitiesForumsScreenState();
}

class _ActualitiesForumsScreenState extends State<ActualitiesForumsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Actualités & forums"),
          bottom: const TabBar(
            indicatorColor: kSecondaryColor,
            labelColor: kSecondaryColor,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(text: "Actualités"),
              Tab(text: "Forums"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PostList(),
            ForumList(),
          ],
        ),
      ),
    );
  }
}
