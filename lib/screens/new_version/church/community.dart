import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/components/title.dart';
import 'package:flutter/material.dart';

class ChurchCommunity extends StatefulWidget {
  const ChurchCommunity({super.key});

  @override
  State<ChurchCommunity> createState() => _ChurchCommunityState();
}

class _ChurchCommunityState extends State<ChurchCommunity> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customTitle(context, text: "Liste des serviteurs"),
          SizedBox(
            height: 250,
            child: ListView(
              children: List.generate(4, (index) {
                return servantTile(
                  context,
                  name: "Serviteur $index",
                  call: "Pasteur $index",
                  isMain: index == 0,
                );
              }),
            ),
          ),
          const SizedBox(height: 50),
          customTitle(context, text: "Liste des fidèles"),
          customTextField(
              label: "Recherchez", prefixIcon: const Icon(Icons.search)),
          Center(
            child: Wrap(
              spacing: 5,
              runSpacing: 7,
              children: List.generate(5, (index) {
                return faithfulBox(context, name: "Nom du fidèle $index");
              }),
            ),
          )
        ],
      ),
    );
  }

  Container faithfulBox(BuildContext context, {required String name}) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      width: (size.width * .5) - 25,
      decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: Colors.green),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          const CircleAvatar(),
          const SizedBox(height: 10),
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget servantTile(BuildContext context,
      {required String name, required String call, required bool isMain}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 1.5),
          borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        title: Text(
          name,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          call,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: isMain
            ? Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1.5),
                    borderRadius: BorderRadius.circular(3)),
                child: const Text(
                  "Principale",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              )
            : null,
      ),
    );
  }
}
