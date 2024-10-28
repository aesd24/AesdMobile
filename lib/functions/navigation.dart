import 'package:flutter/material.dart';

pushForm(BuildContext context, {required Widget destination}) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => destination));
}
