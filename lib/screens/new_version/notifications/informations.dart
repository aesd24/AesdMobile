import 'package:aesd_app/models/notification.dart';
import 'package:flutter/material.dart';

class Informations extends StatefulWidget {
  const Informations({super.key});

  @override
  State<Informations> createState() => _InformationsState();
}

class _InformationsState extends State<Informations> {

  final _Notifications = List.generate(10, (index) {
    return NotificationModel.fromJson({
      'id': index,
      'title': 'Notification $index',
      'content': 'This is a notification $index',
      'date': DateTime.now(),
      'readed': index % 2 == 0 ? 1 : 0,
      'notificationType': 'information'
    });
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(_Notifications.length, (index) {
            var current = _Notifications[index];
            return current.getTile(context);
          }),
        ),
      ),
    );
  }
}