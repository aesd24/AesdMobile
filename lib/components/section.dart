import 'package:aesd_app/functions/navigation.dart';
import 'package:flutter/material.dart';

Widget customSection(BuildContext context, {
  required String title,
  required List<Widget> children,
  required Widget viewAllPage,
  double childrenHeight = 150,
  Axis scrollDirection = Axis.horizontal,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => pushForm(context, destination: viewAllPage),
              icon: const Icon(Icons.add),
              iconAlignment: IconAlignment.end,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.green.shade400),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              label: const Text("Voir plus"),
            )
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: scrollDirection == Axis.horizontal ? 150 : 450,
          width: double.infinity,
          child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: scrollDirection,
              children: children),
        ),
      ],
    ),
  );
}
