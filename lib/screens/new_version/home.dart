import 'package:aesd_app/components/menu_drawer.dart';
import 'package:aesd_app/providers/user.dart';
import 'package:aesd_app/screens/new_version/posts/community.dart';
import 'package:aesd_app/screens/new_version/front.dart';
import 'package:aesd_app/screens/new_version/social/social_demandes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

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

  init() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<User>(context, listen: false).getUserData();
    } catch (e) {
      e.printError();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
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
            ],
          ),
          extendBodyBehindAppBar: _currentPageIndex == 0,
          drawer: MenuDrawer(
            pageIndex: 0,
          ),
          body: [
            FrontPage(setOpacity: setOpacity),
            const CommunityPage(),
            const SocialDemandes(),
          ][_currentPageIndex]),
    );
  }
}
