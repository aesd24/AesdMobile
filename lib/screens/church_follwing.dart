import 'package:aesd_app/screens/phonebookstabs/church_list.dart';
import 'package:flutter/material.dart';

class ChurchFollowing extends StatefulWidget {
  const ChurchFollowing({super.key});

  @override
  State<ChurchFollowing> createState() => _ChurchFollowingState();
}

class _ChurchFollowingState extends State<ChurchFollowing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes suivies: Eglises'),
      ),
      body: const ChurchList(onlyFollower: true,),
    );
  }
}
