
import 'package:intl/intl.dart';

class StreamVideoModel {
  late int id;
  late String title;
  late String slug;
  late String description;
  late String image;
  late String youtubeUrl;
  String? youtubeId;
  late String ownerName;
  late String dateTime;
  String? agoraToken;
  int? agoraChannelId;
  String? agoraChannelName;

  StreamVideoModel();

  StreamVideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    image = json['thumbnail_url'] ?? 'https://eglisesetserviteursdedieu.com/images/hero-welcome.jpg';
    youtubeUrl = json['url'];
    youtubeId = json['youtube_id'];
    ownerName = json['owner']['name'];
    DateTime date = DateTime.parse(json['scheduled_start_time']);
    dateTime = DateFormat('d MMM yyyy à HH:mm').format(date);
    agoraToken = json['agora_token'];
    agoraChannelId = int.parse(json['agora_channel_id'].toString());
    agoraChannelName = json['agora_channel_name'];
  }
}
