import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // liste des notifications
  final _notifications = List.generate(10, (index) {
    return NotificationModel.fromJson({
      'id': index,
      'title': 'Notification $index',
      'content': 'This is a notification $index',
      'date': DateTime.now(),
      'readed': 0,
      'notificationType': index % 2 == 0 ? 'information' : 'demande'
    });
  });

  Future _refresh() async {
    await Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Notifications"),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              icon: const FaIcon(FontAwesomeIcons.sort),
              itemBuilder: (context) {
                return [];
              },
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async => await _refresh(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // barre de recherche
                  customTextField(
                    label: "Recherche",
                    prefixIcon: const Icon(Icons.search),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: List.generate(_notifications.length, (index) {
                      var current = _notifications[index];
                      return current.getTile(context);
                    }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
