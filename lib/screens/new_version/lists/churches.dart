import 'package:aesd_app/models/church_model.dart';
import 'package:aesd_app/providers/church.dart';
import 'package:aesd_app/screens/new_version/lists/base_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChurchList extends StatefulWidget {
  const ChurchList({super.key});

  @override
  State<ChurchList> createState() => _ChurchListState();
}

class _ChurchListState extends State<ChurchList> {
  late List<ChurchModel> _churches;

  @override
  void initState() {
    _churches = Provider.of<Church>(context, listen: false).churches;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseList(list: _churches.map((e) => e.card(context)).toList());
  }
}
