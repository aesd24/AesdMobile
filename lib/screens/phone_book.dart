import 'package:aesd_app/screens/phonebookstabs/church_list.dart';
import 'package:aesd_app/screens/phonebookstabs/servant_list.dart';
import 'package:aesd_app/screens/phonebookstabs/singer_list.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PhoneBook extends StatefulWidget {
  static const String routeName = "/phone_book";

  const PhoneBook({super.key});

  @override
  _PhoneBookState createState() => _PhoneBookState();
}

class _PhoneBookState extends State<PhoneBook> {
  int selectedIndex = 0;
  final Widget _churchScreen = const ChurchList();
  final Widget _servantScreen = const ServantList();
  final Widget _singerScreen = const SingerList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kHeaderColor,
          title: Text(
            "Annuaire: ${getTitle()}",
            style: const TextStyle(
              color: Color(0xffffffff),
            ),
          ),
        ),
        body: getBody(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          selectedIconTheme: const IconThemeData(color: kPrimaryColor),
          selectedItemColor: kPrimaryColor,
          unselectedIconTheme: const IconThemeData(
            color: Colors.black54,
          ),
          unselectedItemColor: Colors.black54,
          backgroundColor: Colors.white10,
          elevation: 0,
          currentIndex: selectedIndex,
          iconSize: 18,
          selectedFontSize: 14,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.church),
              label: "Églises",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userTie),
              label: "Serviteurs",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.music),
              label: "Chantres",
            )
          ],
          onTap: (int index) {
            onTapHandler(index);
          },
        ),
      ),
    );
  }

  Widget getBody() {
    if (selectedIndex == 0) {
      return _churchScreen;
    } else if (selectedIndex == 1) {
      return _servantScreen;
    } else {
      return _singerScreen;
    }
  }

  String getTitle() {
    if (selectedIndex == 0) {
      return "Églises";
    } else if (selectedIndex == 1) {
      return "Serviteurs";
    } else {
      return "Chantres";
    }
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
