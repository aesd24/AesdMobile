import 'package:aesd_app/models/stream_video_model.dart';

class StreamModel {
  late String date;
  late List<StreamVideoModel> videos = [];

  StreamModel();

  StreamModel.fromJson(String d, List json) {
    date = d;

    for (var item in json) {
      videos.add(StreamVideoModel.fromJson(item));
    }
  }
}
