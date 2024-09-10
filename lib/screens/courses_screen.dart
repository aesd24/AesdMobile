import 'package:aesd_app/screens/courses/stream_list.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';

import 'courses/deferred_list.dart';

class CoursesScreen extends StatefulWidget {
  static const String routeName = "/courses";

  const CoursesScreen({super.key});

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Cours biblique"),
            bottom: const TabBar(
              indicatorColor: kSecondaryColor,
              labelColor: kSecondaryColor,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(text: "Différé"),
                Tab(text: "En direct"),
              ],
            ),
          ),
          body: const TabBarView(
              children: [
                CourseDeferredList(),
                StreamList(onlyFollower: false),
              ],
            ),
          ),
    );
  }
}
