class OptionModel {
  late int id;
  late String option;
  late bool isCorrect;

  OptionModel();

  OptionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    option = json['option'];
    isCorrect = json['correct'] == 1;
  }
}
