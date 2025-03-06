import 'package:aesd_app/models/church_model.dart';
import 'package:aesd_app/models/dictionary.dart';
import 'package:aesd_app/models/user_model.dart';

class ServantModel {
  late Dictionary title;
  late UserModel user;
  late int? userId;
  late ChurchModel church;
  late int? churchId;

  ServantModel();

  ServantModel.fromJson(Map<String, dynamic> json) {
    title = Dictionary.fromJson(json['title'] ?? {});
    user = UserModel.fromJson(json['user'] ?? {});
    userId = json['user_id'];
    church = ChurchModel.fromJson(json['church'] ?? {});
    churchId = json['church_id'];
  }
}
