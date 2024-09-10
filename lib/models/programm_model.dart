class ProgrammModel {
  late String? monday;
  late String? tuesday;
  late String? wednesday;
  late String? thursday;
  late String? friday;
  late String? saturday;
  late String? sunday;

  ProgrammModel();

  ProgrammModel.fromJson(Map<String, dynamic> json) {
    monday = json['monday'];
    tuesday = json['tuesday'];
    wednesday = json['wednesday'];
    thursday = json['thursday'];
    friday = json['friday'];
    saturday = json['saturday'];
    sunday = json['sunday'];
  }
}
