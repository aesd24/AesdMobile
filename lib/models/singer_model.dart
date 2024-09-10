import 'package:aesd_app/models/user_model.dart';

class SingerModel {
  late String managerName;
  late String description;
  late String phone;
  late UserModel user;

  SingerModel();

  SingerModel.fromJson(Map<String, dynamic> json) {
    managerName = json['manager_name'];
    description = json['description'];
    phone = json['phone'];
    user = UserModel.fromJson(json['user']);
  }
}
