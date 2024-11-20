import 'package:aesd_app/models/notification.dart';
import 'package:flutter/material.dart';

class Demandes extends StatefulWidget {
  const Demandes({super.key});

  @override
  State<Demandes> createState() => _DemandesState();
}

class _DemandesState extends State<Demandes> {
  final _Notifications = List.generate(10, (index) {
    return NotificationModel.fromJson({
      'id': index,
      'title': 'Notification $index',
      'content': 'This is a notification $index',
      'date': DateTime.now(),
      'readed': index % 2 != 0 ? 1 : 0,
      'notificationType': 'demande'
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
