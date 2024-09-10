import 'dart:io';
import 'package:flutter/material.dart';

Widget customRoundedAvatar({
  required File? image,
  String? overlayText
})
{
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.green.shade100,
      borderRadius: BorderRadius.circular(100)
    ),
    child: Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: image == null ? Colors.white : null,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.green.shade300)],
        image: image != null ? DecorationImage(
          image: FileImage(image),
          fit: BoxFit.cover
        ) : null
      ),
      alignment: Alignment.center,
      child: overlayText != null ? image == null ? Text(
        overlayText,
        textAlign: TextAlign.center,
      ) : null : null,
    ),
  );
}

Widget imageSelectionBox({
  required BuildContext context,
  required String label,
  required File? picture,
  required void Function()? onClick,
  IconData? icon,
  Color? backgroundColor,
  Color? borderColor,
  Color? foregroundColor,
  double? height,
  String? overlayText,
}){

  backgroundColor = backgroundColor ?? Colors.green.shade100;
  foregroundColor = foregroundColor ?? Theme.of(context).colorScheme.primary;
  borderColor = borderColor ?? Theme.of(context).colorScheme.primary;
  Size size = MediaQuery.of(context).size;

  return GestureDetector(
    onTap: onClick,
    child: Container(
      height: height ?? size.height * .3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: picture == null ? Border.all(color: borderColor, width: 2) : null,
        borderRadius: BorderRadius.circular(7),
        color: picture == null ? backgroundColor : null,
        image: picture != null ? DecorationImage(
          image: FileImage(picture),
          fit: BoxFit.cover
        ) : null
      ),
      child: picture == null ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Icon(icon, size: 40, color: foregroundColor,)
          ],
        )
      ) : overlayText != null ? Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(7)
        ),
        child: Center(
          child: Text(
            overlayText,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white
            ),
          ),
        ),
      ) : null,
    ),
  );
}