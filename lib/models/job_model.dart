import 'package:aesd_app/models/dictionary.dart';
import 'package:intl/intl.dart';

class JobModel {
  late String title;
  late String description;
  late String shortDescription;
  late String postProfile;
  late String requirement;
  late String localisation;
  late String deadline;
  late Dictionary contract;
  late Dictionary experience;
  late Dictionary studyLevel;

  JobModel();

  JobModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    DateTime dateTime = DateTime.parse(json['deadline']);
    deadline = DateFormat('d MMM yyyy').format(dateTime);
    description = json['description'];
    shortDescription = json['short_description'];
    postProfile = json['post_profile'];
    requirement = json['requirement'];
    localisation = json['localisation'];
    contract = Dictionary.fromJson(json['contract']);
    experience = Dictionary.fromJson(json['experience']);
    studyLevel = Dictionary.fromJson(json['study_level']);
  }
}
