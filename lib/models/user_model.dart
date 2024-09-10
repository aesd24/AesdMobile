
import 'package:aesd_app/constants/dictionnary.dart';

class UserModel {
  late int? id;
  late String name;
  late String email;
  late String phone;
  late String photo;
  late bool isServant;
  late bool isSinger;
  late bool isFaithful;
  late num totalCoins;
  late Type? accountType;
  late bool canManage = true;

  UserModel();

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = id == null ? "" : json['name'];
    email = id == null ? "" : json['email'];
    phone = id == null ? "" : json['phone'];
    photo = id == null ? "" : json['profile_photo_url'];
    isServant = id == null ? false : json['is_servant'];
    isSinger = json['is_singer'] ?? false;
    isFaithful = json['is_faithful'] ?? false;
    accountType = id == null ? null : isFaithful ? accountTypes[0] : isServant ? accountTypes[1] : isSinger ? accountTypes[2] : null;
    totalCoins = json['total_coins'] ?? 0;
    canManage = json['can_manage'] ?? false;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'profile_photo_url': photo,
    'is_servant': isServant,
    'is_singer': isSinger,
    'is_faithful': isFaithful,
    'total_coins': totalCoins,
    'can_manage': canManage,
  };
}
