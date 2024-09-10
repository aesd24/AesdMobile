class Dictionary {
  late String code;
  late String description;

  Dictionary();

  Dictionary.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? "";
    description = json['real_description'] ?? "";
  }
}
