import 'package:aesd_app/models/church_model.dart';

class CeremonyModel {
  late String title;
  late String description;
  late String video;
  late DateTime date;
  late ChurchModel churchOwner;

  CeremonyModel();

  CeremonyModel.fromJson(json){
    title = json['title'];
    description = json['description'];
    video = json['video_url'];
    date = DateTime.parse(json['event_date']);
    churchOwner = ChurchModel.fromJson(json['church']);
  }

  toJson() => {
    'title': title,
    'description': description,
    'video_url': video,
    'date': date,
    'church': churchOwner.name,
  };
}