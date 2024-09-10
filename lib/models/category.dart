class Category {
  late String name;

  Category();

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}
