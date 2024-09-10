import 'package:aesd_app/models/user_model.dart';
import 'package:aesd_app/utils/time_ago.dart';

class MessageModel {
  late int id;
  late String message;
  late UserModel sender;
  late String time;
  late int inboxId;
  late DateTime createdAt = DateTime.now();

  MessageModel({
    required this.message,
    required this.sender,
    required this.inboxId,
    required this.time,
    required DateTime createdAt,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    sender = UserModel.fromJson(json['sender']);
    inboxId = json['inbox_id'];
    createdAt = DateTime.parse(json['created_at']);
    time = TimeAgo.timeAgoSinceDate(createdAt.toString());
  }
}
