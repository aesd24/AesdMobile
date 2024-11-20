import 'package:flutter/material.dart';

messageBox(BuildContext context, {
  required String title,
  required Widget content,
  Widget? icon,
  bool isDismissable = true,
  List<Widget>? actions,
  Function()? onOk
}){
  showDialog(
    context: context,
    barrierDismissible: isDismissable,
    builder: (context){
      return AlertDialog(
        icon: icon,
        title: Text(title),
        content: content,
        actions: actions ?? [
          TextButton(
            onPressed: onOk,
            child: const Text("Ok"),
          )
        ]
      );
    }
  );
}