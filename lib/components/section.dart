import 'package:aesd_app/functions/navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget customSection(BuildContext context, {
  required String title,
  required List<Widget> children,
  required Widget viewAllPage,
  Axis scrollDirection = Axis.horizontal,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              if (children.isNotEmpty) TextButton.icon(
                onPressed: () => pushForm(context, destination: viewAllPage),
                icon: const Icon(Icons.add),
                iconAlignment: IconAlignment.end,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.green.shade400),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  iconColor: WidgetStateProperty.all(Colors.white)
                ),
                label: const Text("Voir plus"),
              )
            ],
          ),
        ),
        if (children.isEmpty) SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.circleExclamation,
                size: 40, color: Colors.grey.shade300
              ),
              SizedBox(height: 10),
              Text(
                "Aucun élément à afficher pour le moment",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.grey
                ),
              )
            ],
          )
        ),
        if (children.isNotEmpty) scrollDirection == Axis.horizontal ? SingleChildScrollView(
          scrollDirection: scrollDirection,
          child: Row(children: children)
        ) : ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * .5
          ),
          child: SingleChildScrollView(
            child: Column(children: children)
          )
        ),
      ],
    ),
  );
}
