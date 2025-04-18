import 'dart:io';
import 'package:aesd_app/components/dialog.dart';
import 'package:aesd_app/components/menu_drawer.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/user_model.dart';
import 'package:aesd_app/providers/user.dart';
import 'package:aesd_app/screens/auth/login.dart';
import 'package:aesd_app/screens/posts/community.dart';
import 'package:aesd_app/screens/home/front.dart';
import 'package:aesd_app/screens/posts/create_post.dart';
import 'package:aesd_app/screens/user/profil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  UserModel? user;

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
      user = Provider.of<User>(context, listen: false).user;
    } on HttpException catch (e) {
      showSnackBar(context: context, message: e.message, type: SnackBarType.danger);
      messageBox(
        context,
        title: "Echec de l'opération",
        isDismissable: false,
        content: const Text(
            "Impossible de récupérer l'utilisateur connecté'. Veuillez vous reconnecter."),
        onOk: () => pushReplaceForm(context, destination: const LoginPage()),
      );
    } on DioException {
      messageBox(
        context,
        icon: const Icon(
          Icons.signal_wifi_connected_no_internet_4_rounded,
          color: Colors.red,
        ),
        title: "Erreur réseau !",
        isDismissable: false,
        content:
            const Text("Aucune connexion internet. Rééssayer plus tard !."),
        actions: [
          TextButton.icon(
            onPressed: () => SystemNavigator.pop(),
            iconAlignment: IconAlignment.end,
            icon: const FaIcon(FontAwesomeIcons.xmark),
            label: const Text("Fermer"),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.red.shade50),
              foregroundColor: WidgetStateProperty.all(Colors.red),
              iconColor: WidgetStateProperty.all(Colors.red),
            ),
          ),
          TextButton.icon(
            onPressed: () =>
                pushReplaceForm(context, destination: const HomePage()),
            iconAlignment: IconAlignment.end,
            icon: const FaIcon(FontAwesomeIcons.rotateRight),
            label: const Text("Rééssayer"),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue.shade50),
              foregroundColor: WidgetStateProperty.all(Colors.blue),
              iconColor: WidgetStateProperty.all(Colors.blue),
            ),
          )
        ],
      );
    } catch (e) {
      e.printError();
      showSnackBar(
          context: context,
          message: "Une erreur s'est produite",
          type: SnackBarType.danger);
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
          /* actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Stack(
                children: [
                  IconButton(
                      onPressed: () => pushForm(context,
                          destination: const NotificationsPage()),
                      icon: const FaIcon(FontAwesomeIcons.solidBell)),
                  const Positioned(
                    top: 7,
                    right: 10,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.red,
                    ),
                  )
                ],
              ),
            )
          ], */
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
            /* BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.earListen),
                label: "Aide sociale"), */
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.circleUser), label: "Profil"),
          ],
        ),
        extendBodyBehindAppBar: _currentPageIndex == 0,
        drawer: MenuDrawer(
          pageIndex: 0,
        ),
        body: user != null ? [
          Consumer<User>(
            builder: (context, userProvider, child) {
              return FrontPage(
                churchId: userProvider.user.churchId,
                setOpacity: setOpacity
              );
            },
          ),
          const CommunityPage(),
          Consumer<User>(
            builder: (context, userProvider, child) {
              return UserProfil(user: userProvider.user, isSelf: true);
            },
          ),
        ][_currentPageIndex] : Center(
          child: Text('chargement...'),
        ),
        floatingActionButton: getFloatingButton(user != null ? user!.accountType : ""),
      ),
    );
  }

  FloatingActionButton? getFloatingButton(String accountType){
    if (_currentPageIndex != 1){
      return null;
    }
    if (accountType != UserModel.servant){
      return null;
    }
    return FloatingActionButton(
      onPressed: () => pushForm(context, destination: const CreatePostForm()),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
      child: FaIcon(FontAwesomeIcons.feather),
    );
  }
}
