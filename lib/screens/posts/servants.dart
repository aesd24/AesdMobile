import 'package:flutter/material.dart';

class ServantList extends StatefulWidget {
  const ServantList({super.key});

  @override
  State<ServantList> createState() => _ServantListState();
}

class _ServantListState extends State<ServantList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Serviteurs"),
    );
  }
}