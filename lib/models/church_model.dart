import 'package:aesd_app/models/dictionary.dart';
import 'package:aesd_app/models/programm_model.dart';
import 'package:aesd_app/models/servant_model.dart';

class ChurchModel {
  late int? id;
  late String name;
  late String phone;
  late String email;
  late String address;
  late String description;
  late String logo;
  late String cover;
  late String image;
  late Dictionary type;
  late List<ServantModel> servants = [];
  late ServantModel? mainServant;
  late ProgrammModel? programm;

  ChurchModel();

  ChurchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = id == null ? "" : json['name'];
    image ='https://bretagneromantique.fr/wp-content/uploads/2021/04/IMG_4463-scaled.jpg';
    email = json['email'] ?? "";
    logo = json['logo_url'] ?? "";
    cover = json['cover_url'] ?? "";
    address = json['address'] ?? "";
    description = json['description'] ?? "";
    phone = id == null ? "" : "${json['dial_code']} + ${json['phone']}";
    type = Dictionary.fromJson(json['type'] ?? {});
    mainServant = json['main_servant'] != null
        ? ServantModel.fromJson(json['main_servant'])
        : null;
    json['servants']?.forEach((d) {
      servants.add(ServantModel.fromJson(d));
    });
    programm = json['program'] != null
        ? ProgrammModel.fromJson(json['program'])
        : null;
  }
}
