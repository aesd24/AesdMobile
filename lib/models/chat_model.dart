import 'package:aesd_app/models/user_model.dart';

class ChatModel {
  late int id;
  late String lastMessage;
  late String time;
  late bool isActive;
  late bool isApproved;
  late UserModel guest;
  late UserModel owner;

  ChatModel();

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = "9 minutes";
    isActive = false;
    isApproved = json['is_approved'] == 0 ? false : true;
    lastMessage = json['last_message'];
    guest = UserModel.fromJson(json['guest']);
    owner = UserModel.fromJson(json['owner']);
  }
}
