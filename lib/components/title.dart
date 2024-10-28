import "package:flutter/material.dart";

Padding customTitle(
  BuildContext context, {
  required String text,
}) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
      ));
}
