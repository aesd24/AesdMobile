import 'package:flutter/material.dart';

Widget toggleLink({
  required BuildContext context,
  required Widget targetPage,
  required String label,
  required String linkText,
  bool dark = false
}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: dark ? Colors.white : null
        ),
      ),
      const SizedBox(width: 5),
      GestureDetector(
        onTap: (){
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => targetPage),
            (route) => false
          );
        },
        child: Text(
          linkText,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Colors.green,
            fontWeight: FontWeight.bold
          )
        )
      )
    ]
  );
}