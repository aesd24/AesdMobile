import 'package:aesd_app/models/church_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserModel {
  late int? id;
  late String name;
  late String email;
  late String phone;
  late String? photo;
  late String adress;
  late String accountType;
  late int? churchId;
  late ChurchModel? church;

  static String get servant => "serviteur_de_dieu";
  static String get faithful => "fidele";
  static String get singer => "chantre";

  Widget tile() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(photo!),
      ),
      title: Text(name),
      subtitle: Text(email),
      trailing: accountType == 'serviteur_de_dieu' ? CircleAvatar(
        radius: 17,
        backgroundColor: Colors.blue,
        child: FaIcon(
          FontAwesomeIcons.cross,
          color: Colors.white,
          size: 15,
        ),
      ) : null,
    );
  }
  
  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'] ?? "";
    adress = json['adresse'] ?? "";
    phone = json['phone'] ?? "";
    photo = json['profile_photo_url'];
    accountType = json['account_type'];
    churchId = json['details'] == null ? null : json['details']['church_id'];
    church = json['church'] == null ? null : ChurchModel.fromJson(json['church']);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'profile_photo_url': photo,
  };
}
