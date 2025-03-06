import 'package:aesd_app/models/church_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CeremonyModel {
  late String title;
  late String description;
  late String video;
  late DateTime date;
  late ChurchModel churchOwner;

  CeremonyModel.fromJson(json){
    title = json['title'];
    description = json['description'];
    video = json['media'];
    date = DateTime.parse(json['event_date']);
    churchOwner = ChurchModel.fromJson(json['church']);
  }

  toJson() => {
    'title': title,
    'description': description,
    'video_url': video,
    'date': date,
    'church': churchOwner.name,
  };

  Widget card(BuildContext context) {
    return InkWell(
    overlayColor: WidgetStateProperty.all(Colors.orange.shade50),
    onTap: () {},
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(7)
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
                Text(
                  "${date.day}/${date.month}/${date.year}",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.white70
                  ),
                )
              ]
            ),
          ),
    
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade700
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: (){},
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.amber.shade100),
                          iconColor: WidgetStateProperty.all(Colors.amber)
                        ),
                        icon: FaIcon(FontAwesomeIcons.pen, size: 20)
                      ),
                      IconButton(
                        onPressed: (){},
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red.shade100),
                          iconColor: WidgetStateProperty.all(Colors.red)
                        ),
                        icon: FaIcon(FontAwesomeIcons.trash, size: 20)
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
  }
}