import "package:flutter/material.dart";

Widget customButton({
  required BuildContext context,
  required String text,
  required void Function() onPressed,
  double? elevation,
  Color? backgroundColor,
  Color? foregroundColor,
  Color? highlightColor,
  BorderSide? border,
  Widget? trailing
}){
  return SizedBox(
    width: double.infinity,
    child: MaterialButton(
      onPressed: onPressed,
      color: backgroundColor ?? Colors.green,
      highlightColor: highlightColor,
      splashColor: highlightColor,
      padding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        side: border ?? BorderSide.none,
        borderRadius: BorderRadius.circular(7),
      ),
      elevation: elevation ?? 2,
      child: Row(
        mainAxisAlignment: trailing != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: foregroundColor ?? Colors.white,
            ),
          ),
          if (trailing != null) trailing,
        ],
      )
    ),
  );
}

Widget returnButton({required BuildContext context}){
  return Container(
    //padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.green,
    ),
    child: IconButton(
      onPressed: (){
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.arrow_back, color: Colors.white)
    ),
  );
}

Widget customDashbordButton({
  required BuildContext context,
  required String text,
  Icon? icon,
  void Function()? function
}){
    return Card(
      color: Colors.green.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          width: 2,
          color: Colors.green,
        )
      ),
      child: ListTile(
        onTap: function,
        leading: icon,
        title: Text(text),
        textColor: Colors.green.shade900,
        iconColor: Colors.green.shade900,
        trailing: const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }