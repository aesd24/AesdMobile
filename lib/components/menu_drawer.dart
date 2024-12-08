//import 'package:aesd_app/models/user_model.dart';
import 'dart:io';

import 'package:aesd_app/components/dialog.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/providers/auth.dart';
import 'package:aesd_app/providers/user.dart';
import 'package:aesd_app/screens/new_version/dashboard/dashboard.dart';
import 'package:aesd_app/screens/new_version/home.dart';
import 'package:aesd_app/screens/new_version/wallet/wallet.dart';
import 'package:aesd_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatefulWidget {
  MenuDrawer({super.key, required this.pageIndex});

  int pageIndex;

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  //final AuthRequest _authRequest = AuthRequest();

  _refreshUserInfo() async {
    try {
      //final response = await _authRequest.getUserInfo();

      //final data = response.data;
    } finally {}
  }

  logout() async {
    try {
      Provider.of<Auth>(context, listen: false).logout().then((value) {
        Get.offAll(() => const SplashScreen());
      });
    } on HttpException catch (e) {
      showSnackBar(
          context: context, message: e.message, type: SnackBarType.danger);
    } catch (e) {
      e.printError();
      showSnackBar(
          context: context,
          message: "Une erreur s'est produite",
          type: SnackBarType.danger);
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context, listen: false).user;

    return RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.white,
        onRefresh: () => _refreshUserInfo(),
        child: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          user.email,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "(+225) ${user.phone}",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (user.accountType != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            user.accountType!,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.green),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _customTile(
                    id: 0,
                    title: "Accueil",
                    icon: const FaIcon(FontAwesomeIcons.house),
                    onTap: () => pushReplaceForm(context,
                        destination: const HomePage())),
                _customTile(
                    id: 1,
                    title: "Admin",
                    icon: const FaIcon(FontAwesomeIcons.gaugeHigh),
                    onTap: () => pushReplaceForm(context,
                        destination: const Dashboard())),
                _customTile(
                  id: 2,
                  title: "Transactions",
                  icon: const FaIcon(FontAwesomeIcons.moneyBillTransfer),
                  onTap: () =>
                      pushReplaceForm(context, destination: const WalletForm()),
                ),
                _customTile(
                    id: 3,
                    title: "Nous contacter",
                    icon: const FaIcon(FontAwesomeIcons.envelope)),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextButton.icon(
                    onPressed: () => messageBox(context,
                        title: "Déconnexion",
                        content: const Text(
                            "Voulez vous vraiment vous déconnecter ?"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      Colors.grey.shade300),
                                  foregroundColor:
                                      WidgetStateProperty.all(Colors.grey)),
                              child: const Text("Annuler")),
                          TextButton(
                              onPressed: () async => await logout(),
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      Colors.red.shade100),
                                  foregroundColor:
                                      WidgetStateProperty.all(Colors.red)),
                              child: const Text("Déconnexion"))
                        ]),
                    label: const Text("Se déconnecter"),
                    icon: const FaIcon(FontAwesomeIcons.rightFromBracket),
                    iconAlignment: IconAlignment.end,
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.red.withOpacity(.2)),
                        foregroundColor: WidgetStateProperty.all(Colors.red),
                        overlayColor: WidgetStateProperty.all(
                            Colors.red.withOpacity(.2))),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _customTile(
      {required int id,
      required String title,
      required Widget icon,
      void Function()? onTap}) {
    bool selected = widget.pageIndex == id;
    return Card(
      color: !selected ? Colors.green : Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
          side: selected
              ? const BorderSide(color: Colors.green, width: 1.5)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      child: ListTile(
          leading: icon,
          onTap: onTap,
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: !selected ? Colors.white : Colors.green),
          ),
          iconColor: !selected ? Colors.white : Colors.green),
    );
  }
}
