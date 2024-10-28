import 'package:aesd_app/components/event.dart';
import 'package:aesd_app/components/title.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChurchProgram extends StatefulWidget {
  const ChurchProgram({super.key});

  @override
  State<ChurchProgram> createState() => _ChurchProgramState();
}

class _ChurchProgramState extends State<ChurchProgram> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customTitle(context, text: "Programme hebdomadaire"),
          SizedBox(
              height: 300,
              width: double.infinity,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(3, (index) {
                    return programBox(context);
                  }))),
          const SizedBox(height: 30),
          customTitle(context, text: "Evènements"),
          SizedBox(
            height: 400,
            width: double.infinity,
            child: SingleChildScrollView(
                child: Column(
                    children: List.generate(10, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: customEventBox(context,
                    title: "Evenement ${index + 1}",
                    date: "${index + 1}/${index + 1}/2024",
                    height: 160),
              );
            }))),
          )
        ],
      ),
    );
  }

  Container programBox(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(right: 10),
      width: size.width - 50,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 1.5),
          borderRadius: BorderRadius.circular(7)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text("Lundi",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 230,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(3, (index) {
                  return Column(
                    children: [
                      programTile(context,
                          title: "Programme $index",
                          time: "$index h00 - $index h00",
                          place: "Lieu $index"),
                      if (index != 2) const Divider(),
                    ],
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget programTile(
  BuildContext context, {
  required String title,
  required String time,
  required String place,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(time,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              Text(title, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.locationPin,
                size: 15,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 7,
              ),
              Text(place)
            ],
          )
        ],
      ),
    );
  }
}
