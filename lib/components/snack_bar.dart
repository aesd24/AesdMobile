import "package:flutter/material.dart";

void showSnackBar(
    {required BuildContext context,
    required String message,
    SnackBarType? type}) {
  type ??= SnackBarType.info;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      children: [
        Icon(type!.icon, color: type.fgColor, size: 20),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            message,
            overflow: TextOverflow.clip,
            style: TextStyle(color: type.fgColor),
          ),
        ),
      ],
    ),
    elevation: 2,
    duration: const Duration(seconds: 3),
    backgroundColor: type.bgColor,
  ));
}

class SnackBarType {
  late Color bgColor;
  late Color fgColor;
  late IconData icon;

  SnackBarType(
      {required this.bgColor, required this.fgColor, required this.icon});

  static get danger => SnackBarType(
      bgColor: Colors.red, fgColor: Colors.white, icon: Icons.dangerous);

  static get warning => SnackBarType(
      bgColor: Colors.orange, fgColor: Colors.white, icon: Icons.warning);

  static get success => SnackBarType(
      bgColor: Colors.green, fgColor: Colors.white, icon: Icons.check_circle);

  static get info => SnackBarType(
      bgColor: Colors.blue, fgColor: Colors.white, icon: Icons.info);
}
