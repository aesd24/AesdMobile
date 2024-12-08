import 'package:aesd_app/models/church_model.dart';

class UserModel {
  late int? id;
  late String name;
  late String email;
  late String phone;
  late String photo;
  late String adress;
  late String accountType;
  late ChurchModel? church;

  UserModel();

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'] ?? "";
    adress = json['adress'] ?? "";
    phone = json['phone'] ?? "";
    photo = json['profile_photo_url'] ?? "";
    accountType = json['account_type'];
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
