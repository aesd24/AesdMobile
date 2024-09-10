
class CoinPlanModel {
  late int id;
  late String name;
  String? image;
  late int value;

  CoinPlanModel();

  CoinPlanModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    value = json['value'];
  }
}