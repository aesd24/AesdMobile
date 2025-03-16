import 'package:flutter/material.dart';
import 'package:aesd_app/models/user_model.dart';

class SingerModel {
  late String manager;
  late String description;
  late String phone;
  late UserModel user;

  SingerModel.fromJson(Map<String, dynamic> json) {
    manager = json['manager'];
    description = json['description'];
    user = UserModel.fromJson(json['user']);
  }

  Widget card(BuildContext context){
    //ColorScheme themeColors = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.black))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // zone de présentation du serviteur
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 30,),
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: textTheme.titleMedium),
                  /* Text(call, style: textTheme.bodySmall!.copyWith(
                    color: Colors.black.withAlpha(150)
                  )), */
                ],
              ),
            ],
          ),

          /* if(church != null) Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.church, size: 20),
                SizedBox(width: 10),
                Text(church!.name, style: textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.bold
                )),
              ],
            )
          ) */
        ],
      ),
    );
  }
}
