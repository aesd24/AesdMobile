import "package:flutter/material.dart";

void showSnackBar({
  required BuildContext context,
  required String message,
  IconData? icon,
  String? type,
  Color?  bgColor,
  Color fgColor = Colors.white
}){
  if (type != null){
    if (type == "danger") {
      bgColor = Colors.red;
      icon = Icons.dangerous;
    } else if (type == "warning"){
      bgColor = Colors.orange;
      icon = Icons.warning;
    } else if (type == "success"){
      bgColor = Colors.green;
      icon = Icons.check_circle;
    }
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: fgColor, size: 20),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: fgColor
              ),
            ),
          ),
        ],
      ),
      elevation: 2,
      duration: const Duration(seconds: 3),
      backgroundColor: bgColor ?? Colors.red,
    )
  );
}