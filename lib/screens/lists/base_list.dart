import 'package:flutter/material.dart';

class BaseList extends StatelessWidget {
  BaseList({super.key, required this.list});

  List<Widget> list;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.center,
        runSpacing: 10,
        children: List.generate(list.length, (index) {
          var current = list[index];
          return current;
        }),
      ),
    );
  }
}
