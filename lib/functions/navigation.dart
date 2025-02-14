import 'package:flutter/material.dart';

pushForm(BuildContext context, {required Widget destination}) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => destination));
}

pushReplaceForm(BuildContext context, {required Widget destination}) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => destination));
}

closeForm(BuildContext context) {
  Navigator.of(context).pop();
}

closeAllAndPush(BuildContext context, Widget page) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => page),
    (Route<dynamic> route) => false,
  );
}
