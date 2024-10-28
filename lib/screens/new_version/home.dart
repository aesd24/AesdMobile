import 'package:aesd_app/screens/new_version/main/community.dart';
import 'package:aesd_app/screens/new_version/main/front.dart';
import 'package:aesd_app/screens/new_version/main/more.dart';
import 'package:aesd_app/screens/new_version/main/socialHelp.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double appBarOpacity = 0;
  setOpacity(double value) {
    setState(() {
      appBarOpacity = value;
    });
  }

  int _currentPageIndex = 0;
  setPageIndex(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  Color getAppBarColor() {
    if (_currentPageIndex == 0) {
      return appBarOpacity != 1
          ? Colors.green.withOpacity(appBarOpacity)
          : Colors.green;
    }
    return Theme.of(context).colorScheme.surface;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AESD'),
          backgroundColor: getAppBarColor(),
          elevation: 0.0,
          foregroundColor: _currentPageIndex == 0 ? Colors.white : null,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPageIndex,
          onTap: (value) => setPageIndex(value),
          fixedColor: Colors.black,
          unselectedItemColor: Colors.black45,
          items: const [
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.house), label: "home"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.peopleGroup),
                label: "Communauté"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.earListen),
                label: "Aide sociale"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.more_vert,
                  size: 33,
                ),
                label: "Plus")
          ],
        ),
        extendBodyBehindAppBar: _currentPageIndex == 0,
        drawer: const Drawer(),
        body: [
          FrontPage(setOpacity: setOpacity),
          const CommunityPage(),
          const SocialhelpPage(),
          const MorePage(),
        ][_currentPageIndex]);
  }
}
